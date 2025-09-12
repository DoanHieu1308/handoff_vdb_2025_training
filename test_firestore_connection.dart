import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:handoff_vdb_2025/firebase_options.dart';

void main() async {
  print('🔍 Testing Firestore Connection...');
  
  try {
    // Initialize Firebase
    print('1. Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
    
    // Test Firestore connection
    print('2. Testing Firestore connection...');
    final firestore = FirebaseFirestore.instance;
    
    // Try to create a test document
    print('3. Creating test document...');
    await firestore.collection('_test').doc('connection').set({
      'timestamp': FieldValue.serverTimestamp(),
      'test': true,
    });
    print('✅ Test document created successfully');
    
    // Try to read the test document
    print('4. Reading test document...');
    final doc = await firestore.collection('_test').doc('connection').get();
    if (doc.exists) {
      print('✅ Test document read successfully');
      print('   Data: ${doc.data()}');
    } else {
      print('❌ Test document not found');
    }
    
    // Clean up test document
    print('5. Cleaning up test document...');
    await firestore.collection('_test').doc('connection').delete();
    print('✅ Test document deleted successfully');
    
    print('\n🎉 Firestore connection test PASSED!');
    print('✅ Database is ready for chat functionality');
    
  } catch (e) {
    print('\n❌ Firestore connection test FAILED!');
    print('Error: $e');
    
    if (e.toString().contains('NOT_FOUND')) {
      print('\n🔧 SOLUTION:');
      print('1. Go to: https://console.firebase.google.com/project/handoffvdb2025');
      print('2. Click "Firestore Database" in left menu');
      print('3. Click "Create database"');
      print('4. Choose "Start in test mode"');
      print('5. Select location: asia-southeast1');
      print('6. Click "Done"');
      print('7. Run this test again');
    } else if (e.toString().contains('PERMISSION_DENIED')) {
      print('\n🔧 SOLUTION:');
      print('1. Check Firestore rules in Firebase Console');
      print('2. Make sure rules allow read/write for testing');
    } else {
      print('\n🔧 SOLUTION:');
      print('1. Check internet connection');
      print('2. Verify Firebase project configuration');
      print('3. Check google-services.json file');
    }
  }
}

