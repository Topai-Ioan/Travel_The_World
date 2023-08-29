import 'package:travel_the_world/features/domain/entites/reply/reply_entity.dart';
import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class ReadRepliesUseCase {
  final FirebaseRepositoryInterface repository;

  ReadRepliesUseCase({required this.repository});

  Stream<List<ReplyEntity>> call(ReplyEntity reply) {
    return repository.readReplies(reply);
  }
}
