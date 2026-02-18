import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/more/data/models/faq_item_model.dart';

void main() {
  group('FaqItemModel', () {
    final json = <String, dynamic>{
      'question': 'How do I send money?',
      'answer': 'Tap Send on the Pay screen.',
    };

    test('fromJson parses correctly', () {
      final model = FaqItemModel.fromJson(json);
      expect(model.question, 'How do I send money?');
      expect(model.answer, 'Tap Send on the Pay screen.');
    });

    test('toJson produces correct keys', () {
      final model = FaqItemModel.fromJson(json);
      final output = model.toJson();
      expect(output['question'], 'How do I send money?');
      expect(output['answer'], 'Tap Send on the Pay screen.');
    });

    test('toEntity converts correctly', () {
      final model = FaqItemModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity.question, 'How do I send money?');
      expect(entity.answer, 'Tap Send on the Pay screen.');
    });

    test('round-trip serialization preserves data', () {
      final model = FaqItemModel.fromJson(json);
      final roundTrip = FaqItemModel.fromJson(model.toJson());
      expect(roundTrip, equals(model));
    });
  });
}
