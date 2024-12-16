// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:travel_buddy/screens/layout_screen.dart';
import '../blocs/auth_bloc/auth_bloc.dart';

class AuthFormScreen extends StatelessWidget {
  static const routeName = '/auth_form_screen';
  const AuthFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (BuildContext context) => AuthBloc(),
      child: const AuthForm(),
    );
  }
}

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          print("Authentication successful, navigating to LayoutScreen.");
          Navigator.pushNamed(context, LayoutScreen.routeName);
        } else if (state.status == FormStatus.error) {
          print("Authentication error: ${state.errorMsg}");
        }
      },
      child: Scaffold(
        body: isLoading
            ? const CircularProgressIndicator()
            : buildAuthForm(context),
      ),
    );
  }

  Widget buildAuthForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('WELCOME....BUDDY... 👋'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Log in'),
              Tab(text: 'Sign up'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            getAuthForm(context, "login"),
            getAuthForm(context, "signup"),
          ],
        ),
      ),
    );
  }

  Widget getAuthForm(BuildContext context, String authType) {
    final formKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                  labelText: 'Email', hintText: 'Enter your email'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your email' : null,
              onChanged: (value) =>
                  context.read<AuthBloc>().add(EmailChanged(value)),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your password' : null,
              onChanged: (value) =>
                  context.read<AuthBloc>().add(PasswordChanged(value)),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  authType == "login"
                      ? context.read<AuthBloc>().add(SignIn())
                      : context.read<AuthBloc>().add(SignUp());
                }
              },
              child: Text(authType == "login" ? 'Log in' : 'Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
