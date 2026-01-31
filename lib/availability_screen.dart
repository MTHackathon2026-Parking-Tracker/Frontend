import 'package:flutter/material.dart';

class AvailabilityScreen extends StatelessWidget {
  const AvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Light blue background color from your wireframe
    const Color bgColor = Color(0xFFCDE0FF);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Header Section
                    const Text(
                      'Parking Lot Name:',
                      style: TextStyle(fontSize: 28, fontFamily: 'Serif'),
                    ),
                    const Text(
                      'MTSU Lot',
                      style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, fontFamily: 'Serif'),
                    ),
                    const SizedBox(height: 8),
                    // Small back/forward arrows under the lot name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new),
                          iconSize: 18,
                          splashRadius: 20,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          iconSize: 18,
                          splashRadius: 20,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    // Availability Status Cards
                    _buildStatusCard(
                      label: 'Available:', 
                      count: '17', 
                      color: const Color(0xFFB5F2C8), // Light Green
                    ),
                    const SizedBox(height: 20),
                    _buildStatusCard(
                      label: 'Not Available:', 
                      count: '27', 
                      color: const Color(0xFFC83227), // Red
                      textColor: Colors.black,
                    ),
                    
                    const SizedBox(height: 40),

                    // Traffic Level Bubble
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0FF), // Pale Purple
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: const Column(
                        children: [
                          Text('Traffic Level:', style: TextStyle(fontSize: 18)),
                          Text('Busy', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Area (fixed)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black, width: 4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _HoverRoundButton(text: 'View Map\nView', onTap: () {}),
                  _HoverRoundButton(text: 'View\nFuture\nPredictions', onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build the Available/Not Available cards
  Widget _buildStatusCard({required String label, required String count, required Color color, Color textColor = Colors.black}) {
    return Container(
      width: 320,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
          Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }

}

// Hover-aware circular button that mirrors the IconButton hover effect
class _HoverRoundButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  const _HoverRoundButton({required this.text, this.onTap});

  @override
  State<_HoverRoundButton> createState() => _HoverRoundButtonState();
}

class _HoverRoundButtonState extends State<_HoverRoundButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = const Color(0xFF7AA7F0);
    final hoverColor = Color.lerp(baseColor, Colors.white, 0.12)!;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 140,
          height: 100,
          alignment: Alignment.center,
          transform: Matrix4.identity()..scale(_hovering ? 1.03 : 1.0),
          decoration: BoxDecoration(
            color: _hovering ? hoverColor : baseColor,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.black, width: _hovering ? 3 : 2),
            boxShadow: _hovering
                ? [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 4))]
                : null,
          ),
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
 