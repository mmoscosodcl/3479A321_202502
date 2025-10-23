import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:playground_2502/providers/config_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class PixelArtScreen extends StatefulWidget {
  const PixelArtScreen({super.key});

  @override
  _PixelArtScreenState createState() => _PixelArtScreenState();
}

class _PixelArtScreenState extends State<PixelArtScreen> {
  
  Logger logger = Logger();
  int _sizeGrid = 12;
  Color _selectedColor = Colors.black;
  bool _saveInProgress = false;
  File? _backgroundImage; // To store the background image file
  double _backgroundOpacity = 0.5; // Default opacity
  
  //List of color like wood pencils
  final List<Color> _listColors = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.brown,
    Colors.grey,
    Colors.pink,
  ];

  // Initialize a list to hold the colors of each cell in the grid
  late List<ValueNotifier<Color>> _cellColors;

  @override
  void initState() {
    super.initState();
    // Initialization code here
    logger.d("PixelArtScreen initialized. Mounted: $mounted");
    _sizeGrid = context.read<ConfigurationData>().size;
    logger.d("Grid size set to: $_sizeGrid");
    _cellColors = List.generate(
      _sizeGrid * _sizeGrid,
      (_) => ValueNotifier<Color>(Colors.transparent),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Update _sizeGrid and reinitialize _cellColors if the size changes
    final newSize = context.watch<ConfigurationData>().size;
    if (newSize != _sizeGrid) {
      _sizeGrid = newSize;
      _cellColors = List.generate(
        _sizeGrid * _sizeGrid,
        (_) => ValueNotifier<Color>(Colors.transparent),
      );
      logger.d("Grid size updated to: $_sizeGrid");
    }
  }

  @override
  void didUpdateWidget(covariant PixelArtScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Code to handle widget updates
    logger.d("PixelArtScreen widget updated. Mounted: $mounted");
  }

  @override
  void deactivate() {
    // Code to handle deactivation
    super.deactivate();
    logger.d("PixelArtScreen deactivated. Mounted: $mounted");
  }

  @override
  void dispose() {
    for (final cell in _cellColors) {
      cell.dispose();
    }
    super.dispose();
    logger.d("PixelArtScreen disposed. Mounted: $mounted");
  }

  @override
  void reassemble() {
    super.reassemble();
    // Code to handle hot reload
    logger.d("PixelArtScreen reassembled. Mounted: $mounted");
  }

  Future<void> _savePixelArt() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, _sizeGrid * 20.0, _sizeGrid * 20.0));

    // Draw the grid as pixel art
    for (int row = 0; row < _sizeGrid; row++) {
      for (int col = 0; col < _sizeGrid; col++) {
        final color = _cellColors[row * _sizeGrid + col].value;
        final paint = Paint()..color = color;
        final rect = Rect.fromLTWH(col * 20.0, row * 20.0, 20.0, 20.0);
        canvas.drawRect(rect, paint);
      }
    }

    // Convert the canvas to an image
    final picture = recorder.endRecording();
    final image = await picture.toImage(_sizeGrid * 20, _sizeGrid * 20);

    // Convert the image to bytes
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final imageBytes = byteData!.buffer.asUint8List();

    // Get the app's directory
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/pixel_art_${DateTime.now().millisecondsSinceEpoch}.png';

    // Save the image to the file
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);

    // Log the saved file path
    logger.d("Pixel art saved to: $filePath");

    // Optionally, save the file path to the provider or database
    context.read<ConfigurationData>().addCreation(filePath);

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pixel art saved to: $filePath')),
    );
  }

  Future<void> _debouncedSavePixelArt() async {
    if (_saveInProgress) return;
    _saveInProgress = true;

    await _savePixelArt();

    _saveInProgress = false;
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/background_image.png';

      // Save the new image and delete the old one if it exists
      final newImage = File(pickedFile.path);
      if (_backgroundImage != null && _backgroundImage!.existsSync()) {
        _backgroundImage!.deleteSync();
      }
      newImage.copySync(filePath);

      setState(() {
        _backgroundImage = File(filePath);
      });
    }
  }

  void _deleteBackgroundImage() {
    if (_backgroundImage != null && _backgroundImage!.existsSync()) {
      _backgroundImage!.deleteSync();
    }
    setState(() {
      _backgroundImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Creation Process'),
      ),
      body: SafeArea( // Wrap the Column with SafeArea
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text('$_sizeGrid x $_sizeGrid'),
                SizedBox(width: 8),
                Expanded(
                  child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                    hintText: 'Enter title',
                    border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                    logger.d('Title entered: $value');
                    },
                  ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                  logger.d('Button pressed');
                  },
                  child: const Text('Submit'),
                ),
                                ElevatedButton(
                  onPressed: () async {
                    await _savePixelArt();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Pixel art saved!')),
                    );
                  },
                  child: const Text('Save Pixel Art'),
                ),
                ],
              ),
            ),
            // GridView above the footer
            Expanded(
              child: Stack(
                children: [
                  if (_backgroundImage != null)
                    Opacity(
                      opacity: _backgroundOpacity,
                      child: Image.file(
                        _backgroundImage!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  RepaintBoundary(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _sizeGrid,
                      ),
                      itemCount: _sizeGrid * _sizeGrid,
                      itemBuilder: (context, index) {
                        return ValueListenableBuilder<Color>(
                          valueListenable: _cellColors[index],
                          builder: (context, color, child) {
                            return GestureDetector(
                              onTap: () {
                                _cellColors[index].value = _selectedColor;
                              },
                              child: Container(
                                margin: const EdgeInsets.all(1),
                                color: color,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Footer with selectable colors
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.grey[200],
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _takePicture,
                          icon: Icon(Icons.camera_alt),
                          label: Text('Take Picture'),
                        ),
                        const SizedBox(width: 16),
                        if (_backgroundImage != null)
                          ElevatedButton.icon(
                            onPressed: _deleteBackgroundImage,
                            icon: Icon(Icons.delete),
                            label: Text('Remove Background'),
                          ),
                      ],
                    ),
                    if (_backgroundImage != null)
                      Column(
                        children: [
                          Text('Adjust Background Opacity'),
                          Slider(
                            value: context.watch<ConfigurationData>().backgroundOpacity,
                            min: 0.1,
                            max: 1.0,
                            divisions: 10,
                            label: '${(context.watch<ConfigurationData>().backgroundOpacity * 100).toInt()}%',
                            onChanged: (value) {
                              context.read<ConfigurationData>().setBackgroundOpacity(value);
                              _backgroundOpacity = value; 
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _listColors.map((color) {
                        final bool isSelected = color == _selectedColor;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = color;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: EdgeInsets.all(isSelected ? 12 : 8),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: Colors.black, width: 2)
                                  : null,
                            ),
                            width: isSelected ? 36 : 28,
                            height: isSelected ? 36 : 28,
                          ),
                        );
                      }).toList(),
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

