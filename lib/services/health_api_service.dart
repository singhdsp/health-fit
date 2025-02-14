import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HealthApiService {
  static const String baseUrl =
      'https://health-monitor-api-x4xz.onrender.com/api/health/records';
  static const String deviceId = "1";

  Future<HealthRecordsResponse> fetchHealthRecords({
    String filter = '7d',
  }) async {
    final uri = Uri.parse('$baseUrl?deviceId=$deviceId&filter=$filter');
    debugPrint('Fetching health records from: $uri');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return HealthRecordsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load health records: ${response.statusCode}');
    }
  }
}

class HealthRecordsResponse {
  final List<HealthRecord> records;
  final HealthAverage average;

  HealthRecordsResponse({required this.records, required this.average});

  factory HealthRecordsResponse.fromJson(Map<String, dynamic> json) {
    return HealthRecordsResponse(
      records:
          (json['records'] as List)
              .map((item) => HealthRecord.fromJson(item))
              .toList(),
      average: HealthAverage.fromJson(json['average']),
    );
  }
}

class HealthAverage {
  final double spo2;
  final double pulse;
  final double temperature;

  HealthAverage({
    required this.spo2,
    required this.pulse,
    required this.temperature,
  });

  factory HealthAverage.fromJson(Map<String, dynamic> json) {
    return HealthAverage(
      spo2: json['spo2']?.toDouble() ?? 0.0,
      pulse: json['pulse']?.toDouble() ?? 0.0,
      temperature: json['temperature']?.toDouble() ?? 0.0,
    );
  }
}

class HealthRecord {
  final String deviceId;
  final int spo2;
  final int pulse;
  final double temperature;
  final DateTime recordedAt;

  HealthRecord({
    required this.deviceId,
    required this.spo2,
    required this.pulse,
    required this.temperature,
    required this.recordedAt,
  });

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      deviceId: json['deviceId']?.toString() ?? 'Unknown',
      spo2: (json['spo2'] as num?)?.toInt() ?? 0,
      pulse: (json['pulse'] as num?)?.toInt() ?? 0,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      recordedAt:
          DateTime.tryParse(json['recordedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  String get formattedDate => DateFormat('dd MMM yyyy').format(recordedAt);
  String get formattedTime => DateFormat('HH:mm').format(recordedAt);

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'spo2': spo2,
      'pulse': pulse,
      'temperature': temperature,
      'recordedAt': recordedAt.toIso8601String(),
    };
  }
}
