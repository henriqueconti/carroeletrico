import 'package:carroeletrico/model/carro_model.dart';
import 'package:carroeletrico/repository/carro_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CadastroCarroPage extends StatefulWidget {
  Carro? carroParaEdicao;
  CadastroCarroPage({Key? key, this.carroParaEdicao}) : super(key: key);

  @override
  State<CadastroCarroPage> createState() => _CadastroCarroPageState();
}

class _CadastroCarroPageState extends State<CadastroCarroPage> {

  final _nomeController = TextEditingController();
  final _chassiController = TextEditingController();
  final _quilometragemController = TextEditingController();

  final _carroRepository = CarroRepository();

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Carro'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildApelido(),
                const SizedBox(height: 25),
                _buildChassi(),
                const SizedBox(height: 25),
                _buildQuilometragem(),
                const SizedBox(height: 25),
                _buildBotao()
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  TextFormField _buildApelido() {
    return TextFormField(
      controller: _nomeController,
      decoration: const InputDecoration(
        hintText: 'Informe um apelido',
        labelText: 'Apelido:',
        prefixIcon: Icon(Icons.time_to_leave),
        border: OutlineInputBorder()        
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um apelido para o carro';
        }
        if (value.length < 5 || value.length > 30) {
          return 'O apelido deve ter entre 5 e 30 caracteres';
        }
        return null;
      },
    );
  }

  TextFormField _buildChassi() {
    return TextFormField(
      controller: _chassiController,
      decoration: const InputDecoration(
        hintText: 'Informe o n??mero do chassi',
        labelText: 'Chassi:',
        prefixIcon: Icon(Icons.time_to_leave),
        border: OutlineInputBorder()        
      ),
      validator: (value) {
        if (value == null || value.length != 17) {
          return 'O chassi deve conter 17 caracteres';
        }
        return null;
      },
    );
  }

   TextFormField _buildQuilometragem() {
    return TextFormField(
      controller: _quilometragemController,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        hintText: 'Informe a quilometragem',
        labelText: 'Quilometragem:',
        prefixIcon: Icon(Icons.time_to_leave),
        border: OutlineInputBorder()        
      ),
      validator: (value) {
        if (int.parse(value!) < 0) {
          return ''; //TODO
        }
        return null;
      },
    );
  }

  SizedBox _buildBotao() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Cadastrar Carro'),
        ),
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            final apelido = _nomeController.text;
            final quilometragem = _quilometragemController.text;
            final chassi = int.parse(_chassiController.text);

            final carroCadastro = Carro(apelido: apelido, chassi: chassi, quilometragem: double.parse(quilometragem));

            try {
              if (widget.carroParaEdicao != null) {
                //await _carroRepository.cadastrarCarro(carroCadastro);
              }else {
                await _carroRepository.cadastrarCarro(carroCadastro);
              }

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('$apelido cadastrado com sucesso'),
              ));

              Navigator.of(context).pop(true);
            } catch (e) {
              Navigator.of(context).pop(false);
            }
          }
        },
      ),
    );
  }

}

