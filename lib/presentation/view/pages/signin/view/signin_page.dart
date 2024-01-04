import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hw_dashboard_client/presentation/view/app_constants/spacing.dart';
import 'package:hw_dashboard_client/presentation/view/app_syntax_sugars/build_context.dart';
import 'package:hw_dashboard_client/usecases/account_usecases.dart';
import 'package:syntax_sugar/syntax_sugar.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Card(
          child: SizedBox(
            // height: 500,
            width: 400,
            child: Padding(
              padding: EdgeInsets.all(Space.space24),
              child: SignInForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _form = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sign In', style: context.text.displaySmall),
          const SizedBox(height: Space.space24),
          FormBuilderTextField(
            name: 'username',
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Username'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(2),
            ]),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: Space.space24),
          FormBuilderTextField(
            name: 'password',
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Password'),
            obscureText: true,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: Space.space24),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    print('SUBMITTING');
    _form.currentState?.saveAndValidate();
    if (_form.currentState!.validate()) {
      final values = _form.currentState!.value;
      final errors = await context.read<Account>().login(
            username: values.get('username'),
            password: values.get('password'),
          );
      if (errors != null && errors.isNotEmpty) {
        for (final error in errors.entries) {
          _form.currentState?.fields[error.key]?.invalidate(error.value);
        }
      } else {
        Future.delayed(Duration.zero, () => context.go('/'));
      }
    }
  }
}
