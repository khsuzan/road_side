import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/service_bloc.dart';
import '../bloc/service_event.dart';
import '../bloc/service_state.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    context.read<ServiceBloc>().add(const FetchServicesEvent(category: 'All'));
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    context.read<ServiceBloc>().add(FetchServicesEvent(category: category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
        elevation: 0,
        title: Text(
          'Services',
          style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surfaceContainer,
              backgroundImage: const AssetImage('assets/images/person.png'),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Filter Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterButton('All'),
                const SizedBox(width: 8),
                _buildFilterButton('Diagnostics'),
                const SizedBox(width: 8),
                _buildFilterButton('Detailing'),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<ServiceBloc, ServiceState>(
              builder: (context, state) {
                if (state is ServiceLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ServiceListSuccess) {
                  final services = state.services;

                  return ListView(
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 8,
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                    ),
                    children: [
                      // Featured block (only visible in 'All' or 'Diagnostics')
                      if (_selectedCategory == 'All' ||
                          _selectedCategory == 'Diagnostics')
                        _buildFeaturedCard(),

                      const SizedBox(height: 16),

                      // Service Cards List
                      ...services.map((service) => _buildServiceCard(service)),
                    ],
                  );
                }

                return const Center(child: Text('Failed to load services.'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String category) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => _onCategorySelected(category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(999),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 10,
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 5,
                  )
                ],
        ),
        child: Text(
          category,
          style: AppTypography.labelBold.copyWith(
            color: isSelected ? Colors.white : AppColors.secondary,
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      height: 320,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: AssetImage('assets/images/car.png'), // Or engine bay image
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Stack(
        children: [
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'FEATURED',
                      style: AppTypography.labelBold.copyWith(
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Elite Engine\nDiagnostics',
                  style: AppTypography.displayMobile.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comprehensive telemetry scan.',
                      style: AppTypography.bodyMd.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      '\$299',
                      style: AppTypography.headlineMd.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(dynamic service) {
    IconData getIcon(String iconName) {
      switch (iconName) {
        case 'build':
          return Icons.build;
        case 'water_drop':
          return Icons.water_drop;
        default:
          return Icons.panorama_horizontal;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  getIcon(service.iconName),
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${service.price.toStringAsFixed(0)}',
                    style: AppTypography.headlineMd.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  Text(
                    'Est. ${service.estimatedTime}',
                    style: AppTypography.labelBold.copyWith(
                      color: AppColors.secondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            service.title,
            style: AppTypography.headlineMd.copyWith(
              color: AppColors.onSurface,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            service.description,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
