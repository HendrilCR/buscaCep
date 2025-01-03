import 'package:flutter/material.dart';
import 'result.dart'; // Assuming you still have the ResultPage
import 'package:http/http.dart' as http;

class CepSearchPage extends StatefulWidget {
  const CepSearchPage({super.key});

  @override
  State<CepSearchPage> createState() => _CepSearchPageState();
}

class _CepSearchPageState extends State<CepSearchPage> {
  final TextEditingController _cepController = TextEditingController();
  final FocusNode _cepFocusNode = FocusNode();
  bool _isLoading = false;

  Future<void> _fetchCepData(String cep) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

      if (response.statusCode == 200) {
        final data = response.body;

        // Navigate to ResultPage with the JSON result
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(result: data),
          ),
        );
      } else {
        throw Exception("Erro ao adquirir os dados");
      }
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(result: "Erro: ${e.toString()}"),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _cepFocusNode.dispose();
    _cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Busca CEP'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Digite o número de CEP para buscar informações sobre:',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _cepController,
              focusNode: _cepFocusNode,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'CEP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      final cep = _cepController.text.trim();
                      if (cep.isNotEmpty) {
                        _fetchCepData(cep);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Por favor digite um número de CEP válido.')),
                        );
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text('Buscar'),
            ),
          ],
        ),
      ),
    );
  }
}
