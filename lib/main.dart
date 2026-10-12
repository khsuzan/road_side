import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'injection_container.dart' as di;

// Import Blocs
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/services/presentation/bloc/service_bloc.dart';
import 'features/tracking/presentation/bloc/tracking_bloc.dart';
import 'features/mechanic/presentation/bloc/mechanic_bloc.dart';
import 'features/mechanic_dashboard/presentation/bloc/mechanic_dashboard_bloc.dart';
import 'features/mechanic_jobs/presentation/bloc/mechanic_job_bloc.dart';
import 'features/garage/presentation/bloc/garage_bloc.dart';

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
        BlocProvider<GarageBloc>(create: (_) => di.sl<GarageBloc>()),
      ],
      child: ToastificationWrapper(
        child: MaterialApp.router(
          title: 'Velocity Luxe Roadside Concierge',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
