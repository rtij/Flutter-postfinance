import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/animatedBackground.dart';
import 'dart:ui';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:beamer/beamer.dart';
import '../../services/login.dart';
import '../../utils/phone_formatter.dart';

class ForgottenPassword extends StatefulWidget {
  const ForgottenPassword({super.key});

  @override
  State<ForgottenPassword> createState() => _ForgottenPasswordState();
}

class _ForgottenPasswordState extends State<ForgottenPassword> {
  final LoginService _loginService = LoginService();
  PhoneNumber _phone = PhoneNumber(isoCode: 'SN');
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  

  Future<void> _submitForm() async {
    if (_formKey.currentState!.saveAndValidate()) {
      setState(() => _isLoading = true);
      try {
        final formattedPhone = formatPhoneNumber(_phone.phoneNumber!);
        final email = _formKey.currentState!.value['email'];
        await _loginService
            .forgotPassword(email, formattedPhone)
            .then((res) {
              if (res.code == 200) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('${res.msg}')));
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
              child: const Icon(
                Icons.lock_reset,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'Mot de passe oublié',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1f2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Entrez vos informations pour réinitialiser',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
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
                      Container(
                        width: double.infinity,
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
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
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

            // Email Field
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
                keyboardType: TextInputType.emailAddress,
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
                    Icons.email_outlined,
                    color: isDark
                        ? Colors.white.withOpacity(0.5)
                        : const Color(0xFF9ca3af),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: "Veuillez entrer votre adresse e-mail",
                  ),
                  FormBuilderValidators.email(
                    errorText: 'Adresse e-mail invalide',
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
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
                            'Réinitialiser le mot de passe',
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

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Beamer.of(context).beamToNamed('/login');
                },
                icon: const Icon(Icons.chevron_left, size: 20),
                label: const Text(
                  'Retour',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark
                      ? Colors.white.withOpacity(0.8)
                      : const Color(0xFF6b7280),
                  side: BorderSide(
                    color: Colors.white.withOpacity(isDark ? 0.2 : 0.3),
                  ),
                  backgroundColor: Colors.white.withOpacity(
                    isDark ? 0.05 : 0.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
