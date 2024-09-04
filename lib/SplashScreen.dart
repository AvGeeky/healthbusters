import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:yourhealth/WidgetTree.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with TickerProviderStateMixin {
  late AnimationController _startanimationController;
  late Animation<double> _startanimation;
  late AnimationController _endanimationController;
  late Animation<double> _endanimation;
  late AnimationController _pickanimationController;
  late Animation<double> _pickanimation;

  @override
  void initState() {
    super.initState();

    _startanimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _startanimation = Tween<double>(begin: 0, end: 150).animate(
      CurvedAnimation(parent: _startanimationController, curve: Curves.easeOut),
    );

    _endanimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _endanimation = Tween<double>(begin: 0, end: 100000).animate(
      CurvedAnimation(parent: _endanimationController, curve: Curves.elasticOut),
    );

    _pickanimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pickanimation = Tween<double>(begin: 0, end: 150).animate(
      CurvedAnimation(parent: _pickanimationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _startanimationController.dispose();
    _pickanimationController.dispose();
    super.dispose();
  }

  void startAmbulance() {
    _startanimationController.forward().then((_) {
      _pickanimationController.forward().then((_) {
        _endanimationController.forward().then((_){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WidgetTree(),
            ),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Positioned Widget for Heart Animation
            AnimatedBuilder(
              animation: _pickanimation,
              builder: (context, child) {
                return Positioned(
                  top: MediaQuery.of(context).size.height / 2 -
                      250 +
                      _pickanimation.value *
                          1.8, // Adjust positioning as needed
                  child: SizedBox(
                    width: 300 - _pickanimation.value, // Adjust width
                    height: 300 - _pickanimation.value, // Adjust height
                    child: Lottie.asset(
                      'assets/illustrations/heart1.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
            // SOS Button
            Positioned(
              top: MediaQuery.of(context).size.height / 2 + 50,
              child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    color: Colors.red[100],
                  ),
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.red,
                  ),
                  child: ElevatedButton(
                    onPressed: startAmbulance,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'S O S',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            // Positioned Widget for Ambulance Animation
            AnimatedBuilder(
              animation: _endanimation,
              builder: (context, child) {
                return AnimatedBuilder(
                  animation: _startanimation,
                  builder: (context, child) {
                    return Positioned(
                      top: MediaQuery.of(context).size.height / 2 +
                          10 - _endanimation.value * 0.077, // Adjust positioning as needed
                      child: SizedBox(
                        width: _startanimation.value + _endanimation.value,
                        height: _startanimation.value + _endanimation.value,
                        child: Image.asset(
                          'assets/illustrations/ambulance.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
