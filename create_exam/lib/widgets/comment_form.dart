import 'package:create_exam/models/comment.dart';
import 'package:create_exam/services/api_services.dart';
import 'package:flutter/material.dart';

class CommentForm extends StatefulWidget {
  final Function(Comment) onCommentCreated;

  CommentForm({required this.onCommentCreated});

  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _bodyController,
            decoration: InputDecoration(labelText: 'Comment'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a comment';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          _isSubmitting
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isSubmitting = true;
                      });

                      Comment newComment = Comment(
                        postId: 1,  // Assuming postId = 1 for simplicity
                        id: 0,      // id will be set by the API
                        name: _nameController.text,
                        email: _emailController.text,
                        body: _bodyController.text,
                      );

                      try {
                        Comment createdComment = await ApiService().createComment(newComment);
                        widget.onCommentCreated(createdComment);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to create comment')),
                        );
                      } finally {
                        setState(() {
                          _isSubmitting = false;
                        });
                      }
                    }
                  },
                  child: Text('Submit'),
                ),
        ],
      ),
    );
  }
}
