import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'intion_app',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor:
            Colors.grey[200], // Latar belakang modern dan terang
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontFamily: 'SF Pro', // Atur font default iPhone di sini
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// SPLASH SCREEN

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Tambahkan penundaan untuk mensimulasikan splash screen
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.teal, // Atur warna latar belakang splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tambahkan konten splash screen di sini
            FlutterLogo(size: 100.0),
            SizedBox(height: 16.0),
            Text(
              'Intion Math',
              style: TextStyle(
                fontFamily: 'SF Pro', // Atur font default iPhone di sini
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Data
  List<double> suhuLuar = [10, 20, 30, 40, 50];
  List<double> waktu = [20, 15, 10, 5, 0];

  // Input
  TextEditingController suhuController = TextEditingController();
  TextEditingController waktuController = TextEditingController();
  double resultTime = 0.0;
  double resultTemperature = 0.0;

  // Method untuk mencari waktu dengan menggunakan fungsi invers
  double findInverseFunction(double s1) {
    // Mencari indeks suhu terdekat dari nilai s1
    int closestIndex = 0;
    double closestDiff = suhuLuar[0] - s1;

    for (int i = 1; i < suhuLuar.length; i++) {
      double diff = suhuLuar[i] - s1;
      if (diff < 0) {
        diff = -diff;
      }
      if (diff < closestDiff) {
        closestDiff = diff;
        closestIndex = i;
      }
    }

    // Menggunakan linear interpolation untuk menemukan waktu yang sesuai
    if (closestIndex < waktu.length - 1) {
      double s1Diff = suhuLuar[closestIndex + 1] - suhuLuar[closestIndex];
      double w1Diff = waktu[closestIndex + 1] - waktu[closestIndex];
      double ratio = (s1 - suhuLuar[closestIndex]) / s1Diff;
      double w1 = waktu[closestIndex] + ratio * w1Diff;
      return w1;
    }

    // Jika indeks terdekat berada di akhir array, kembalikan waktu pada indeks terdekat
    return waktu[closestIndex];
  }

  // Method untuk mencari suhu dengan menggunakan fungsi
  double findFunction(double w1) {
    // Mencari indeks waktu terdekat dari nilai w1
    int closestIndex = 0;
    double closestDiff = waktu[0] - w1;

    for (int i = 1; i < waktu.length; i++) {
      double diff = waktu[i] - w1;
      if (diff < 0) {
        diff = -diff;
      }
      if (diff < closestDiff) {
        closestDiff = diff;
        closestIndex = i;
      }
    }

    // Menggunakan linear interpolation untuk menemukan suhu yang sesuai
    if (closestIndex < suhuLuar.length - 1) {
      double w1Diff = waktu[closestIndex + 1] - waktu[closestIndex];
      double s1Diff = suhuLuar[closestIndex + 1] - suhuLuar[closestIndex];
      double ratio = (w1 - waktu[closestIndex]) / w1Diff;
      double s1 = suhuLuar[closestIndex] + ratio * s1Diff;
      return s1;
    }

    // Jika indeks terdekat berada di akhir array, kembalikan suhu pada indeks terdekat
    return suhuLuar[closestIndex];
  }

  // Method untuk menangani perhitungan waktu
  void calculateTime() {
    double s1 = double.tryParse(suhuController.text) ?? 0.0;
    double w1 = findInverseFunction(s1);

    setState(() {
      resultTime = w1;
    });
  }

  // Method untuk menangani perhitungan suhu
  void calculateTemperature() {
    double w1 = double.tryParse(waktuController.text) ?? 0.0;
    double s1 = findFunction(w1);

    setState(() {
      resultTemperature = s1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intion Math'),
        elevation: 0, // App bar modern dan datar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input Suhu
            TextField(
              controller: suhuController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Masukkan suhu luar (Celsius)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Sudut melengkung
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Hitung Waktu
            ElevatedButton(
              onPressed: calculateTime,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      15.0), // Sudut melengkung lebih besar
                ),
                backgroundColor: const Color(0xFF009688), // Warna teal modern
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 24.0),
              ),
              child: const Text('Hitung Waktu'),
            ),
            const SizedBox(height: 20),

            // Output Waktu
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16.0, color: Colors.black),
                children: [
                  const TextSpan(
                      text: 'Suhu optimal dalam ruangan dalam waktu '),
                  TextSpan(
                    text: '${resultTime.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' Menit.'),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              height: 40,
              thickness: 5,
            ), // Pemisah antara dua konten
            const SizedBox(
              height: 20,
            ),

            // Input Waktu
            TextField(
              controller: waktuController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Masukkan waktu (menit)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Sudut melengkung
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Hitung Suhu
            ElevatedButton(
              onPressed: calculateTemperature,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      15.0), // Sudut melengkung lebih besar
                ),
                backgroundColor: const Color(0xFF009688), // Warna teal modern
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 24.0),
              ),
              child: const Text('Hitung Suhu'),
            ),
            const SizedBox(height: 20),

            // Output Suhu
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16.0, color: Colors.black),
                children: [
                  const TextSpan(
                      text: 'Waktu optimal dalam ruangan dalam suhu '),
                  TextSpan(
                    text: '${resultTemperature.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' °C.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
