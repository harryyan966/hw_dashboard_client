import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hw_dashboard_client/presentation/view/app_constants/spacing.dart';
import 'package:hw_dashboard_client/presentation/view/app_syntax_sugars/build_context.dart';
import 'package:hw_dashboard_client/presentation/view/pages/blogs/bloc/blogs_bloc.dart';
import 'package:hw_dashboard_domain/validators/blog_validators.dart';
import 'package:syntax_sugar/syntax_sugar.dart';

class CreateBlogsView extends StatefulWidget {
  const CreateBlogsView({super.key});

  @override
  State<CreateBlogsView> createState() => _CreateBlogsViewState();
}

class _CreateBlogsViewState extends State<CreateBlogsView> {
  final _form = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlogsBloc, BlogsState>(
      listenWhen: (_, current) => current.createBlogErrors != null,
      listener: (context, state) {
        if (state.createBlogErrors!.isEmpty) {
          Navigator.pop(context);
        } else {
          final errors = state.createBlogErrors!;
          for (final error in errors.asMap.entries) {
            final field = _form.currentState?.fields[error.key];
            field?.invalidate(error.value);
          }
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Space.space96,
            vertical: Space.space24,
          ),
          child: FormBuilder(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Space.space24),
                Text('New Blog', style: context.text.displaySmall),
                const SizedBox(height: Space.space24),
                FormBuilderTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  name: 'title',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'A short, informative title',
                  ),
                  maxLength: 50,
                  buildCounter: (context, {required currentLength, required isFocused, required maxLength}) =>
                      Text('$currentLength / $maxLength'),
                  validator: BlogValidators.title().validate,
                ),
                const SizedBox(height: Space.space24),
                Expanded(
                  child: FormBuilderTextField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    name: 'content',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Text, straight to the point',
                    ),
                    buildCounter: (context, {required currentLength, required isFocused, required maxLength}) =>
                        Text('$currentLength / $maxLength'),
                    maxLength: 10000,
                    maxLines: null,
                    minLines: 10,
                    validator: BlogValidators.content().validate,
                  ),
                ),
                const SizedBox(height: Space.space24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Create Blog'),
                    ),
                    SizedBox(width: Space.space08),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
                const SizedBox(height: Space.space48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_form.currentState!.saveAndValidate()) {
      final values = _form.currentState!.value;
      context.read<BlogsBloc>().add(
            CreateBlog(
              title: values.get('title'),
              content: values.get('content'),
            ),
          );
    }
  }
}
