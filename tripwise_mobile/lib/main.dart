import 'package:flutter/material.dart';
import 'package:tripwise_mobile/services/trip_service.dart';
import 'package:intl/intl.dart';

import 'models/trip_model.dart';

void main() {
  runApp(const TripWiseApp());
}

class TripWiseApp extends StatelessWidget {
  const TripWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final _service = TripService();
  final currencyFormatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  bool isLoading = false;
  String? errorMessage;
  TripModel? trip;

  void calculate() async {
    final value = double.tryParse(_controller.text);

    if (value == null || value <= 0) {
      setState(() {
        errorMessage = 'Digite uma distância válida';
        trip = null;
      });
      return;
    }
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await _service.getEstimate(value);

      setState(() {
        trip = result;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao conectar com a API';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(title: const Text('TripWise'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TripWise',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Estimate fuel, tolls and total trip cost',
              style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 28),

            Card(
              elevation: 1,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Distance',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter distance in km',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Color.fromRGBO(249, 250, 251, 1),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : calculate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Calculate trip',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            if (trip != null)
              Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Result',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      _ResultRow(
                        label: 'Distance',
                        value: '${trip!.distance.toStringAsFixed(0)} km',
                      ),
                      _ResultRow(
                        label: 'Fuel',
                        value: currencyFormatter.format(trip!.fuelCost),
                      ),
                      _ResultRow(
                        label: 'Tolls',
                        value: currencyFormatter.format(trip!.tollCost),
                      ),
                      _ResultRow(
                        label: 'Total',
                        value: currencyFormatter.format(trip!.totalCost),
                        highlighted: true,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlighted;

  const _ResultRow({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = highlighted
        ? const Color(0xFF4F46E5)
        : const Color(0xFF111827);
    final weight = highlighted ? FontWeight.w600 : FontWeight.w400;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: highlighted
                  ? const Color(0xFF4F46E5)
                  : const Color(0xFF6B7280),
              fontSize: 16,
              fontWeight: weight,
            ),
          ),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 16, fontWeight: weight),
          ),
        ],
      ),
    );
  }
}
