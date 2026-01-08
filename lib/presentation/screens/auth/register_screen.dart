// This screen allows new users to create an account with email and password
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_providers.dart';

// Register screen widget for creating new accounts
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); // For form validation
  final _firstNameController = TextEditingController(); // First name input
  final _lastNameController = TextEditingController(); // Last name input
  final _emailController = TextEditingController(); // Email input
  final _passwordController = TextEditingController(); // Password input
  final _confirmPasswordController = TextEditingController(); // Confirm password

  bool _isLoading = false; // Shows loading spinner
  String? _error; // Error message if signup fails

  // Clean up controllers when screen closes
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Create new user account with Firebase
  Future<void> _signUpEmail() async {
    setState(() {
      _error = null;
      _isLoading = true;
    });

    try {
      if (!(_formKey.currentState?.validate() ?? false)) {
        setState(() => _isLoading = false);
        return;
      }

      await ref.read(authServiceProvider).signUpWithEmailPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
        displayName: '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim(),
          );

      if (!mounted) return;
      final from = GoRouterState.of(context).uri.queryParameters['from'];
      final target = (from == null || from.isEmpty) ? '/' : from;
      context.go(target);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: const Text('Create Account'),
        backgroundColor: const Color(0xFF2E7D5A),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  const SizedBox(height: 12),
                  const Text(
                    'Create your GoPlanner account',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (_error != null) ...[
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 12),
                  ],
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final value = (v ?? '').trim();
                      if (value.isEmpty) return 'First name is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final value = (v ?? '').trim();
                      if (value.isEmpty) return 'Last name is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final value = (v ?? '').trim();
                      if (value.isEmpty) return 'Email is required';
                      if (!value.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final value = v ?? '';
                      if (value.isEmpty) return 'Password is required';
                      if (value.length < 6) return 'Min 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final value = v ?? '';
                      if (value.isEmpty) return 'Please confirm your password';
                      if (value != _passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _signUpEmail,
                      child: _isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Create Account'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            final from = GoRouterState.of(context).uri.queryParameters['from'];
                            final encodedFrom = from == null ? null : Uri.encodeComponent(from);
                            context.go(encodedFrom == null ? '/login' : '/login?from=$encodedFrom');
                          },
                    child: const Text('Already have an account? Sign in'),
                  ),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
