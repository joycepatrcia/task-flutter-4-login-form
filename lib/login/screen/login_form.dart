import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/login/cubit/login_cubit.dart';
import 'package:flutter_login/login/models/models.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text("Authentication Failed"),
              ),
            );
        }
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'LOGIN',
                style: TextStyle(
                  color: const Color(0xFF514066),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              const InputUsername(),
              const SizedBox(height: 12),
              const InputPassword(),
              const SizedBox(height: 24),
              const ButtonSubmit(),
            ],
          ),
        ),
      ),
    );
  }
}

class InputUsername extends StatelessWidget {
  const InputUsername({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_usernameInput_textField'),
          onChanged: (value) =>
              context.read<LoginCubit>().usernameChanged(value),
          decoration: InputDecoration(
            labelText: 'Username',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            errorText:
                state.username.displayError == UsernameValidationError.empty
                    ? 'Invalid username'
                    : null,
          ),
        );
      },
    );
  }
}

class InputPassword extends StatelessWidget {
  const InputPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (value) =>
              context.read<LoginCubit>().passwordChanged(value),
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Password",
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            errorText: (() {
              switch (state.password.displayError) {
                case PasswordValidationError.minimumLength:
                  return 'Password must be at least 6 characters';
                case PasswordValidationError.empty:
                  return 'Password cannot be empty';
                default:
                  return null;
              }
            })(),
          ),
        );
      },
    );
  }
}

class ButtonSubmit extends StatelessWidget {
  const ButtonSubmit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF514066),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  context.read<LoginCubit>().loginSubmitted();
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              );
      },
    );
  }
}
