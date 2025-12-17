import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/animatedBackground.dart';
import 'dart:ui';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:beamer/beamer.dart';
import '../../services/login.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_application_1/routes/routes.dart';
import '../../utils/phone_formatter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginService _loginService = LoginService();
  PhoneNumber _phone = PhoneNumber(isoCode: 'SN');
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (isLoggedIn()) {
      print('User is already logged in, redirecting to home.');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Beamer.of(context).beamToNamed('/home');
      });
    }
  }

  void _showAccountTypeDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(isDark ? 0.1 : 0.95),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFf59e0b).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.help_outline,
                          size: 48,
                          color: Color(0xFFf59e0b),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title
                      Text(
                        'Confirmation',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1f2937),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Message
                      Text(
                        'Avez vous déjà un compte ?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? Colors.white.withOpacity(0.8)
                              : const Color(0xFF6b7280),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Beamer.of(
                                  context,
                                ).beamToNamed('/home/register');
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: BorderSide(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.3)
                                      : const Color(0xFF6366f1),
                                  width: 2,
                                ),
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Oui',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF6366f1),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Beamer.of(context).beamToNamed(
                                  '/home/inscription-banque-digitale',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF6366f1),
                                      Color(0xFF8b5cf6),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  child: const Text(
                                    'Non',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Close button
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Annuler',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? Colors.white.withOpacity(0.6)
                                : const Color(0xFF9ca3af),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> _submitForm() async {
    if (_formKey.currentState!.saveAndValidate()) {
      setState(() => _isLoading = true);

      try {
        final formattedPhone = formatPhoneNumber(_phone.phoneNumber!);
        final password = _formKey.currentState!.value['password'];

        await _loginService
            .login(formattedPhone, password)
            .then((res) {
              if (res.code == 200) {
                final token = res.data['access_token'];
                if (token is String && token.isNotEmpty) {
                  localStorage.setItem('token', token.toString());
                }
                Beamer.of(context).beamToNamed('/home');
                
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Erreur: ${res.msg}')));
              }
            })
            .catchError((err) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur: ${err.toString()}')),
              );
            });
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: ${e.toString()}')));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBackground(
      content: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo/Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6366f1), Color(0xFF8b5cf6)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366f1).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'Bienvenue',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1f2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Connectez-vous pour continuer',
              style: TextStyle(
                fontSize: 16,
                color: isDark
                    ? Colors.white.withOpacity(0.7)
                    : const Color(0xFF6b7280),
              ),
            ),
            const SizedBox(height: 32),

            // Phone Number Field
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(isDark ? 0.05 : 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                ),
              ),
              child: FormBuilderField<PhoneNumber>(
                name: 'phone',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: "Veuillez entrer votre numéro de téléphone",
                  ),
                  (value) {
                    if (value == null || value.phoneNumber?.isEmpty == true) {
                      return 'Veuillez entrer un numéro valide';
                    }
                    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
                    if (!phoneRegex.hasMatch(value.phoneNumber!)) {
                      return 'Numéro invalide (ex: +221771234567)';
                    }
                    return null;
                  },
                ]),
                builder: (field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Utilisez un Container avec une largeur maximale
                      Container(
                        width: double
                            .infinity, // Prend toute la largeur disponible
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(isDark ? 0.05 : 0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                          ),
                        ),
                        child: InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            _phone = number;
                            field.didChange(number);
                          },
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.DROPDOWN,
                          ),
                          initialValue: _phone,
                          ignoreBlank: false,
                          errorMessage: null,
                          spaceBetweenSelectorAndTextField: 0,
                          // Ajustez le padding interne pour que le texte prenne toute la largeur
                          textFieldController: TextEditingController(),
                          inputDecoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Numéro de téléphone",
                            labelStyle: TextStyle(
                              color: isDark
                                  ? Colors.white.withOpacity(0.7)
                                  : const Color(0xFF6b7280),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal:
                                  16, // Ajustez ce padding selon vos besoins
                              vertical: 16,
                            ),
                          ),
                          // Assurez-vous que le champ de texte prend toute la largeur disponible
                          formatInput: true,
                        ),
                      ),
                      if (field.errorText != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 4,
                            left: 16,
                            bottom: 8,
                          ),
                          child: Text(
                            field.errorText!,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Password Field
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(isDark ? 0.05 : 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                ),
              ),
              child: FormBuilderTextField(
                name: 'password',
                obscureText: _obscurePassword,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1f2937),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Mot de passe',
                  labelStyle: TextStyle(
                    color: isDark
                        ? Colors.white.withOpacity(0.7)
                        : const Color(0xFF6b7280),
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: isDark
                        ? Colors.white.withOpacity(0.5)
                        : const Color(0xFF9ca3af),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: isDark
                          ? Colors.white.withOpacity(0.5)
                          : const Color(0xFF9ca3af),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: "Veuillez entrer votre mot de passe",
                  ),
                  FormBuilderValidators.minLength(
                    6,
                    errorText: 'Minimum 6 caractères',
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 20),

            // Remember Me & Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    //navigate to forgot password page
                    Beamer.of(context).beamToNamed('/forgotten-password');
                  },
                  child: Text(
                    'Mot de passe oublié?',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? const Color(0xFF818cf8)
                          : const Color(0xFF6366f1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style:
                    ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ).copyWith(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                    ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366f1), Color(0xFF8b5cf6)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366f1).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Se connecter',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sign Up Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Pas de compte? ",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? Colors.white.withOpacity(0.7)
                        : const Color(0xFF6b7280),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showAccountTypeDialog();
                    print("Navigating to Sign Up");
                    // Handle sign up
                  },
                  child: Text(
                    'Ouverture de compte',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? const Color(0xFF818cf8)
                          : const Color(0xFF6366f1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
