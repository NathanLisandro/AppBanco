import '../models/account.dart';
import 'api_service.dart';

class AccountService extends ApiService<Account> {
  static const String resource = 'accounts';

  AccountService() : super('http://localhost:3000');

  @override
  Account fromJson(Map<String, dynamic> json) {
    return Account.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Account item) {
    return item.toJson();
  }
}
