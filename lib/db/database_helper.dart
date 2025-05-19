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
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        avatar TEXT,
        last_background_time INTEGER,
        total_background_time INTEGER DEFAULT 0
      )
    ''');
  }

  // CRUD Operations

  // Create a new contact
  Future<int> insertContact(Map<String, dynamic> contact) async {
    final db = await database;
    return await db.insert('contacts', contact);
  }

  // Read all contacts
  Future<List<Map<String, dynamic>>> getAllContacts() async {
    final db = await database;
    return await db.query('contacts', orderBy: 'name');
  }

  // Read a single contact
  Future<Map<String, dynamic>?> getContact(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // Update a contact
  Future<int> updateContact(Map<String, dynamic> contact) async {
    final db = await database;
    return await db.update(
      'contacts',
      contact,
      where: 'id = ?',
      whereArgs: [contact['id']],
    );
  }

  // Delete a contact
  Future<int> deleteContact(String id) async {
    final db = await database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close database
  Future close() async {
    final db = await database;
    db.close();
  }

  Future<void> updateBackgroundTime(String contactId, int backgroundTime) async {
    final db = await database;
    await db.rawUpdate('''
      UPDATE contacts 
      SET last_background_time = ?, 
          total_background_time = total_background_time + ? 
      WHERE id = ?
    ''', [backgroundTime, backgroundTime, contactId]);
  }
}