extension StringTitleCaseExtension on String {

  String toTitleCase() {
    if (isEmpty) return this;

    // Split by spaces or common delimiters
    final words = split(RegExp(r'[\s_-]+'));

    final buffer = StringBuffer();

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      if (word.isEmpty) continue;

      // Capitalize first letter, rest lowercase
      if (word.length == 1) {
        buffer.write(word.toUpperCase());
      } else {
        buffer.write(word[0].toUpperCase() + word.substring(1).toLowerCase());
      }

      // Add space between words
      if (i < words.length - 1) {
        buffer.write(' ');
      }
    }

    return buffer.toString();
  }

  /// Converts to Title Case but preserves acronyms in uppercase
  String toTitleCasePreservingAcronyms() {
    if (isEmpty) return this;

    final words = split(RegExp(r'[\s_-]+'));

    final buffer = StringBuffer();

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      if (word.isEmpty) continue;

      // Check if it's an acronym (all uppercase and length > 1)
      if (word == word.toUpperCase() && word.length > 1) {
        buffer.write(word); // Keep acronym as is
      } else {
        buffer.write(word[0].toUpperCase() + word.substring(1).toLowerCase());
      }

      if (i < words.length - 1) {
        buffer.write(' ');
      }
    }

    return buffer.toString();
  }

  /// Converts from snake_case or kebab-case to Title Case
  String fromSnakeToTitleCase() {
    if (isEmpty) return this;

    return split(RegExp(r'[-_]+'))
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}