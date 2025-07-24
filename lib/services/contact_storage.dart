import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Contact {
  final String id;
  final String name;
  final String phone;

  Contact({required this.id, required this.name, required this.phone});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
    );
  }
}

class ContactStorageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  CollectionReference get _contactsCollection =>
      _firestore.collection('users').doc(userId).collection('contacts');

  Future<void> addContact(Contact contact) async {
    await _contactsCollection.doc(contact.id).set(contact.toMap());
  }

  Future<void> deleteContact(String id) async {
    await _contactsCollection.doc(id).delete();
  }

  Future<List<Contact>> getContacts() async {
    final querySnapshot = await _contactsCollection.get();
    return querySnapshot.docs
        .map((doc) => Contact.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
