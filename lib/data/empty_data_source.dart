import 'package:cmproject/data/generic_data_source.dart';

class EmptyDataSource extends GenericDataSource
{
  @override
  Future<dynamic> execute({required GenericOperationType type, data}) async {
    // TODO: implement execute
    return "Empty";
  }

}