import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Blocs & States
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';

// Pages
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/dashboard/presentation/pages/guest_dashboard_page.dart';
import '../../features/services/presentation/pages/services_page.dart';
import '../../features/services/presentation/pages/request_help_page.dart';
import '../../features/tracking/presentation/pages/tracking_page.dart';
import '../../features/garage/presentation/pages/add_car_page.dart';
import '../../features/tracking/presentation/pages/ongoing_services_page.dart';
import '../../features/mechanic/presentation/pages/mechanic_application_page.dart';
import '../../features/mechanic/presentation/pages/approval_pending_page.dart';
import '../../features/mechanic_dashboard/presentation/pages/mechanic_dashboard_page.dart';
import '../../features/mechanic_jobs/presentation/pages/incoming_job_page.dart';
import '../../features/mechanic_jobs/presentation/pages/job_detail_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) {
        final authState = context.read<AuthBloc>().state;
        if (authState is AuthSuccess) {
          if (authState.token.contains('mechanic')) {
            return '/mechanic/dashboard';
          }
          return '/dashboard';
        }
        return '/guest-dashboard';
      },
    ),
    GoRoute(
      path: '/guest-dashboard',
      builder: (context, state) => const GuestDashboardPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final phone = state.uri.queryParameters['phone'] ?? '';
        return OtpPage(phone: phone);
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/services',
      builder: (context, state) => const ServicesPage(),
    ),
    GoRoute(
      path: '/request-help',
      builder: (context, state) => const RequestHelpPage(),
    ),
    GoRoute(
      path: '/tracking/:requestId',
      builder: (context, state) {
        final requestId = state.pathParameters['requestId'] ?? 'req_987';
        return TrackingPage(requestId: requestId);
      },
    ),
    GoRoute(
      path: '/add-car',
      builder: (context, state) => const AddCarPage(),
    ),
    GoRoute(
      path: '/ongoing-services',
      builder: (context, state) => const OngoingServicesPage(),
    ),
    GoRoute(
      path: '/mechanic/register',
      builder: (context, state) => const MechanicApplicationPage(),
    ),
    GoRoute(
      path: '/mechanic/pending',
      builder: (context, state) => const ApprovalPendingPage(),
    ),
    GoRoute(
      path: '/mechanic/dashboard',
      builder: (context, state) => const MechanicDashboardPage(),
    ),
    GoRoute(
      path: '/mechanic/incoming/:jobId',
      builder: (context, state) {
        final jobId = state.pathParameters['jobId'] ?? 'job_456';
        return IncomingJobPage(jobId: jobId);
      },
    ),
    GoRoute(
      path: '/mechanic/job-detail/:jobId',
      builder: (context, state) {
        final jobId = state.pathParameters['jobId'] ?? 'job_456';
        return JobDetailPage(jobId: jobId);
      },
    ),
  ],
);
