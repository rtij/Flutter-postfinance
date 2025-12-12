import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/animatedBackground.dart';
import 'dart:ui';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:beamer/beamer.dart';
import '../../services/login.dart';

class ForgottenPassword extends StatefulWidget {
  const ForgottenPassword({super.key});

  @override
  State<ForgottenPassword> createState() => _ForgottenPasswordState();
}

class _ForgottenPasswordState extends State<ForgottenPassword> {
  final LoginService _loginService = LoginService();
  PhoneNumber _phone = PhoneNumber(isoCode: 'SN');
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  String formatPhoneNumber(String phoneNumber) {
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedNumber.length >= 3 && !cleanedNumber.startsWith('00')) {
      return '00$cleanedNumber';
    }
    return phoneNumber;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.saveAndValidate()) {
      setState(() => _isLoading = true);
      try {
        final formattedPhone = formatPhoneNumber(_phone.phoneNumber!);
        final success = await _loginService.login(
          formattedPhone,
          _formKey.currentState!.value['password'],
        );
        if (success) {
          Beamer.of(context).beamToNamed('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Numéro ou mot de passe incorrect')),
          );
        }
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

            const SizedBox(height: 8),
            Text(
              'Mot de passe oublié',
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
                          formatInput: false,
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
                name: 'email',
                obscureText: _obscurePassword,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1f2937),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Adresse e-mail',
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
                            'Envoyer',
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
            SizedBox(height: 16),
            // back to login button
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.amber  
              ),
              onPressed: () {
                Beamer.of(context).beamToNamed('/login');
              },
              child: Text(
                
                'Retour',
                style: TextStyle(
                  color: isDark
                      ? Colors.white.withOpacity(0.7)
                      : const Color(0xFF6b7280),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
