import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../data/models/udfOptionsModel.dart';

class SearchService {
  static const String _endpointProject =
      'https://test.eresourcescheduler.cloud/rest/bookingchart/projects/?editableOnly=true&q=';
  static const String _endpointResource =
      'https://test.eresourcescheduler.cloud/rest/bookingchart/resources/?editableOnly=true&q=';
  static const String _endpointTasksBase =
      'https://test.eresourcescheduler.cloud/rest/bookingchart/projects';
  static const String _endpointResourceBase =
      'https://test.eresourcescheduler.cloud/rest/bookingchart/resources/';

  static Future<List<UdfOptionsModel>> searchProject(String query) async {
    try {
      final uri = Uri.parse('$_endpointProject$query');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer p0gqjthl00p11djt4btzpyqp2yvi4w',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> data = body['data'];

        return data.map((project) {
          return UdfOptionsModel(
            id: project['id'],
            name: project['name'] ?? '',
          );
        }).toList();
      } else {
        throw Exception(
          'Failed to load project data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Optionally log error or route it to an error tracking system
      print('ProjectSearchService error: $e');
      return [];
    }
  }

  static Future<List<UdfOptionsModel>> searchResource(String query) async {
    print("In the Search Resource fxn");
    try {
      final uri = Uri.parse('$_endpointResource$query');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer p0gqjthl00p11djt4btzpyqp2yvi4w',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> data = body['data'];

        return data.map((project) {
          return UdfOptionsModel(
            id: project['id'],
            name: project['name'] ?? '',
          );
        }).toList();
      } else {
        throw Exception(
          'Failed to load Resource data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('ResourceSearchService error: $e');
      return [];
    }
  }

  static Future<List<UdfOptionsModel>> searchTask(int projectId) async {
    final uri = Uri.parse('$_endpointTasksBase/$projectId/tasks');
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer p0gqjthl00p11djt4btzpyqp2yvi4w',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to load tasks. Status: ${response.statusCode}');
      }
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];

      return data
          .map(
            (json) => UdfOptionsModel(id: json['id'], name: json['name'] ?? ''),
          )
          .toList();
    } catch (e) {
      print('TaskSearchService error: $e');
      return [];
    }
  }

  static Future<List<UdfOptionsModel>> searchRoles(int resourceId) async {
    final uri = Uri.parse('$_endpointResourceBase$resourceId/roles');
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer p0gqjthl00p11djt4btzpyqp2yvi4w',
          'Accept': 'application/json',
        },
      );

      print("response body --${response.body}");
      if (response.statusCode != 200) {
        throw Exception('Failed to load roles. Status: ${response.statusCode}');
      }
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];

      return data
          .map(
            (json) => UdfOptionsModel(id: json['id'], name: json['name'] ?? ''),
          )
          .toList();
    } catch (e) {
      print('RolesSearchService error: $e');
      return [];
    }
  }
}
