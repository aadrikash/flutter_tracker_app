import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// AR Experience screen.
///
/// Uses [ModelViewer] (model_viewer_plus) to render an interactive 3D model.
/// On Android devices that support ARCore, the built-in "View in AR" button
/// launches Google Scene Viewer for a true AR experience — no native plugin
/// setup required.  On other devices it falls back to a 3D interactive viewer.
class ARScreen extends StatelessWidget {
  const ARScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Experience'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Info banner ────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
            ),
            child: const Text(
              '🔷 Drag to rotate • Pinch to zoom\n'
              'Tap "View in AR" (on supported Android devices) for real AR.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
          ),

          // ── 3D model viewer ───────────────────────────────────────────
          Expanded(
            child: ModelViewer(
              // Background colour – neutral so it adapts to both themes.
              backgroundColor: const Color(0xFFF0F0F0),

              // Public domain Astronaut GLB model hosted by Google's
              // model-viewer project (no API key required).
              src:
                  'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
              alt: 'A 3D model of an astronaut',

              // ar: true enables the "View in AR" button on Android devices
              // that support ARCore / Scene Viewer.
              ar: true,

              // Automatically spin the model for a more impressive demo.
              autoRotate: true,
              autoRotateDelay: 0,

              // Let the user interact with the model.
              cameraControls: true,
            ),
          ),

          // ── Footer hint ───────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              '✨ Powered by Google Scene Viewer & model-viewer',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
