import 'package:flutter/material.dart';
import '../models/account.dart';
import '../services/account_service.dart';

class AccountForm extends StatefulWidget {
  final Account? account;

  const AccountForm({Key? key, this.account}) : super(key: key);

  @override
  _AccountFormState createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();
  final AccountService _accountService = AccountService();

  late String _name;
  late double _balance;

  @override
  void initState() {
    super.initState();
    _name = widget.account?.name ?? '';
    _balance = widget.account?.balance ?? 0.0;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Incluir o id ao atualizar uma conta existente
      Account account = Account(
        id: widget.account?.id,
        name: _name,
        balance: _balance,
      );

      try {
        if (widget.account == null) {
          await _accountService.create(AccountService.resource, account);
        } else {
          await _accountService.update(AccountService.resource, widget.account!.id!, account);
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Operação falhou: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.account == null ? 'Criar Conta' : 'Editar Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Nome da Conta'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da conta';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: _balance.toString(),
                decoration: const InputDecoration(labelText: 'Saldo'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o saldo';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _balance = double.parse(value!);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.account == null ? 'Criar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
