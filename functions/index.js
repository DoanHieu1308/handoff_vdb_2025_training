const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const FCM_TOKENS_COLLECTION = "fcm_tokens"; // tên collection lưu token

exports.sendConversationNotification = functions.firestore
  .document("conversations/{conversationId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data() || {};
    const after = change.after.data() || {};

    // 1) Chỉ xử lý khi lastMessage đổi (bỏ qua update khác)
    if (before.lastMessage === after.lastMessage) return null;
    if (!after.lastMessage) return null;

    const conversationId = context.params.conversationId;
    const senderId = after.senderId;
    const content = after.lastMessage || "";
    // senderName có thể nằm trong participants map
    let senderName = "Người dùng";
    try {
      if (after.participants && after.participants[senderId] && after.participants[senderId].name) {
        senderName = after.participants[senderId].name;
      }
    } catch (err) { /* ignore */ }

    // 2) recipients = participantIds trừ sender
    const participantIds = Array.isArray(after.participantIds) ? after.participantIds : [];
    const recipients = participantIds.filter(id => id !== senderId);

    if (recipients.length === 0) return null;

    // 3) Lấy tokens (dùng Promise.all)
    const tokenPromises = recipients.map(uid =>
      admin.firestore().collection(FCM_TOKENS_COLLECTION).doc(uid).get()
        .then(doc => doc.exists ? doc.data()?.token : null)
    );

    const tokensRaw = await Promise.all(tokenPromises);
    const tokens = Array.from(new Set(tokensRaw.filter(t => !!t))); // dedupe & filter null

    if (tokens.length === 0) return null;

    // 4) Payload (notification + data)
    const message = {
      notification: {
        title: senderName,
        body: content,
      },
      data: {
        conversationId,
        senderId: senderId || "",
        click_action: "FLUTTER_NOTIFICATION_CLICK", // để onMessageOpenedApp xử lý
      },
      android: {
        priority: "high",
        notification: {
          channel_id: "chat_messages", // trùng với channel trên app
          visibility: "public",
          priority: "MAX",
          // color, icon có thể thêm nếu muốn:
          // color: "#16B978",
        }
      },
      tokens // send multicast
    };

    // 5) Gửi (sendMulticast hỗ trợ tối đa 500 token)
    try {
      const response = await admin.messaging().sendMulticast({
        tokens,
        notification: message.notification,
        android: message.android,
        data: message.data,
      });

      // 6) Xử lý kết quả: xoá token invalid
      const tokensToRemove = [];
      response.responses.forEach((resp, idx) => {
        if (!resp.success) {
          const err = resp.error;
          if (err && (err.code === 'messaging/invalid-registration-token' ||
                      err.code === 'messaging/registration-token-not-registered')) {
            tokensToRemove.push(tokens[idx]);
          }
        }
      });

      if (tokensToRemove.length > 0) {
        // Xoá doc token tương ứng (tìm doc có field token == that token)
        const colRef = admin.firestore().collection(FCM_TOKENS_COLLECTION);
        const q = await colRef.where('token', 'in', tokensToRemove).get();
        const batch = admin.firestore().batch();
        q.forEach(doc => batch.delete(doc.ref));
        await batch.commit();
      }

      return null;
    } catch (err) {
      console.error("Error sending multicast message", err);
      return null;
    }
  });
