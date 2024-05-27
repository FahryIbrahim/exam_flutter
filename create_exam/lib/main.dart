import 'package:create_exam/models/comment.dart';
import 'package:create_exam/services/api_services.dart';
import 'package:create_exam/widgets/comment_form.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comments App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CommentsPage(),
    );
  }
}

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late Future<List<Comment>> futureComments;
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    fetchAndSetComments();
  }

  Future<void> fetchAndSetComments() async {
    futureComments = ApiService().fetchComments();
    futureComments.then((value) {
      setState(() {
        comments = value;
      });
    });
  }

  void _addComment(Comment comment) {
    setState(() {
      comments.add(comment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: futureComments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No comments found.'));
                } else {
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      Comment comment = comments[index];
                      return ListTile(
                        title: Text(comment.name),
                        subtitle: Text(comment.body),
                        trailing: Text(comment.email),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CommentForm(onCommentCreated: _addComment),
          ),
        ],
      ),
    );
  }
}
