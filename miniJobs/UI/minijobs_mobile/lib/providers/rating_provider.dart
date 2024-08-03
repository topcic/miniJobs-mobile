import 'package:minijobs_mobile/providers/base_provider.dart';

import '../models/rating.dart';

class RatingProvider extends BaseProvider<Rating> {
  RatingProvider(): super("ratings");
  @override
  Rating fromJson(data) {
    return Rating.fromJson(data);
  }
}