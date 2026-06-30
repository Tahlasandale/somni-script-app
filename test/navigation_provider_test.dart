import 'package:flutter_test/flutter_test.dart';
import 'package:somni_script_app/core/providers/navigation_provider.dart';

void main() {
  group('PendingPlayback', () {
    test('holds script, title, mediaType', () {
      const pb = PendingPlayback(
        script: 'Une douce voix…',
        title: 'Relaxation océan',
        mediaType: 'STORY',
      );

      expect(pb.script, 'Une douce voix…');
      expect(pb.title, 'Relaxation océan');
      expect(pb.mediaType, 'STORY');
    });
  });
}
