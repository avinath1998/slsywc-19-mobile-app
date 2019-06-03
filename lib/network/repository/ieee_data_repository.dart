import 'package:slsywc19/network/data_source/db.dart';

class IEEEDataRepository {
  DB _db;

  static final IEEEDataRepository _repo = new IEEEDataRepository._internal();

  static IEEEDataRepository get() {
    return _repo;
  }

  IEEEDataRepository._internal() {
    _db = FirestoreDB();
  }
}
