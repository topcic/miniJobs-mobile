import 'package:minijobs_mobile/models/proposed_answer.dart';
import 'package:minijobs_mobile/providers/base_provider.dart';

class ProposedAnswerProvider extends BaseProvider<ProposedAnswer> {
  ProposedAnswerProvider(): super("proposedanswers");
    @override
  ProposedAnswer fromJson(data) {
    return ProposedAnswer.fromJson(data);
  }
  Future<List<ProposedAnswer>> getByQuestion(String question) async {
    try {

        var url = "${baseUrl}proposedanswers?question=$question";
      var response = await dio.get(url);
     List<ProposedAnswer> responseData = List<ProposedAnswer>.from(response.data.map((item) => ProposedAnswer.fromJson(item)));
    return responseData;

    } catch (err) {
      throw Exception(err.toString());
    }
  }
}