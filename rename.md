--
post_status => post_item_widget (store, controller)

--
post_item_header (HeadItemPostStatus)
post_item_header_actions (SelectOptionItemPosted)

post_text_content
post_image_content

post_reaction_overview (chung - 3)
- post_react_count_component(no need end with component: post_react_count is fine)
- share
- view

post_item_bottom_actions (EngagementActions)


===
Home


CreatePostWidget => CreatePostButtonComponent

BuildLoadingPost => PostCreationProgressComponent

load post khi mở screen home => show loading indicator hoặc shimmer loading

===
create post page:

DraggableOption => CreatePostDraggableOptionsComponent

BottomBarCreatePost ?? CreatePostBottomBar => CreatePostBottomBar la 1 list
cac BottomBarCreatePost la 1 build widget _createPostBottomBarItem()

/// Vidu
PostItemStore

xem chi tiet post su dung ProfileStore.posts

khi navigate sang man edit

pass PostItemStore.post qua

vd:

context.pop(
PostForm(initialPost: profileStore.post[index])
)






