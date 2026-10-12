import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/garage_vehicle_entity.dart';
import '../bloc/garage_bloc.dart';
import '../bloc/garage_event.dart';
import '../bloc/garage_state.dart';
import '../../../../core/utils/toast_utils.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({super.key});

  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _plateController = TextEditingController();
  final _expiryController = TextEditingController();

  String _selectedType = 'Car';
  String? _uploadedPhotoPath;
  bool _isUploadingPhoto = false;

  final List<Map<String, dynamic>> _vehicleTypes = [
    {'name': 'Car', 'icon': Icons.directions_car},
    {'name': 'Motorcycle', 'icon': Icons.two_wheeler},
    {'name': 'Truck', 'icon': Icons.local_shipping},
    {'name': 'EV', 'icon': Icons.electric_car},
  ];

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _plateController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  void _selectExpiryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
    );
    if (picked != null) {
      setState(() {
        _expiryController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}";
      });
    }
  }

  void _simulateUploadPhoto() async {
    setState(() {
      _isUploadingPhoto = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isUploadingPhoto = false;
        _uploadedPhotoPath = 'my_luxury_ride.png';
      });
    }
  }

  void _saveVehicle() {
    if (_makeController.text.isEmpty ||
        _modelController.text.isEmpty ||
        _yearController.text.isEmpty ||
        _plateController.text.isEmpty) {
      AppToast.showInfo(context, 'Please fill all details');
      return;
    }

    final vehicle = GarageVehicleEntity(
      id: 'veh_${DateTime.now().millisecondsSinceEpoch}',
      type: _selectedType,
      make: _makeController.text,
      model: _modelController.text,
      year: int.tryParse(_yearController.text) ?? DateTime.now().year,
      licensePlate: _plateController.text.toUpperCase(),
      expiryDate: _expiryController.text.isNotEmpty ? _expiryController.text : '2028-12',
      photoPath: _uploadedPhotoPath,
    );

    context.read<GarageBloc>().add(AddVehicleEvent(vehicle));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Vehicle',
          style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surfaceContainer,
              backgroundImage: const AssetImage('assets/images/person.png'),
            ),
          )
        ],
      ),
      body: BlocConsumer<GarageBloc, GarageState>(
        listener: (context, state) {
          if (state is GarageSuccess) {
            AppToast.showSuccess(context, 'Vehicle Saved Successfully!');
            Navigator.pop(context);
          } else if (state is GarageFailure) {
            AppToast.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is GarageLoading;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section 1: Type Selector
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vehicle Type',
                            style: AppTypography.headlineMd.copyWith(
                              fontSize: 18,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 112,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _vehicleTypes.length,
                              separatorBuilder: (_, _) => const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final type = _vehicleTypes[index];
                                final isSelected = _selectedType == type['name'];

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedType = type['name'];
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    width: 112,
                                    height: 112,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primaryContainer
                                          : AppColors.surface,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: AppColors.primary.withValues(alpha: 0.2),
                                                blurRadius: 15,
                                                offset: const Offset(0, 8),
                                              )
                                            ]
                                          : null,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          type['icon'],
                                          size: 40,
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.onSurfaceVariant,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          type['name'],
                                          style: AppTypography.labelBold.copyWith(
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.onSurfaceVariant,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Section 2: Details Inputs Form
                    Text(
                      'Details',
                      style: AppTypography.headlineMd.copyWith(
                        fontSize: 18,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildPremiumTextField('Make', _makeController),
                          const SizedBox(height: 16),
                          _buildPremiumTextField('Model', _modelController),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildPremiumTextField(
                                  'Year',
                                  _yearController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildPremiumTextField(
                                  'License Plate',
                                  _plateController,
                                  textCapitalization: TextCapitalization.characters,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Section 3: Insurance Month Expiry Date Selector
                    Text(
                      'Insurance',
                      style: AppTypography.headlineMd.copyWith(
                        fontSize: 18,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: GestureDetector(
                        onTap: _selectExpiryDate,
                        child: AbsorbPointer(
                          child: _buildPremiumTextField(
                            'Expiry Date',
                            _expiryController,
                            prefixIcon: const Icon(
                              Icons.calendar_month,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Section 4: Photo Uploader
                    Text(
                      'Photos',
                      style: AppTypography.headlineMd.copyWith(
                        fontSize: 18,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: GestureDetector(
                        onTap: _simulateUploadPhoto,
                        child: Container(
                          height: 160,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.secondaryFixedDim,
                              style: BorderStyle.solid,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isUploadingPhoto)
                                const CircularProgressIndicator()
                              else if (_uploadedPhotoPath != null) ...[
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.tertiary,
                                  size: 44,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _uploadedPhotoPath!,
                                  style: AppTypography.labelBold.copyWith(
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ] else ...[
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryContainer.withValues(alpha: 0.2),
                                  ),
                                  child: const Icon(
                                    Icons.add_a_photo,
                                    color: AppColors.primary,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Add Vehicle Photos',
                                  style: AppTypography.labelBold.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Fixed Bottom CTA Save Button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 16,
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.background.withValues(alpha: 0),
                        AppColors.background.withValues(alpha: 0.9),
                        AppColors.background,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: isLoading ? null : _saveVehicle,
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(9999),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Save Vehicle',
                                  style: AppTypography.labelBold.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPremiumTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Widget? prefixIcon,
  }) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.surfaceVariant,
            width: 1.0,
          ),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        style: AppTypography.bodyLg.copyWith(color: AppColors.onSurface),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          border: InputBorder.none,
          prefixIcon: prefixIcon,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}
