import '../links/link_target_type.dart';
import '../links/linked_item.dart';

/// Associations between a session and other records.
abstract interface class LinkRepository {
  Future<void> link(String sessionId, LinkTargetType type, String targetId);
  Future<void> unlink(String sessionId, LinkTargetType type, String targetId);
  Future<void> removeLinksTo(LinkTargetType type, String targetId);
  Future<List<LinkedItem>> linkedItems(String sessionId);
  Future<List<LinkedItem>> linkableItems(String sessionId);
}
