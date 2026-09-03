class ShareMemberUi {
  final String email;
  final String? uid;
  final String? name;
  final List<String> permissions;

  const ShareMemberUi({
    required this.email,
    required this.permissions,
    this.uid,
    this.name,
  });
}

enum ShareEmailLookup { idle, searching, found, notFound, ownEmail, offline }
