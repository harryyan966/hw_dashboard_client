import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hw_dashboard_client/presentation/view/app_constants/spacing.dart';
import 'package:hw_dashboard_client/presentation/view/app_syntax_sugars/build_context.dart';
import 'package:hw_dashboard_client/presentation/view/app_syntax_sugars/click_region.dart';
import 'package:hw_dashboard_client/presentation/view/pages/blogs/bloc/blogs_bloc.dart';
import 'package:hw_dashboard_client/presentation/view/pages/blogs/view/create_blogs_page.dart';
import 'package:hw_dashboard_domain/models/blog/blog.dart';

class AllBlogsPage extends StatelessWidget {
  const AllBlogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlogsBloc(
        blogs: context.read(),
      ),
      child: AllBlogsView(),
    );
  }
}

class AllBlogsView extends StatelessWidget {
  const AllBlogsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _createBlogButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.space48,
          vertical: Space.space24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchBar(context),
            const SizedBox(height: Space.space48),
            _currentKeyword(),
            const SizedBox(height: Space.space24),
            _blogsGrid(),
          ],
        ),
      ),
    );
  }

  Padding _createBlogButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Space.space24),
      child: FloatingActionButton.extended(
        icon: const Icon(Icons.add_rounded),
        label: const Text('Write your own blog'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => BlocProvider.value(
                value: context.read<BlogsBloc>(),
                child: CreateBlogsView(),
              ),
            ),
          );
        },
      ),
    );
  }

  Expanded _blogsGrid() {
    return Expanded(
      child: BlocBuilder<BlogsBloc, BlogsState>(
        builder: (context, state) {
          return state.loadedBlogs.isEmpty
              ? Center(child: Text('No Blogs Found', style: context.text.headlineSmall))
              : MasonryGridView.extent(
                  maxCrossAxisExtent: 360,
                  mainAxisSpacing: Space.space24,
                  crossAxisSpacing: Space.space16,
                  itemCount: state.loadedBlogs.length,
                  itemBuilder: (context, index) => BlogCard(blog: state.loadedBlogs[index]),
                );
        },
      ),
    );
  }

  BlocBuilder<BlogsBloc, BlogsState> _currentKeyword() {
    return BlocBuilder<BlogsBloc, BlogsState>(
      builder: (context, state) {
        return state.searchedKeyword.isEmpty
            ? const SizedBox()
            : Text('Search Results for "${state.searchedKeyword}"', style: context.text.headlineSmall);
      },
    );
  }

  SearchBar _searchBar(BuildContext context) {
    return SearchBar(
      elevation: const MaterialStatePropertyAll(
        1,
      ),
      padding: const MaterialStatePropertyAll(
        EdgeInsets.symmetric(horizontal: Space.space12),
      ),
      overlayColor: const MaterialStatePropertyAll(
        Colors.transparent,
      ),
      trailing: const [Icon(Icons.search_rounded)],
      hintText: 'search blogs',
      onSubmitted: (value) {
        context.read<BlogsBloc>().add(value.isEmpty ? LoadBlogs() : SearchBlogs(keyword: value));
      },
    );
  }
}

class BlogCard extends StatelessWidget {
  const BlogCard({required this.blog, super.key});

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlogsBloc, BlogsState>(
      listenWhen: (previous, current) => previous.lastViewedBlogDetail != current.lastViewedBlogDetail && current.lastViewedBlogDetail != null,
      listener: (context, state) {
        showDialog<void>(
          context: context,
          builder: (_) => BlogDetailDialog(blog: state.lastViewedBlogDetail!),
        );
      },
      child: ClickRegion(
        onClick: () {
          context.read<BlogsBloc>().add(LoadBlogDetail(id: blog.id!));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Space.space12),
              child: CachedNetworkImage(
                width: double.infinity,
                fit: BoxFit.cover,
                imageUrl:
                    'https://img.freepik.com/free-photo/dynamic-portrait-young-man-woman-dancing-hiphop-isolated-black-background-with-mixed-lights-effect_155003-46269.jpg?w=2000&t=st=1703225525~exp=1703226125~hmac=71cbfe4a9bd92e5c9d3cdca963dff1e52446896b1bf74dca7f4c98626f5e2621',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Space.space16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(blog.title, style: context.text.titleLarge),
                  const SizedBox(height: Space.space08),
                  Text(
                    blog.content,
                    style: context.text.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogDetailDialog extends StatelessWidget {
  const BlogDetailDialog({required this.blog, super.key});
  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl:
                      'https://img.freepik.com/free-photo/dynamic-portrait-young-man-woman-dancing-hiphop-isolated-black-background-with-mixed-lights-effect_155003-46269.jpg?w=2000&t=st=1703225525~exp=1703226125~hmac=71cbfe4a9bd92e5c9d3cdca963dff1e52446896b1bf74dca7f4c98626f5e2621',
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Space.space36,
                    vertical: Space.space24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(blog.title, style: context.text.titleLarge),
                      const SizedBox(height: Space.space12),
                      Text(blog.content, style: context.text.bodyMedium),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: Space.space24,
            right: Space.space24,
            child: IconButton(
              icon: Icon(Icons.delete_rounded, color: context.colors.error),
              onPressed: () {
                context.read<BlogsBloc>().add(DeleteBlog(id: blog.id!));
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
