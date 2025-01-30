
import '../models/overall_statistic.dart';
import 'base_provider.dart';

class StatisticProvider extends BaseProvider<OverallStatistic> {
  StatisticProvider(): super("statistics");
  @override
  OverallStatistic fromJson(data) {
    return OverallStatistic.fromJson(data);
  }

  Future<OverallStatistic> getOverall() async {
    try {
      var url = "${baseUrl}statistics/overall";
      var response = await dio.get(url); // Use the dio getter here
      OverallStatistic responseData = OverallStatistic.fromJson(response.data);
      return responseData;
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}