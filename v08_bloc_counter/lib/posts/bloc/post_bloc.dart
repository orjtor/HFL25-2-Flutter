import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:v08_bloc_counter/posts/posts.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

part 'post_event.dart';
part 'post_state.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required http.Client httpClient})
    : _httpClient = httpClient,
      super(const PostState()) {
    on<PostFetched>(
      _onFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client _httpClient;

  Future<void> _onFetched(PostFetched event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) {
      print(
        '🛑 [PostBloc] END LIST - Already reached max, no more posts to load',
      );
      return;
    }

    try {
      final currentPage = (state.posts.length / _postLimit).floor() + 1;
      final startIndex = state.posts.length;

      if (startIndex == 0) {
        print('🚀 [PostBloc] LOAD LIST - Starting to fetch posts');
      }

      print(
        '📄 [PostBloc] PAGE $currentPage - Fetching posts from index $startIndex (limit: $_postLimit)',
      );

      final posts = await _fetchPosts(startIndex: startIndex);

      if (posts.isEmpty) {
        print('🛑 [PostBloc] END LIST - No more posts available (reached end)');
        return emit(state.copyWith(hasReachedMax: true));
      }

      final newTotalPosts = state.posts.length + posts.length;
      print(
        '✅ [PostBloc] PAGE $currentPage - Loaded ${posts.length} posts. Total: $newTotalPosts',
      );

      emit(
        state.copyWith(
          status: PostStatus.success,
          posts: [...state.posts, ...posts],
        ),
      );
    } catch (error) {
      print('❌ [PostBloc] ERROR - Failed to fetch posts: $error');
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<List<Post>> _fetchPosts({required int startIndex}) async {
    final response = await _httpClient.get(
      Uri.https('jsonplaceholder.typicode.com', '/posts', <String, String>{
        '_start': '$startIndex',
        '_limit': '$_postLimit',
      }),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Post(
          id: map['id'] as int,
          title: map['title'] as String,
          body: map['body'] as String,
        );
      }).toList();
    }
    throw Exception('error fetching posts');
  }
}
