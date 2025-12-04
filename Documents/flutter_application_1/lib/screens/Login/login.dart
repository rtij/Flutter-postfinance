import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import '../../shared/Neumorphic.dart';
import '../../providers/themeProvider.dart';
import '../../services/login.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:beamer/beamer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final LoginService _loginService = LoginService();
  PhoneNumber _phone = PhoneNumber(isoCode: 'SN');
  bool _obscurePassword = true;

  bool _isLoading = false;
  String formatPhoneNumber(String phoneNumber) {
    // Retirer tous les caractères non numériques
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    // Si le numéro commence par un indicatif international (ex: 221), ajouter 00
    if (cleanedNumber.length >= 3 && !cleanedNumber.startsWith('00')) {
      return '00$cleanedNumber';
    }
    return phoneNumber; // Retourner tel quel si déjà au bon format
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.saveAndValidate()) {
      setState(() => _isLoading = true);
      try {
        final formattedPhone = formatPhoneNumber(_phone.phoneNumber!);

        final success = await _loginService.login(
          formattedPhone, // Numéro de téléphone
          _formKey.currentState!.value['password'], // Mot de passe
        );
        if (success) {
          // Navigation avec Beamer
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Text(
                      'Bienvenue',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Connectez-vous pour continuer',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 48),
                    NeumorphicContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: FormBuilderField<PhoneNumber>(
                        name: 'phone',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText:
                                "Veuillez entrer votre numéro de téléphone",
                          ),
                          (value) {
                            if (value == null ||
                                value.phoneNumber?.isEmpty == true) {
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
                              InternationalPhoneNumberInput(
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
                                // Affiche l'erreur du validateur
                                inputDecoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Numéro de téléphone",
                                  labelStyle: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ),
                              if (field.errorText !=
                                  null) // Affiche l'erreur sous le champ
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    left: 8,
                                  ),
                                  child: Text(
                                    field.errorText!,
                                    style: TextStyle(
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

                    const SizedBox(height: 36),
                    NeumorphicContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: FormBuilderTextField(
                        name: 'password',
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Mot de passe',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        obscureText:
                            _obscurePassword, // Utilise la variable pour masquer/afficher
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: "Veuillez entrer votre mot de passe",
                          ),
                          FormBuilderValidators.minLength(
                            6,
                            errorText: 'Minimum 6 caractères',
                          ),
                          FormBuilderValidators.hasLowercaseChars(
                            errorText:
                                'Le mot de passe doit contenir au moins une lettre minuscule',
                          ),
                          FormBuilderValidators.hasUppercaseChars(
                            errorText:
                                'Le mot de passe doit contenir au moins une lettre majuscule',
                          ),
                          FormBuilderValidators.hasSpecialChars(
                            errorText:
                                'Le mot de passe doit contenir au moins un caractère spécial',
                          ),
                          FormBuilderValidators.hasNumericChars(
                            errorText:
                                'Le mot de passe doit contenir au moins un chiffre',
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 36),
                    NeumorphicContainer(
                      padding: const EdgeInsets.all(0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .transparent, // Fond transparent pour voir l'effet neumorphique
                            shadowColor: Colors
                                .transparent, // Pas d'ombre supplémentaire
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Se connecter',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 24,
            child: GestureDetector(
              onTap: () {
                Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).toggleTheme();
              },
              child: NeumorphicContainer(
                padding: const EdgeInsets.all(8),
                child: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return Icon(
                      themeProvider.isDarkMode
                          ? Icons.wb_sunny
                          : Icons.nightlight_round,
                      color: Theme.of(context).colorScheme.primary,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
