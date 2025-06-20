import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../data/models/udfOptionsModel.dart';

class SearchService {
  // static const token = 'mco8u0yj7cahfojh6ey909ep4ajvu5';
  static const token = 'p0gqjthl00p11djt4btzpyqp2yvi4w';

  static const String _endpointBase =
      'https://test.eresourcescheduler.cloud/rest/bookingchart';

  // static const String _endpointBase = 'https://varun-pc.eresourcescheduler.cloud:8443/rest/bookingchart';

  static const String _endpointProject =
      '$_endpointBase/projects/?editableOnly=true&q=';
  static const String _endpointResource =
      '$_endpointBase/resources/?editableOnly=true&q=';
  static const String _endpointTasksBase = '$_endpointBase/projects';
  static const String _endpointResourceBase = '$_endpointBase/resources/';

  static const String _endpointTagsBase =
      "https://test.eresourcescheduler.cloud/rest/tags?q=";

  static const String _endpointRequirementBase =
      "$_endpointBase/requirements/?editableOnly=true&q=";

  static const String _endpointRequirement =
      "https://test.eresourcescheduler.cloud/rest/v1/requirements/";

  static const String _endpointImageBase =
      'https://varun-pc.eresourcescheduler.cloud:8443/img/';

  static Future<List<UdfOptionsModel>> searchProject(String query) async {
    print("Calling the Project endpoint");
    try {
      final uri = Uri.parse('$_endpointProject$query');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
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
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> data = body['data'];

        return data.map((project) {
          String? imageUrl;
          if (project['image_uuid'] != null &&
              project['image_uuid'].toString().isNotEmpty) {
            imageUrl = '$_endpointImageBase${project['image_uuid']}';
          }
          return UdfOptionsModel(
            id: project['id'],
            name: project['name'] ?? '',
            img: project['image_uuid'] ?? '',
            imgUrl: imageUrl,
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
  static Future<List<UdfOptionsModel>> searchRequirements(String query) async {
    print("In the requirements search service");
    final uri = Uri.parse('$_endpointRequirementBase$query');
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("Requirement response body --${response.body}");
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to requirement roles. Status: ${response.statusCode}',
        );
      }
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];

      return data.map((json) {
        final int id = json['id'];

        return UdfOptionsModel(id: id, name: json['name'] ?? '');
      }).toList();
    } catch (e) {
      print('RequirementSearchService error: $e');
      return [];
    }
  }

  static Future<List<UdfOptionsModel>> searchTags(String query) async {
    print("In the Tags search service");
    final uri = Uri.parse('$_endpointTagsBase$query');
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("Tags response body --${response.body}");
      if (response.statusCode != 200) {
        throw Exception('Failed to Tags. Status: ${response.statusCode}');
      }
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];

      return data.map((json) {
        final int id = json['id'];

        return UdfOptionsModel(id: id, name: json['text'] ?? '');
      }).toList();
    } catch (e) {
      print('TagsSearchService error: $e');
      return [];
    }
  }

  static Future<List<UdfOptionsModel>> searchTask(int projectId) async {
    print("calling Task");
    final uri = Uri.parse('$_endpointTasksBase/$projectId/tasks');
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
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
    print("calling Roles");
    final uri = Uri.parse('$_endpointResourceBase$resourceId/roles');
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
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
            (json) => UdfOptionsModel(
              id: json['id'],
              name: json['name'] ?? '',
              performing: json['performing'] ?? '',
            ),
          )
          .toList();
    } catch (e) {
      print('RolesSearchService error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> fetchRequirement(int requirementId) async {
    try{
      print("Fetching Requirements");
      String url = '$_endpointRequirement$requirementId';
      print(url);
      final response = await http.get(Uri.parse(url),headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    }catch(e){
      print('RequirementSearchService error: $e');
      return {};
    }
  }
}
