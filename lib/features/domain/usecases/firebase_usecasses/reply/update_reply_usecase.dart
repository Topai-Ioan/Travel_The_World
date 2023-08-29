import 'package:travel_the_world/features/domain/entites/reply/reply_entity.dart';
import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class UpdateReplyUseCase {
  final FirebaseRepositoryInterface repository;

  UpdateReplyUseCase({required this.repository});

  Future<void> call(ReplyEntity replay) {
    return repository.updateReply(replay);
  }
}
