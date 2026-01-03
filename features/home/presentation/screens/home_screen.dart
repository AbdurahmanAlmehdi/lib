
import 'package:buzzy_bee/features/home/presentation/widgets/cleaner_list.dart';
import 'package:buzzy_bee/features/home/presentation/widgets/line_through_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/core/widgets/error_view.dart';
import 'package:buzzy_bee/features/home/presentation/bloc/home_bloc.dart';
import 'package:buzzy_bee/features/home/presentation/widgets/ad_carousel.dart';
import 'package:buzzy_bee/features/home/presentation/widgets/service_categories_grid.dart';
import 'package:buzzy_bee/features/home/presentation/widgets/home_app_bar.dart';
import 'package:buzzy_bee/core/routes/app_routes.dart';
import 'package:buzzy_bee/features/booking/domain/entities/location.dart';
import 'package:go_router/go_router.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentLocationLabel = 'حدد موقعك';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onLocationTap(BuildContext context) async {
    final result = await context.push<Location>(AppRoutes.locationPicker);
    if (result != null && mounted) {
      setState(() {
        _currentLocationLabel = result.address;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.error &&
              state.banners.isEmpty &&
              state.services.isEmpty &&
              state.popularCleaners.isEmpty) {
            return ErrorView(
              errorMessage: state.errorMessage,
              onRetry: () {
                context.read<HomeBloc>().add(const RefreshHome());
              },
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(const RefreshHome());
            },
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _HomeAppBarDelegate(
                    child: HomeAppBar(
                      currentLocation: _currentLocationLabel,
                      onSearchTap: () {
                        context.push(AppRoutes.search);
                      },
                      onNotificationTap: () {
                        context.push(AppRoutes.notifications);
                      },
                      onLocationTap: () {
                        _onLocationTap(context);
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: AdCarousel(banners: state.banners, onTap: (banner) {}),
                ),
                if (state.services.isNotEmpty || state.isLoading) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 8),
                      child: LineThroughHeader(
                        text: context.t.serviceCategories,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ServiceCategoriesGrid(
                      services: state.services,
                      isLoading: state.isLoading,
                      onServiceTap: (service) {
                        context.push(AppRoutes.booking, extra: service);
                      },
                    ),
                  ),
                ],

                if (state.popularCleaners.isNotEmpty || state.isLoading) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 8),
                      child: LineThroughHeader(text: context.t.popularCleaners),
                    ),
                  ),

                  CleanerList(
                    cleaners: state.popularCleaners,
                    isLoading: state.isLoading,
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HomeAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _HomeAppBarDelegate({required this.child});

  @override
  double get minExtent => HomeAppBar.height;

  @override
  double get maxExtent => HomeAppBar.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_HomeAppBarDelegate oldDelegate) => false;
}
