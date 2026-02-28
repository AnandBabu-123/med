enum PostAddressStatus { initial, loading, success, failure }

class PostAddressState {
  final PostAddressStatus status;
  final String message;

  const PostAddressState({
    this.status = PostAddressStatus.initial,
    this.message = "",
  });

  PostAddressState copyWith({
    PostAddressStatus? status,
    String? message,
  }) {
    return PostAddressState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}