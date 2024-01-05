import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hw_dashboard_client/presentation/view/navigation_shell/dashboard_wrapper.dart';
import 'package:hw_dashboard_client/presentation/view/pages/pages.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => DashboardWrapper(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'clubs',
              path: '/',
              builder: (context, state) => const ClubsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'leaves',
              path: '/leaves',
              parentNavigatorKey: shellNavigatorKey,
              builder: (context, state) => const LeavesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
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
          ],
        ),
        StatefulShellBranch(
          routes: [
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
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'cards',
              path: '/cards',
              parentNavigatorKey: shellNavigatorKey,
              builder: (context, state) => const CardsPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: 'sign in',
      path: '/signin',
      builder: (context, state) => const SignInPage(),
    ),
  ],
);
    // signin page

    // collge detail, including user-uploaded content and those fetched from
    // official websites
    // scores for a specific student
