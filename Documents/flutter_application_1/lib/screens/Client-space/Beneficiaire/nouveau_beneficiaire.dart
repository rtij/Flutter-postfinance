import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_application_1/services/beneficiaire.dart';

class NouveauBeneficiaireScreen extends StatefulWidget {
  const NouveauBeneficiaireScreen({super.key});

  @override
  State<NouveauBeneficiaireScreen> createState() =>
      _NouveauBeneficiaireScreenState();
}

class _NouveauBeneficiaireScreenState extends State<NouveauBeneficiaireScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final BeneficiaireService beneficiaireService = BeneficiaireService();

  PhoneNumber _phone = PhoneNumber(isoCode: 'SN');
  bool _isLoading = false;
  String _selectedType = 'physique';
  String _memeBanque = 'oui';

  String formatPhoneNumber(String phoneNumber) {
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedNumber.length >= 3 && !cleanedNumber.startsWith('00')) {
      return '00$cleanedNumber';
    }
    return phoneNumber;
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() => _isLoading = true);

      try {
        final formData = _formKey.currentState!.value;

        // Format phone number
        final phoneNumber = formatPhoneNumber(_phone.phoneNumber!);

        final beneficiaire = {...formData, 'telephone': phoneNumber};

        // TODO: Call your service
        await beneficiaireService
            .ajoutBeneficiaire(beneficiaire)
            .then((response) {
              if (response.code == 201) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('${response.msg}')));
                // Reset form
                _resetForm();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur: ${response.msg}')),
                );
              }
            })
            .catchError((e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur: ${e.toString()}')),
              );
              throw e;
            });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erreur: ${e.toString()}')));
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _selectedType = 'physique';
      _memeBanque = 'oui';
      _phone = PhoneNumber(isoCode: 'SN');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Nouveau Bénéficiaire',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1f2937),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 2,
                width: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Type Selection
              Text(
                'Type de bénéficiaire *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.white.withOpacity(0.9)
                      : const Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 12),
              FormBuilderRadioGroup(
                name: 'type',
                initialValue: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value.toString();
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                options: [
                  FormBuilderFieldOption(
                    value: 'physique',
                    child: Text(
                      'PHYSIQUE',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  FormBuilderFieldOption(
                    value: 'moral',
                    child: Text(
                      'MORAL',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                validator: FormBuilderValidators.required(
                  errorText: 'Le type est requis',
                ),
              ),
              const SizedBox(height: 20),

              // Nom
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(isDark ? 0.05 : 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                  ),
                ),
                child: FormBuilderTextField(
                  name: 'nom',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1f2937),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Nom *',
                    labelStyle: TextStyle(
                      color: isDark
                          ? Colors.white.withOpacity(0.7)
                          : const Color(0xFF6b7280),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: isDark
                          ? Colors.white.withOpacity(0.5)
                          : const Color(0xFF9ca3af),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: FormBuilderValidators.required(
                    errorText: 'Le nom est requis',
                  ),
                ),
              ),

              // Prénom (si physique)
              if (_selectedType == 'physique') ...[
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(isDark ? 0.05 : 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                    ),
                  ),
                  child: FormBuilderTextField(
                    name: 'prenom',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1f2937),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Prénom *',
                      labelStyle: TextStyle(
                        color: isDark
                            ? Colors.white.withOpacity(0.7)
                            : const Color(0xFF6b7280),
                      ),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: isDark
                            ? Colors.white.withOpacity(0.5)
                            : const Color(0xFF9ca3af),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: FormBuilderValidators.required(
                      errorText: 'Le prénom est requis',
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // Téléphone
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(isDark ? 0.05 : 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                  ),
                ),
                child: FormBuilderField<PhoneNumber>(
                  name: 'telephone',
                  validator: FormBuilderValidators.required(
                    errorText: 'Le téléphone est requis',
                  ),
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
                          inputDecoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Téléphone *",
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
                        if (field.errorText != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              bottom: 8,
                              top: 4,
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
              const SizedBox(height: 16),

              // Adresse
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(isDark ? 0.05 : 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                  ),
                ),
                child: FormBuilderTextField(
                  name: 'adresse',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1f2937),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Adresse *',
                    labelStyle: TextStyle(
                      color: isDark
                          ? Colors.white.withOpacity(0.7)
                          : const Color(0xFF6b7280),
                    ),
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: isDark
                          ? Colors.white.withOpacity(0.5)
                          : const Color(0xFF9ca3af),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: FormBuilderValidators.required(
                    errorText: 'L\'adresse est requise',
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Même Banque
              Text(
                'Même banque ? *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.white.withOpacity(0.9)
                      : const Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 12),
              FormBuilderRadioGroup(
                name: 'meme_banque',
                initialValue: _memeBanque,
                onChanged: (value) {
                  setState(() {
                    _memeBanque = value.toString();
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                options: [
                  FormBuilderFieldOption(
                    value: 'oui',
                    child: Text(
                      'OUI',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  FormBuilderFieldOption(
                    value: 'non',
                    child: Text(
                      'NON',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 20),

              // Informations bancaires
              if (_memeBanque == 'non') ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Informations bancaires',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Code Banque
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(isDark ? 0.05 : 0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                          ),
                        ),
                        child: FormBuilderTextField(
                          name: 'code_banque',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1f2937),
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Code Banque *',
                            labelStyle: TextStyle(
                              color: isDark
                                  ? Colors.white.withOpacity(0.7)
                                  : const Color(0xFF6b7280),
                            ),
                            prefixIcon: Icon(
                              Icons.business,
                              color: isDark
                                  ? Colors.white.withOpacity(0.5)
                                  : const Color(0xFF9ca3af),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          validator: FormBuilderValidators.required(
                            errorText: 'Requis',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Code Guichet
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(isDark ? 0.05 : 0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                          ),
                        ),
                        child: FormBuilderTextField(
                          name: 'code_guichet',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1f2937),
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Code Guichet *',
                            labelStyle: TextStyle(
                              color: isDark
                                  ? Colors.white.withOpacity(0.7)
                                  : const Color(0xFF6b7280),
                            ),
                            prefixIcon: Icon(
                              Icons.store,
                              color: isDark
                                  ? Colors.white.withOpacity(0.5)
                                  : const Color(0xFF9ca3af),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          validator: FormBuilderValidators.required(
                            errorText: 'Requis',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Numéro de compte
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(isDark ? 0.05 : 0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                          ),
                        ),
                        child: FormBuilderTextField(
                          name: 'numcompte',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(12),
                          ],
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1f2937),
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Numéro de compte *',
                            labelStyle: TextStyle(
                              color: isDark
                                  ? Colors.white.withOpacity(0.7)
                                  : const Color(0xFF6b7280),
                            ),
                            prefixIcon: Icon(
                              Icons.credit_card,
                              color: isDark
                                  ? Colors.white.withOpacity(0.5)
                                  : const Color(0xFF9ca3af),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(errorText: 'Requis'),
                            FormBuilderValidators.minLength(
                              12,
                              errorText: '12 chiffres',
                            ),
                          ]),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Clé RIB
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(isDark ? 0.05 : 0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                          ),
                        ),
                        child: FormBuilderTextField(
                          name: 'cle_rib',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1f2937),
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Clé RIB *',
                            labelStyle: TextStyle(
                              color: isDark
                                  ? Colors.white.withOpacity(0.7)
                                  : const Color(0xFF6b7280),
                            ),
                            prefixIcon: Icon(
                              Icons.key,
                              color: isDark
                                  ? Colors.white.withOpacity(0.5)
                                  : const Color(0xFF9ca3af),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          validator: FormBuilderValidators.required(
                            errorText: 'Requis',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ] else ...[
                // Numéro de compte (même banque)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(isDark ? 0.05 : 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                    ),
                  ),
                  child: FormBuilderTextField(
                    name: 'numcompte',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1f2937),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Numéro de compte *',
                      labelStyle: TextStyle(
                        color: isDark
                            ? Colors.white.withOpacity(0.7)
                            : const Color(0xFF6b7280),
                      ),
                      prefixIcon: Icon(
                        Icons.credit_card,
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
                        errorText: 'Le numéro de compte est requis',
                      ),
                      FormBuilderValidators.minLength(
                        12,
                        errorText: 'Le numéro doit contenir 12 chiffres',
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onSubmit,
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
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.check, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Enregistrer',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(isDark ? 0.1 : 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                      ),
                    ),
                    child: IconButton(
                      onPressed: _resetForm,
                      icon: Icon(
                        Icons.refresh,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
