import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

// Define a Contact model class for the database
class ContactModel {
  final int? id;
  final String name;
  final String? phoneNumber;
  final String? email;
  final Uint8List? photo;
  final String? address;
  final String? notes;

  ContactModel({
    this.id,
    required this.name,
    this.phoneNumber,
    this.email,
    this.photo,
    this.address,
    this.notes,
  });

  // Convert a Contact into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'photo': photo,
      'address': address,
      'notes': notes,
    };
  }

  // Create a Contact from a Map
  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      photo: map['photo'],
      address: map['address'],
      notes: map['notes'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    
    _database = await _initDB('contacts.db');
    return _database!;
  }

  // Initialize database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create the contacts table
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phoneNumber TEXT,
        email TEXT,
        photo BLOB,
        address TEXT,
        notes TEXT
      )
    ''');
  }

  // CRUD Operations

  // Create a new contact
  Future<int> insertContact(ContactModel contact) async {
    final db = await instance.database;
    return await db.insert('contacts', contact.toMap());
  }

  // Read all contacts
  Future<List<ContactModel>> getAllContacts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('contacts');
    
    return List.generate(maps.length, (i) {
      return ContactModel.fromMap(maps[i]);
    });
  }

  // Read a single contact
  Future<ContactModel?> getContact(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ContactModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Update a contact
  Future<int> updateContact(ContactModel contact) async {
    final db = await instance.database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  // Delete a contact
  Future<int> deleteContact(int id) async {
    final db = await instance.database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}