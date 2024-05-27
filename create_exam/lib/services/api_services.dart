import 'dart:convert';
import 'package:create_exam/models/comment.dart';
import 'package:http/http.dart' as http;
// import 'package:comments_app/models/comment.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/comments';

  Future<List<Comment>> fetchComments() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((comment) => Comment.fromJson(comment)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<Comment> createComment(Comment comment) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'postId': comment.postId,
        'name': comment.name,
        'email': comment.email,
        'body': comment.body,
      }),
    );

    if (response.statusCode == 201) {
      return Comment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create comment');
    }
  }
}
