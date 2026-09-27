import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme.dart';

/// State 1 — Not yet joined.
/// Name input + optional phone + single prominent "Join Queue" button.
/// Clean, minimal — no app bar, no branding clutter.
class JoinForm extends StatefulWidget {
  final int counterId;
  final bool isJoining;
  final String? errorMessage;
  final Future<void> Function(String name, String? phone) onJoin;

  const JoinForm({
    super.key,
    required this.counterId,
    required this.isJoining,
    required this.errorMessage,
    required this.onJoin,
  });

  @override
  State<JoinForm> createState() => _JoinFormState();
}

class _JoinFormState extends State<JoinForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _showPhone = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final phone = _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim();
      widget.onJoin(_nameController.text.trim(), phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? AppSpacing.lg : AppSpacing.xxxl,
          vertical: AppSpacing.xxl,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Queue identifier badge
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      'Queue #${widget.counterId}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                      semanticsLabel: 'Queue number ${widget.counterId}',
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                Text(
                  'Join the queue',
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                  semanticsLabel: 'Join the virtual queue',
                ),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  'Enter your name and we\'ll hold your place. '
                  'You\'ll see your position update live.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Name field
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Your name',
                    hintText: 'e.g. Jane Smith',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) {
                      return 'Please enter your name.';
                    }
                    if (trimmed.length > 80) {
                      return 'Name must be 80 characters or fewer.';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _submit(),
                ),

                const SizedBox(height: AppSpacing.md),

                // Optional phone toggle
                if (!_showPhone)
                  TextButton.icon(
                    onPressed: () => setState(() => _showPhone = true),
                    icon: const Icon(Icons.phone_outlined, size: 18),
                    label: const Text('Add phone number (optional)'),
                  )
                else
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[\d\s\-+().]{0,20}'),
                      ),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Phone number (optional)',
                      hintText: '+91 98765 43210',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return null;
                      final phoneRegex = RegExp(r'^\+?[\d\s\-().]{7,20}$');
                      if (!phoneRegex.hasMatch(value.trim())) {
                        return 'Enter a valid phone number.';
                      }
                      return null;
                    },
                  ),

                if (widget.errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.error,
                          size: 20,
                          semanticLabel: 'Error',
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            widget.errorMessage!,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.error,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: AppSpacing.xl),

                // Primary join button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: widget.isJoining ? null : _submit,
                    child: widget.isJoining
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Join Queue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
