import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v08_bloc_counter/posts/posts.dart';

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final _scrollController = ScrollController();
  bool _hasLoggedMidpoint = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    print('🎯 [PostsList] Initialized - ScrollController attached');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.failure:
            return const Center(child: Text('failed to fetch posts'));
          case PostStatus.success:
            if (state.posts.isEmpty) {
              return const Center(child: Text('no posts'));
            }
            print(
              '📊 [PostsList] Building ListView with ${state.posts.length} posts (hasReachedMax: ${state.hasReachedMax})',
            );

            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                // Check if we're at the midpoint and log it
                if (!_hasLoggedMidpoint && state.posts.length > 10) {
                  final midpoint = state.posts.length ~/ 2;
                  if (index == midpoint) {
                    print(
                      '📍 [PostsList] TRACKER POINT MID LIST - Rendering item at midpoint (index $midpoint of ${state.posts.length})',
                    );
                    _hasLoggedMidpoint = true;
                  }
                }

                return index >= state.posts.length
                    ? const BottomLoader()
                    : PostListItem(post: state.posts[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.posts.length
                  : state.posts.length + 1,
              controller: _scrollController,
            );

          case PostStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    print('🗑️ [PostsList] Disposed - Cleaning up ScrollController');
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    final scrollPercentage = (currentScroll / maxScroll * 100).round();

    // Log when reaching midpoint during scroll
    if (scrollPercentage >= 45 &&
        scrollPercentage <= 55 &&
        !_hasLoggedMidpoint) {
      print(
        '📍 [PostsList] TRACKER POINT MID LIST - User scrolled to middle of list (~$scrollPercentage%)',
      );
      _hasLoggedMidpoint = true;
    }

    // Log when nearing bottom
    if (_isBottom) {
      print(
        '⬇️ [PostsList] Reached bottom threshold (90%) - Triggering PostFetched',
      );
      context.read<PostBloc>().add(PostFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
