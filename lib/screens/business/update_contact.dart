import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/business.dart';

class UpdateBusinessScreen extends StatefulWidget {
  @override
  _UpdateBusinessScreenState createState() => _UpdateBusinessScreenState();
}

class _UpdateBusinessScreenState extends State<UpdateBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _contact;
  late String _email;
  late String _address;

  @override
  void initState() {
    super.initState();
    Provider.of<BusinessProvider>(context, listen: false).fetchBusiness();
  }

  @override
  Widget build(BuildContext context) {
    final businessProvider = Provider.of<BusinessProvider>(context);
    final business = businessProvider.business;

    if (business == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    _contact = business.contact;
    _email = business.email;
    _address = business.address;

    return Scaffold(
      appBar: AppBar(title: Text("Update Business Info")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _contact,
                decoration: InputDecoration(labelText: "Contact"),
                onChanged: (value) => _contact = value,
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (value) => _email = value,
              ),
              TextFormField(
                initialValue: _address,
                decoration: InputDecoration(labelText: "Address"),
                onChanged: (value) => _address = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    businessProvider.updateBusinessInfo(
                      business.id, _contact, _email, _address);
                    Navigator.pop(context);
                  }
                },
                child: Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
