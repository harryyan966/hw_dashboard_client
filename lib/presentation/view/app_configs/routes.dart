import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hw_dashboard_client/presentation/view/dashboard_wrapper/dashboard_wrapper.dart';
import 'package:hw_dashboard_client/presentation/view/pages/pages.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) => DashboardWrapper(child: child),
      routes: [
        GoRoute(
          name: 'clubs',
          path: '/',
          parentNavigatorKey: shellNavigatorKey,
          builder: (context, state) => const ClubsPage(),
        ),
        GoRoute(
          name: 'leaves',
          path: '/leaves',
          parentNavigatorKey: shellNavigatorKey,
          builder: (context, state) => const LeavesPage(),
        ),
        GoRoute(
          name: 'courses',
          path: '/courses',
          parentNavigatorKey: shellNavigatorKey,
          builder: (context, state) => const CoursesPage(),
          routes: [
            GoRoute(
              name: 'all course scores',
              path: ':courseId',
              builder: (context, state) => TeacherCoursePage(
                courseId: state.pathParameters['courseId'],
              ),
            ),
            GoRoute(
              name: 'student course scores',
              path: ':courseID/students/:studentId',
              builder: (context, state) => StudentCoursePage(
                courseId: state.pathParameters['courseId'],
                studentId: state.pathParameters['studentId'],
              ),
            ),
          ],
        ),
        GoRoute(
          name: 'blogs',
          path: '/blogs',
          parentNavigatorKey: shellNavigatorKey,
          builder: (context, state) => const AllBlogsPage(),
          // routes: [
          //   GoRoute(
          //     name: 'create blog',
          //     path: 'create',
          //     builder: (context, state) => const CreateBlogPage(),
          //   ),
          // ],
        ),
        GoRoute(
          name: 'cards',
          path: '/cards',
          parentNavigatorKey: shellNavigatorKey,
          builder: (context, state) => const CardsPage(),
        ),
      ],
    ),
    // signin page
    GoRoute(
      name: 'sign in',
      path: '/signin',
      builder: (context, state) => const SignInPage(),
    ),
    // collge detail, including user-uploaded content and those fetched from
    // official websites
    // scores for a specific student
  ],
);
