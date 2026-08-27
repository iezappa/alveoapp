/// A Markdown document split into its YAML-ish frontmatter and body.
class Frontmatter {
  const Frontmatter(this.meta, this.body);

  final Map<String, String> meta;
  final String body;
}

/// Parses leading `--- ... ---` frontmatter. Only flat `key: value` pairs are
/// understood (Obsidian's common case); anything else is left in the body.
Frontmatter parseFrontmatter(String content) {
  final normalized = content.replaceAll('\r\n', '\n');
  if (!normalized.startsWith('---\n')) {
    return Frontmatter(const {}, normalized);
  }

  final lines = normalized.split('\n');
  var end = -1;
  for (var i = 1; i < lines.length; i++) {
    if (lines[i].trim() == '---') {
      end = i;
      break;
    }
  }
  if (end == -1) return Frontmatter(const {}, normalized);

  final meta = <String, String>{};
  for (var i = 1; i < end; i++) {
    final line = lines[i];
    final colon = line.indexOf(':');
    if (colon <= 0) continue;
    final key = line.substring(0, colon).trim();
    var value = line.substring(colon + 1).trim();
    if (value.length >= 2 && value.startsWith('"') && value.endsWith('"')) {
      value = value.substring(1, value.length - 1).replaceAll(r'\"', '"');
    }
    meta[key] = value;
  }

  final body = lines
      .sublist(end + 1)
      .join('\n')
      .replaceFirst(RegExp(r'^\n+'), '');
  return Frontmatter(meta, body);
}

/// Serialises [meta] + [body] back into a frontmatter document.
String buildFrontmatter(Map<String, String> meta, String body) {
  final buffer = StringBuffer('---\n');
  meta.forEach((key, value) {
    final needsQuotes =
        value.contains(':') || value.contains('\n') || value.trim() != value;
    final rendered = needsQuotes ? '"${value.replaceAll('"', r'\"')}"' : value;
    buffer.writeln('$key: $rendered');
  });
  buffer
    ..writeln('---')
    ..writeln();
  buffer.write(body.trimRight());
  buffer.writeln();
  return buffer.toString();
}
