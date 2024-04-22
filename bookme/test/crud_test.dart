import 'package:flutter_test/flutter_test.dart';
import 'package:bookme/crud.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  group('CRUD Operations', () {
    late CRUD crud;
    late MockFirebaseAuth mockAuth;
    late MockFirebaseFirestore mockFirestore;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockFirestore = MockFirebaseFirestore();
      crud = CRUD(firebaseAuth: mockAuth, firestore: mockFirestore);
    });

    test('registerUser returns true on successful registration', () async {
      when(mockAuth.createUserWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => MockUserCredential());

      when(mockFirestore.collection('users').doc(any).set(any))
          .thenAnswer((_) async {});
      when(mockFirestore.collection('contact_lists').doc(any).set(any))
          .thenAnswer((_) async {});
      when(mockFirestore.collection('appointment_lists').doc(any).set(any))
          .thenAnswer((_) async {});

      bool result =
          await crud.registerUser('Test User', 'test@example.com', 'password');
      expect(result, isTrue);
    });

    test('registerUser handles exceptions', () async {
      when(mockAuth.createUserWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(FirebaseAuthException(code: 'auth/error'));

      bool result =
          await crud.registerUser('Test User', 'test@example.com', 'password');
      expect(result, isFalse);
    });

    test('signIn returns true on successful sign-in', () async {
      when(mockAuth.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => MockUserCredential());

      bool result = await crud.signIn('test@example.com', 'password');
      expect(result, isTrue);
    });

    test('signIn handles exceptions', () async {
      when(mockAuth.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(FirebaseAuthException(code: 'auth/error'));

      bool result = await crud.signIn('test@example.com', 'password');
      expect(result, isFalse);
    });

    test('fetchContacts returns contacts', () async {
      when(mockFirestore.collection('contact_lists').doc(any).get())
          .thenAnswer((_) async => MockDocumentSnapshot({
                'users_in_list': ['123456'],
              }));

      when(mockFirestore
              .collection('users')
              .where('user_ID', isEqualTo: anyNamed('isEqualTo'))
              .get())
          .thenAnswer((_) async => MockQuerySnapshot([
                MockDocumentSnapshot({
                  'name': 'John Doe',
                  'user_ID': '123456',
                }),
              ]));

      var contacts = await crud.fetchContacts();
      expect(contacts, isNotEmpty);
      expect(contacts.first['name'], equals('John Doe'));
    });

    test('addContact updates contact lists correctly', () async {
      when(mockFirestore.collection('users').doc(any).get())
          .thenAnswer((_) async => MockDocumentSnapshot({
                'user_ID': '123456',
              }));

      when(mockFirestore
              .collection('users')
              .where('user_ID', isEqualTo: '123456')
              .get())
          .thenAnswer((_) async =>
              MockQuerySnapshot([MockDocumentSnapshot(id: 'user123456')]));

      when(mockFirestore.collection('contact_lists').doc(any).update(any))
          .thenAnswer((_) async {});

      await crud.addContact('123456');
      verify(mockFirestore.collection('contact_lists').doc(any).update({
        'users_in_list': ['123456']
      })).called(1);
    });
  });
}
