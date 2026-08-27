import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_typography.dart';
import 'injection_container.dart' as di;

// Import Pages
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/services/presentation/pages/services_page.dart';
import 'features/services/presentation/pages/request_help_page.dart';
import 'features/tracking/presentation/pages/tracking_page.dart';
import 'features/mechanic/presentation/pages/mechanic_application_page.dart';
import 'features/mechanic/presentation/pages/approval_pending_page.dart';
import 'features/mechanic_dashboard/presentation/pages/mechanic_dashboard_page.dart';
import 'features/mechanic_jobs/presentation/pages/incoming_job_page.dart';
import 'features/mechanic_jobs/presentation/pages/job_detail_page.dart';

// Import Blocs
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/services/presentation/bloc/service_bloc.dart';
import 'features/tracking/presentation/bloc/tracking_bloc.dart';
import 'features/mechanic/presentation/bloc/mechanic_bloc.dart';
import 'features/mechanic_dashboard/presentation/bloc/mechanic_dashboard_bloc.dart';
import 'features/mechanic_jobs/presentation/bloc/mechanic_job_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => di.sl<AuthBloc>()),
        BlocProvider<DashboardBloc>(create: (_) => di.sl<DashboardBloc>()),
        BlocProvider<ServiceBloc>(create: (_) => di.sl<ServiceBloc>()),
        BlocProvider<TrackingBloc>(create: (_) => di.sl<TrackingBloc>()),
        BlocProvider<MechanicBloc>(create: (_) => di.sl<MechanicBloc>()),
        BlocProvider<MechanicDashboardBloc>(
          create: (_) => di.sl<MechanicDashboardBloc>(),
        ),
        BlocProvider<MechanicJobBloc>(create: (_) => di.sl<MechanicJobBloc>()),
      ],
      child: MaterialApp(
        title: 'Velocity Luxe Roadside Concierge',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const DemoSelectorPage(),
      ),
    );
  }
}

class DemoSelectorPage extends StatelessWidget {
  const DemoSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF6F0), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Premium Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAxkPhLqrNlVQDDMX2w2EfSwnmyrcPVPbR0faJOnfKmbIGfdd6IbOy4TF_WwlD1R3RXOoZluI7QvVRvSNew3ph2CdsABaE3y5q_-k9Sdk4x6BRK4qSCzlEJlqJdgOmSrQjv0xy-Jd9yZF_49Iq3UDIBncM9ilu09VuMI2-46zj9bcZbPJLR-B2QLOBIJNnljQSOWT4btDpSaLThVR8JvdmgTmnHD8BO1aFmc6QwWA-qMclguuqTnTmffQ',
                      height: 36,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'VELOCITY LUXE',
                      style: AppTypography.displayMobile.copyWith(
                        fontSize: 24,
                        color: AppColors.onSurface,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Roadside Concierge Interactive Handoff Demo',
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Customer flow section
                _buildFlowHeader(context, 'CUSTOMER FLOW', Icons.person_pin),
                const SizedBox(height: 12),
                _buildDemoButton(
                  context: context,
                  title: '1. Welcome & OTP Login',
                  desc: 'Verify client phone number & OTP screen',
                  page: const AuthPage(),
                ),
                _buildDemoButton(
                  context: context,
                  title: '2. Home Telemetry Dashboard',
                  desc: 'Tesla Model S charging status & offline maps',
                  page: const DashboardPage(),
                ),
                _buildDemoButton(
                  context: context,
                  title: '3. Categories & Services List',
                  desc: 'Featured diagnostics & mechanic lists',
                  page: const ServicesPage(),
                ),
                _buildDemoButton(
                  context: context,
                  title: '4. Troubleshooter Voice Request',
                  desc: 'Radar wave scan, voice troubleshooting bottom drawer',
                  page: const RequestHelpPage(),
                ),
                _buildDemoButton(
                  context: context,
                  title: '5. Live Service Tracker Map',
                  desc: 'Bezier animated route, live stepper & job PIN',
                  page: const TrackingPage(requestId: 'req_987'),
                ),
                const SizedBox(height: 32),

                // Mechanic flow section
                _buildFlowHeader(context, 'MECHANIC FLOW', Icons.engineering),
                const SizedBox(height: 12),
                _buildDemoButton(
                  context: context,
                  title: '1. Onboarding Registration',
                  desc: 'ID file upload, checkbox expertise tags & coordinate locks',
                  page: const MechanicApplicationPage(),
                ),
                _buildDemoButton(
                  context: context,
                  title: '2. Application Review Pending',
                  desc: 'Pulsing state page detailing verification waiting time',
                  page: const ApprovalPendingPage(),
                ),
                _buildDemoButton(
                  context: context,
                  title: '3. Console Dashboard',
                  desc: 'Queue counter grid list of ongoing client tickets',
                  page: const MechanicDashboardPage(),
                ),
                _buildDemoButton(
                  context: context,
                  title: '4. Client Incoming Job details',
                  desc: 'Voice player waveform, location ETA, acceptance navigation',
                  page: const IncomingJobPage(jobId: 'job_456'),
                ),
                _buildDemoButton(
                  context: context,
                  title: '5. Cost Invoice & Verification',
                  desc: 'Invoice calculator input cells & client verification OTP input',
                  page: const JobDetailPage(jobId: 'job_456'),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlowHeader(BuildContext context, String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTypography.labelBold.copyWith(
            color: AppColors.primary,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Divider(color: AppColors.surfaceVariant, thickness: 1.2),
        ),
      ],
    );
  }

  Widget _buildDemoButton({
    required BuildContext context,
    required String title,
    required String desc,
    required Widget page,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(
          title,
          style: AppTypography.headlineMd.copyWith(
            fontSize: 15,
            color: AppColors.onSurface,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            desc,
            style: AppTypography.bodyMd.copyWith(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: AppColors.onSurfaceVariant,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      ),
    );
  }
}
