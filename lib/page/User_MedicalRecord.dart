/*
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'medical_record.dart';

class MedicalRecordService {
  static final MedicalRecordService _instance =
      MedicalRecordService._internal();
  factory MedicalRecordService() => _instance;

  final List<MedicalRecord> _records = [];
  final _recordsController = StreamController<List<MedicalRecord>>.broadcast();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  MedicalRecordService._internal() {
    _loadRecords();
  }

  Stream<List<MedicalRecord>> get recordsStream => _recordsController.stream;

  Future<void> _loadRecords() async {
    final preferences = await _prefs;
    final recordsJson = preferences.getStringList('medical_records') ?? [];

    _records.clear(); // Clear existing records before loading
    _records.addAll(
      recordsJson.map((json) => MedicalRecord.fromMap(jsonDecode(json))),
    );

    _records.sort((a, b) => b.visitDate.compareTo(a.visitDate));
    _recordsController.add(_records);
  }

  Future<void> addRecord(MedicalRecord record) async {
    _records.add(record);
    await _saveRecords();
  }

  Future<void> updateRecord(MedicalRecord record) async {
    final index = _records.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      _records[index] = record;
      await _saveRecords();
    }
  }

  Future<void> deleteRecord(String id) async {
    _records.removeWhere((record) => record.id == id);
    await _saveRecords();
  }

  Future<void> _saveRecords() async {
    _records.sort((a, b) => b.visitDate.compareTo(a.visitDate));
    _recordsController.add(_records);

    final preferences = await _prefs;
    final recordsJson =
        _records.map((record) => jsonEncode(record.toMap())).toList();
    await preferences.setStringList('medical_records', recordsJson);
  }

  List<MedicalRecord> getRecords() {
    return List.unmodifiable(_records);
  }

  void dispose() {
    _recordsController.close();
  }
}
*/