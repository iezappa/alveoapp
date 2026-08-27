import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/data/obsidian/frontmatter.dart';

void main() {
  test('parses flat key/value frontmatter and body', () {
    final fm = parseFrontmatter(
      '---\nterapia-id: abc\ntitle: "A: note"\n---\n\nBody line\n',
    );
    expect(fm.meta['terapia-id'], 'abc');
    expect(fm.meta['title'], 'A: note');
    expect(fm.body.trim(), 'Body line');
  });

  test('content without frontmatter is all body', () {
    final fm = parseFrontmatter('just text');
    expect(fm.meta, isEmpty);
    expect(fm.body, 'just text');
  });

  test('build then parse round-trips, quoting values with colons', () {
    final doc = buildFrontmatter({
      'terapia-id': 'x',
      'title': 'has: colon',
    }, '# Hi\n\ntext');
    final fm = parseFrontmatter(doc);
    expect(fm.meta['terapia-id'], 'x');
    expect(fm.meta['title'], 'has: colon');
    expect(fm.body.trim(), '# Hi\n\ntext');
  });
}
