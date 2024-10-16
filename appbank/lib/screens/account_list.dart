import 'package:flutter/material.dart';
import '../models/account.dart';
import '../services/account_service.dart';
import 'account_form.dart';

class AccountList extends StatefulWidget {
  const AccountList({Key? key}) : super(key: key);

  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  final AccountService _accountService = AccountService();
  late Future<List<Account>> _accountsFuture;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  void _loadAccounts() {
    setState(() {
      _accountsFuture = _accountService.getAll(AccountService.resource);
    });
  }

  void _deleteAccount(String id) async {
    try {
      await _accountService.delete(AccountService.resource, id);
      _loadAccounts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao deletar conta: $e')),
      );
    }
  }

  Future<void> _navigateToForm({Account? account}) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountForm(account: account)),
    );
    if (result == true) {
      _loadAccounts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contas'),
      ),
      body: FutureBuilder<List<Account>>(
        future: _accountsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final accounts = snapshot.data!;
            return ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return ListTile(
                  title: Text(account.name),
                  subtitle: Text('Saldo: R\$${account.balance.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _navigateToForm(account: account),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          if (account.id != null) {
                            _deleteAccount(account.id!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('ID da conta é nulo')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Falha ao carregar as contas'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
