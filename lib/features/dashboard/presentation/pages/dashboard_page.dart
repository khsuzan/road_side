import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/toast_utils.dart';

import '../../domain/entities/vehicle_entity.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeInAnimation;
  late final Animation<Offset> _slideAnimation;

  final List<VehicleEntity> _myGarage = [];
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    context.read<DashboardBloc>().add(const FetchDashboardEvent());
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64 + MediaQuery.of(context).padding.top),
        child: Container(
          height: 64 + MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.flash_on,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Dashboard',
                      style: AppTypography.headlineMd.copyWith(
                        fontSize: 20,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'membership':
                        AppToast.showInfo(context, 'Premium Membership Active');
                        break;
                      case 'privacy':
                        AppToast.showInfo(context, 'Privacy Policy Displayed');
                        break;
                      case 'mechanic':
                        context.push('/mechanic/register');
                        break;
                      case 'support':
                        AppToast.showInfo(context, 'Connecting to Support...');
                        break;
                    }
                  },
                  offset: const Offset(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: AppColors.surfaceContainerLowest,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      border: Border.all(
                        color: AppColors.surfaceContainer,
                        width: 1,
                      ),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/person.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'membership',
                      child: Row(
                        children: [
                          const Icon(Icons.card_membership, color: AppColors.primary, size: 20),
                          const SizedBox(width: 12),
                          Text('Membership', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface)),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'privacy',
                      child: Row(
                        children: [
                          const Icon(Icons.privacy_tip_outlined, color: AppColors.secondary, size: 20),
                          const SizedBox(width: 12),
                          Text('Privacy Policy', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface)),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'mechanic',
                      child: Row(
                        children: [
                          const Icon(Icons.engineering_outlined, color: AppColors.primary, size: 20),
                          const SizedBox(width: 12),
                          Text('Apply for Mechanic', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface)),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'support',
                      child: Row(
                        children: [
                          const Icon(Icons.support_agent_outlined, color: AppColors.secondary, size: 20),
                          const SizedBox(width: 12),
                          Text('Contact Support', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardSuccess) {
            final vehicle = state.vehicle;
            return FadeTransition(
              opacity: _fadeInAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildUserDashboard(context, vehicle),
              ),
            );
          }

          return const Center(child: Text('Failed to load dashboard data.'));
        },
      ),
    );
  }

  Widget _buildUserDashboard(BuildContext context, dynamic vehicle) {
    if (_myGarage.isEmpty) {
      _myGarage.add(vehicle as VehicleEntity);
      _myGarage.addAll([
        const VehicleEntity(
          id: '2',
          name: 'Porsche 911',
          model: 'GT3 RS',
          plateNumber: 'CA 9ELT123',
          status: 'Maintenance',
          daysSinceService: 4,
          milesToMaintenance: 800.0,
        ),
      ]);
    }

    final activeVehicle = _myGarage[_activeIndex.clamp(0, _myGarage.length - 1)];

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Greeting Section with plus button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GOOD MORNING',
                    style: AppTypography.labelBold.copyWith(
                      color: AppColors.secondary,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Julian.',
                    style: AppTypography.displayMobile.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => context.push('/add-car'),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Vehicle Status Card Stack
          VehicleCardStack(
            vehicles: _myGarage,
            activeIndex: _activeIndex,
            onVehicleChanged: (index) {
              setState(() {
                _activeIndex = index;
              });
            },
          ),
          const SizedBox(height: 24),

          // Metrics Grid
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.build_circle_outlined,
                        color: AppColors.secondary,
                        size: 24,
                      ),
                      const SizedBox(height: 12),
                      AnimatedMetricCount(
                        value: activeVehicle.daysSinceService,
                        style: AppTypography.metricXl.copyWith(
                          color: AppColors.onSurface,
                        ),
                        formatter: (val) => '${val.toInt()}',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Days Since Service',
                        style: AppTypography.labelBold.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.speed_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(height: 12),
                      AnimatedMetricCount(
                        value: activeVehicle.milesToMaintenance,
                        style: AppTypography.metricXl.copyWith(
                          color: AppColors.primary,
                        ),
                        formatter: (val) {
                          if (val >= 1000.0) {
                            return '${(val / 1000.0).toStringAsFixed(1)}k';
                          } else {
                            return '${val.toInt()}';
                          }
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Miles to Maint.',
                        style: AppTypography.labelBold.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Action Buttons
          GestureDetector(
            onTap: () {
              context.push('/request-help');
            },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.help_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Request Help',
                    style: AppTypography.labelBold.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              context.push('/ongoing-services');
            },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                color: AppColors.surfaceContainerLowest,
                border: Border.all(
                  color: AppColors.surfaceContainer,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.directions_car_outlined,
                      color: AppColors.secondary),
                  const SizedBox(width: 8),
                  Text(
                    'Ongoing Services',
                    style: AppTypography.labelBold.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }




}



class AnimatedMetricCount extends StatefulWidget {
  final num value;
  final TextStyle style;
  final String Function(double val) formatter;
  final Duration duration;

  const AnimatedMetricCount({
    super.key,
    required this.value,
    required this.style,
    required this.formatter,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<AnimatedMetricCount> createState() => _AnimatedMetricCountState();
}

class _AnimatedMetricCountState extends State<AnimatedMetricCount>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _oldValue = 0.0;
  double _newValue = 0.0;

  @override
  void initState() {
    super.initState();
    _oldValue = widget.value.toDouble();
    _newValue = widget.value.toDouble();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: _oldValue, end: _newValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedMetricCount oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _oldValue = _animation.value;
      _newValue = widget.value.toDouble();
      _controller.reset();
      _animation = Tween<double>(begin: _oldValue, end: _newValue).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          widget.formatter(_animation.value),
          style: widget.style,
        );
      },
    );
  }
}

class VehicleCardStack extends StatefulWidget {
  final List<VehicleEntity> vehicles;
  final int activeIndex;
  final ValueChanged<int> onVehicleChanged;

  const VehicleCardStack({
    super.key,
    required this.vehicles,
    required this.activeIndex,
    required this.onVehicleChanged,
  });

  @override
  State<VehicleCardStack> createState() => _VehicleCardStackState();
}

class _VehicleCardStackState extends State<VehicleCardStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _swipeController;

  double _dragOffsetX = 0.0;
  double _dragOffsetY = 0.0;
  double _dragProgress = 0.0;

  double _startOffsetX = 0.0;
  double _startOffsetY = 0.0;
  double _targetOffsetX = 0.0;
  double _targetOffsetY = 0.0;
  double _startProgress = 0.0;
  double _targetProgress = 0.0;
  bool _isSwipingOut = false;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..addListener(() {
        if (_swipeController.isAnimating) {
          final t = Curves.easeOutCubic.transform(_swipeController.value);
          setState(() {
            _dragOffsetX = _startOffsetX + (_targetOffsetX - _startOffsetX) * t;
            _dragOffsetY = _startOffsetY + (_targetOffsetY - _startOffsetY) * t;
            _dragProgress = _startProgress + (_targetProgress - _startProgress) * t;
          });
        }
      })..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (_isSwipingOut) {
            final nextIndex = (widget.activeIndex + 1) % widget.vehicles.length;
            widget.onVehicleChanged(nextIndex);
          }
          setState(() {
            _dragOffsetX = 0.0;
            _dragOffsetY = 0.0;
            _dragProgress = 0.0;
            _isSwipingOut = false;
          });
          _swipeController.value = 0.0;
        }
      });
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  void _triggerSwipe({bool goRight = true}) {
    if (_swipeController.isAnimating || widget.vehicles.length < 2) return;
    _startOffsetX = _dragOffsetX;
    _startOffsetY = _dragOffsetY;
    _targetOffsetX = goRight ? 450.0 : -450.0;
    _targetOffsetY = _dragOffsetY;
    _startProgress = _dragProgress;
    _targetProgress = 1.0;
    _isSwipingOut = true;
    _swipeController.forward(from: 0.0);
  }

  void _triggerSnapBack() {
    _startOffsetX = _dragOffsetX;
    _startOffsetY = _dragOffsetY;
    _targetOffsetX = 0.0;
    _targetOffsetY = 0.0;
    _startProgress = _dragProgress;
    _targetProgress = 0.0;
    _isSwipingOut = false;
    _swipeController.forward(from: 0.0);
  }

  Widget _buildPositionedCard({
    required double left,
    required double top,
    required double opacity,
    required VehicleEntity vehicle,
    required int index,
    required int total,
    required Color borderColor,
    required Color shadowColor,
    required double shadowBlur,
    required Offset shadowOffset,
    bool isTopCard = false,
    bool useGesture = false,
    double cardWidth = 300.0,
    double overlayOpacity = 0.0,
  }) {
    Widget card = Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: IgnorePointer(
        ignoring: !useGesture,
        child: _buildCardContent(
          vehicle: vehicle,
          index: index,
          total: total,
          borderColor: borderColor,
          shadowColor: shadowColor,
          shadowBlur: shadowBlur,
          shadowOffset: shadowOffset,
          isTopCard: isTopCard,
          overlayOpacity: overlayOpacity,
        ),
      ),
    );

    if (useGesture) {
      card = GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (_swipeController.isAnimating) return;
          setState(() {
            _dragOffsetX += details.delta.dx;
            _dragOffsetY += details.delta.dy;
            _dragProgress = (_dragOffsetX.abs() / (cardWidth * 0.6)).clamp(0.0, 1.0);
          });
        },
        onHorizontalDragEnd: (details) {
          if (_swipeController.isAnimating) return;
          final velocity = details.primaryVelocity ?? 0.0;
          if (_dragOffsetX.abs() > 120.0 || velocity.abs() > 800) {
            _triggerSwipe(goRight: _dragOffsetX > 0 || (velocity > 0));
          } else {
            _triggerSnapBack();
          }
        },
        child: card,
      );
    }

    return Positioned.fill(
      left: left,
      right: -left,
      top: top,
      bottom: -top,
      child: card,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.vehicles.isEmpty) {
      return const SizedBox(
        height: 340,
        child: Center(child: Text('No vehicles in your garage.')),
      );
    }

    if (widget.vehicles.length == 1) {
      return SizedBox(
        height: 340,
        child: _buildCardContent(
          vehicle: widget.vehicles.first,
          index: 0,
          total: 1,
          borderColor: AppColors.surfaceContainer,
          shadowColor: Colors.black.withValues(alpha: 0.06),
          shadowBlur: 30.0,
          shadowOffset: const Offset(0, 10),
          isTopCard: true,
          overlayOpacity: 0.0,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;

        final currentVehicle = widget.vehicles[widget.activeIndex];
        final nextIndex = (widget.activeIndex + 1) % widget.vehicles.length;
        final nextVehicle = widget.vehicles[nextIndex];
        final thirdIndex = (widget.activeIndex + 2) % widget.vehicles.length;
        final thirdVehicle = widget.vehicles[thirdIndex];

        // Interpolated properties for Middle Card (transitions to Top Card)
        final borderColMiddle = Colors.transparent;
        final shadowColorMiddle = Color.lerp(
          Colors.black.withValues(alpha: 0.04),
          Colors.black.withValues(alpha: 0.08),
          _dragProgress,
        ) ?? Colors.black12;
        final shadowBlurMiddle = 10.0 + (30.0 - 10.0) * _dragProgress;
        final shadowOffsetMiddle = Offset(0, 4.0 + (10.0 - 4.0) * _dragProgress);

        // Interpolated properties for Bottom-most Card (transitions to Middle Card)
        final borderColBottom = Colors.transparent;
        final shadowColorBottom = Color.lerp(
          Colors.black.withValues(alpha: 0.02),
          Colors.black.withValues(alpha: 0.04),
          _dragProgress,
        ) ?? Colors.black12;
        final shadowBlurBottom = 5.0 + (10.0 - 5.0) * _dragProgress;
        final shadowOffsetBottom = Offset(0, 2.0 + (4.0 - 2.0) * _dragProgress);

        final bool isAnimatingSwipe = _isSwipingOut && _swipeController.isAnimating;
        final List<Widget> stackChildren = [];

        if (isAnimatingSwipe) {
          final double t = Curves.easeOutCubic.transform(_swipeController.value); // 0.0 to 1.0 with curve

          if (t < 0.5) {
            // First Half of Swipe-Out: Card 1 slides out, Card 2 slides to top, Card 3 fades in
            final double normalizedT = t * 2.0; // scales to 0.0 to 1.0

            // Card 1 (Top Card) sliding out off-screen
            final double topOffsetX = _startOffsetX + (_targetOffsetX - _startOffsetX) * normalizedT;
            final double topOffsetY = _startOffsetY + (40.0 - _startOffsetY) * normalizedT;
            final double topOpacity = (1.0 - (topOffsetX.abs() / (cardWidth * 0.8))).clamp(0.0, 1.0);

            // Card 2 (Middle Card) sliding to active (0, 0)
            final double middleOffsetX = 12.0 * (1.0 - _startProgress) * (1.0 - normalizedT);
            final double middleOffsetY = 12.0 * (1.0 - _startProgress) * (1.0 - normalizedT);
            final double middleOverlayOpacity = (1.0 - _startProgress) * (1.0 - normalizedT);

            // Card 3 (Bottom Card) fading in directly at background position (12, 12)
            const double bottomOffsetX = 12.0;
            const double bottomOffsetY = 12.0;
            final double bottomOpacity = _startProgress + (1.0 - _startProgress) * normalizedT;

            stackChildren.addAll([
              // 1. BOTTOM-MOST CARD (Fading in at 12, 12)
              _buildPositionedCard(
                left: bottomOffsetX,
                top: bottomOffsetY,
                opacity: bottomOpacity,
                vehicle: thirdVehicle,
                index: thirdIndex,
                total: widget.vehicles.length,
                borderColor: borderColBottom,
                shadowColor: shadowColorBottom,
                shadowBlur: shadowBlurBottom,
                shadowOffset: shadowOffsetBottom,
                overlayOpacity: 1.0,
              ),
              // 2. MIDDLE CARD (Moving to top and removing solid opaque overlay)
              _buildPositionedCard(
                left: middleOffsetX,
                top: middleOffsetY,
                opacity: 1.0,
                vehicle: nextVehicle,
                index: nextIndex,
                total: widget.vehicles.length,
                borderColor: borderColMiddle,
                shadowColor: shadowColorMiddle,
                shadowBlur: shadowBlurMiddle,
                shadowOffset: shadowOffsetMiddle,
                overlayOpacity: middleOverlayOpacity,
              ),
              // 3. TOP CARD
              _buildPositionedCard(
                left: topOffsetX,
                top: topOffsetY,
                opacity: topOpacity,
                vehicle: currentVehicle,
                index: widget.activeIndex,
                total: widget.vehicles.length,
                borderColor: Colors.transparent,
                shadowColor: Colors.black.withValues(alpha: 0.08),
                shadowBlur: 30.0,
                shadowOffset: const Offset(0, 10),
                isTopCard: true,
                useGesture: false, // input disabled during animation
                overlayOpacity: 0.0,
              ),
            ]);
          } else {
            // Second Half of Swipe-Out: Card 1 wraps back to bottom
            final double normalizedT = (t - 0.5) * 2.0; // scales to 0.0 to 1.0

            // Card 1 (Old Top Card) sliding back to bottom (12, 12)
            final double topOffsetX = _targetOffsetX + (12.0 - _targetOffsetX) * normalizedT;
            final double topOffsetY = 40.0 * (1.0 - normalizedT) + 12.0 * normalizedT;
            final double topOpacity = 1.0 - normalizedT; // fades out completely at the end

            stackChildren.addAll([
              // 1. CARD 1 (returning to bottom behind Card 3)
              _buildPositionedCard(
                left: topOffsetX,
                top: topOffsetY,
                opacity: topOpacity,
                vehicle: currentVehicle,
                index: widget.activeIndex,
                total: widget.vehicles.length,
                borderColor: borderColBottom,
                shadowColor: shadowColorBottom,
                shadowBlur: shadowBlurBottom,
                shadowOffset: shadowOffsetBottom,
                overlayOpacity: 1.0,
              ),
              // 2. CARD 3 (now middle card stationary at 12, 12)
              _buildPositionedCard(
                left: 12.0,
                top: 12.0,
                opacity: 1.0,
                vehicle: thirdVehicle,
                index: thirdIndex,
                total: widget.vehicles.length,
                borderColor: borderColMiddle,
                shadowColor: shadowColorBottom,
                shadowBlur: shadowBlurBottom,
                shadowOffset: shadowOffsetBottom,
                overlayOpacity: 1.0,
              ),
              // 3. CARD 2 (now top active card at 0, 0)
              _buildPositionedCard(
                left: 0.0,
                top: 0.0,
                opacity: 1.0,
                vehicle: nextVehicle,
                index: nextIndex,
                total: widget.vehicles.length,
                borderColor: Colors.transparent,
                shadowColor: Colors.black.withValues(alpha: 0.08),
                shadowBlur: 30.0,
                shadowOffset: const Offset(0, 10),
                isTopCard: true,
                useGesture: false, // input disabled until animation ends
                overlayOpacity: 0.0,
              ),
            ]);
          }
        } else {
          // Standard layout: At rest, manual dragging, or snap-back animation
          final double t = _dragProgress;

          // Card 3: fades in directly at the background position (12, 12)
          final double bottomOffsetX = 12.0;
          final double bottomOffsetY = 12.0;
          final double bottomOpacity = t; // Invisible at rest (2 cards visible), fades in on swipe
          final double bottomOverlayOpacity = 1.0; // Solid color wash on entry

          // Card 2: middle card slides from (12, 12) to (0, 0)
          final double middleOffsetX = 12.0 * (1.0 - t);
          final double middleOffsetY = 12.0 * (1.0 - t);
          final double middleOverlayOpacity = 1.0 - t; // Solid color fades out to reveal content

          // Card 1: active top card at (dragOffsetX, dragOffsetY)
          final double topOffsetX = _dragOffsetX;
          final double topOffsetY = _dragOffsetY;
          final double topOpacity = (1.0 - (_dragOffsetX.abs() / (cardWidth * 0.8))).clamp(0.0, 1.0);

          stackChildren.addAll([
            // 1. BOTTOM-MOST CARD (Fading in at 12, 12)
            _buildPositionedCard(
              left: bottomOffsetX,
              top: bottomOffsetY,
              opacity: bottomOpacity,
              vehicle: thirdVehicle,
              index: thirdIndex,
              total: widget.vehicles.length,
              borderColor: borderColBottom,
              shadowColor: shadowColorBottom,
              shadowBlur: shadowBlurBottom,
              shadowOffset: shadowOffsetBottom,
              overlayOpacity: bottomOverlayOpacity,
            ),
            // 2. MIDDLE CARD (Moving to top and removing solid opaque overlay)
            _buildPositionedCard(
              left: middleOffsetX,
              top: middleOffsetY,
              opacity: 1.0,
              vehicle: nextVehicle,
              index: nextIndex,
              total: widget.vehicles.length,
              borderColor: borderColMiddle,
              shadowColor: shadowColorMiddle,
              shadowBlur: shadowBlurMiddle,
              shadowOffset: shadowOffsetMiddle,
              overlayOpacity: middleOverlayOpacity,
            ),
            // 3. TOP CARD
            _buildPositionedCard(
              left: topOffsetX,
              top: topOffsetY,
              opacity: topOpacity,
              vehicle: currentVehicle,
              index: widget.activeIndex,
              total: widget.vehicles.length,
              borderColor: Colors.transparent,
              shadowColor: Colors.black.withValues(alpha: 0.08),
              shadowBlur: 30.0,
              shadowOffset: const Offset(0, 10),
              isTopCard: true,
              useGesture: true,
              cardWidth: cardWidth,
              overlayOpacity: 0.0,
            ),
          ]);
        }

        return SizedBox(
          height: 340,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: stackChildren,
          ),
        );
      },
    );
  }

  Widget _buildCardContent({
    required VehicleEntity vehicle,
    required int index,
    required int total,
    required Color borderColor,
    required Color shadowColor,
    required double shadowBlur,
    required Offset shadowOffset,
    required bool isTopCard,
    double overlayOpacity = 0.0,
  }) {

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: shadowBlur,
            offset: shadowOffset,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    // Vehicle Image representation
                    Container(
                      height: 220,
                      width: double.infinity,
                      color: AppColors.surfaceContainerLow,
                      child: vehicle.imageUrl != null
                          ? Image.network(
                              vehicle.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                'assets/images/car.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/images/car.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                    // Pagination Chip (Top Left)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Text(
                          '${index + 1} / $total',
                          style: AppTypography.labelBold.copyWith(
                            color: AppColors.secondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    // Status Chip (Top Right)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.tertiary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              vehicle.status,
                              style: AppTypography.labelBold.copyWith(
                                color: AppColors.onTertiaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vehicle.name,
                              style: AppTypography.headlineMd.copyWith(
                                color: AppColors.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${vehicle.model} • ${vehicle.plateNumber}',
                              style: AppTypography.bodyMd.copyWith(
                                color: AppColors.secondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (total > 1)
                        GestureDetector(
                          onTap: () {
                            _triggerSwipe(goRight: true);
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: AppColors.surfaceContainer,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chevron_right,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.vpn_key,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (overlayOpacity > 0.0)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: true,
                  child: Container(
                    color: Colors.white.withValues(alpha: overlayOpacity),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
