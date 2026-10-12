import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/mechanic_job_bloc.dart';
import '../bloc/mechanic_job_event.dart';
import '../bloc/mechanic_job_state.dart';
import '../../../../core/utils/toast_utils.dart';

class JobDetailPage extends StatefulWidget {
  final String jobId;
  const JobDetailPage({super.key, required this.jobId});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  late final List<TextEditingController> _pinControllers;
  late final List<FocusNode> _pinFocusNodes;

  final TextEditingController _laborController =
      TextEditingController(text: '400');
  final TextEditingController _partsController =
      TextEditingController(text: '800');

  // Checklist states
  bool _diagnosed = true;
  bool _replaced = false;
  bool _testing = false;

  @override
  void initState() {
    super.initState();
    _pinControllers = List.generate(4, (_) => TextEditingController());
    _pinFocusNodes = List.generate(4, (_) => FocusNode());

    context.read<MechanicJobBloc>().add(FetchJobDetailEvent(widget.jobId));
  }

  @override
  void dispose() {
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    for (var node in _pinFocusNodes) {
      node.dispose();
    }
    _laborController.dispose();
    _partsController.dispose();
    super.dispose();
  }

  void _onPinChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      _pinFocusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _pinFocusNodes[index - 1].requestFocus();
    }
  }

  void _completeJob() {
    final pinCode = _pinControllers.map((c) => c.text).join();
    final laborVal = double.tryParse(_laborController.text) ?? 0;
    final partsVal = double.tryParse(_partsController.text) ?? 0;

    context.read<MechanicJobBloc>().add(
          SubmitCompleteJobEvent(
            jobId: widget.jobId,
            verificationPin: pinCode,
            laborCharge: laborVal,
            partsUsed: partsVal,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Job Details',
          style: AppTypography.headlineMd.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<MechanicJobBloc, MechanicJobState>(
        listener: (context, state) {
          if (state is MechanicJobCompleteSuccess) {
            AppToast.showSuccess(context, 'Job Completed Successfully!');
            Navigator.pop(context);
          } else if (state is MechanicJobFailure) {
            AppToast.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is MechanicJobLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MechanicJobDetailSuccess) {
            final job = state.job;

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).padding.bottom + 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Section 1: Navigation Route Header Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job.status.toUpperCase(),
                                  style: AppTypography.labelBold.copyWith(
                                    color: AppColors.primaryContainer,
                                    fontSize: 12,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  job.location,
                                  style: AppTypography.headlineMd.copyWith(
                                    fontSize: 20,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.schedule,
                                      color: AppColors.onSurfaceVariant,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      job.etaText,
                                      style: AppTypography.bodyMd.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryFixed,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.directions_car,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            // Launch external map
                          },
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.explore, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  'Launch External Maps',
                                  style: AppTypography.labelBold.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Section 2: Checklist
                  Text(
                    'JOB CHECKLIST',
                    style: AppTypography.labelBold.copyWith(
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 1.5,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildChecklistItem(
                    'Diagnosed Issue',
                    _diagnosed,
                    (val) => setState(() => _diagnosed = val ?? false),
                  ),
                  const SizedBox(height: 12),
                  _buildChecklistItem(
                    'Parts Replaced',
                    _replaced,
                    (val) => setState(() => _replaced = val ?? false),
                  ),
                  const SizedBox(height: 12),
                  _buildChecklistItem(
                    'System Testing',
                    _testing,
                    (val) => setState(() => _testing = val ?? false),
                  ),
                  const SizedBox(height: 32),

                  // Section 3: Cost Editor final invoice
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 30,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'FINAL INVOICE',
                              style: AppTypography.labelBold.copyWith(
                                color: AppColors.onSurfaceVariant,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const Icon(
                              Icons.edit_note,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInvoiceInputRow('Labor Charge', _laborController),
                        const SizedBox(height: 16),
                        _buildInvoiceInputRow('Spare Parts Used', _partsController),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.errorContainer.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info,
                                color: AppColors.error,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Platform Deduction',
                                      style: AppTypography.labelBold.copyWith(
                                        color: AppColors.onSurface,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '-৳100 automatically deducted from wallet',
                                      style: AppTypography.bodyMd.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Section 4: Customer verification
                  Column(
                    children: [
                      Text(
                        'Customer Verification',
                        style: AppTypography.headlineMd.copyWith(
                          fontSize: 20,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ask the customer for their 4-digit completion code to close this job.',
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // PIN Fields Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 56,
                            height: 64,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                   color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 24,
                                )
                              ],
                            ),
                            child: TextField(
                              controller: _pinControllers[index],
                              focusNode: _pinFocusNodes[index],
                              onChanged: (val) => _onPinChanged(index, val),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: AppTypography.metricXl.copyWith(
                                fontSize: 24,
                                color: AppColors.onSurface,
                              ),
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                hintText: '·',
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 32),

                      // Complete Job Button
                      GestureDetector(
                        onTap: _completeJob,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9999),
                            color: AppColors.primaryContainer,
                            boxShadow: [
                              BoxShadow(
                                 color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'COMPLETE JOB',
                                style: AppTypography.labelBold.copyWith(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Failed to load job details.'));
        },
      ),
    );
  }

  Widget _buildChecklistItem(
      String label, bool value, ValueChanged<bool?> onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 24,
          )
        ],
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        title: Text(
          label,
          style: AppTypography.bodyLg.copyWith(
            color: AppColors.onSurface,
            decoration: value ? TextDecoration.lineThrough : null,
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildInvoiceInputRow(String label, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Container(
          width: 110,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Text(
                '৳',
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  style: AppTypography.labelBold.copyWith(
                    color: AppColors.onSurface,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
