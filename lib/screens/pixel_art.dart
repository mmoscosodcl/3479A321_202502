import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class PixelArtScreen extends StatefulWidget {
  const PixelArtScreen({super.key});

  @override
  _PixelArtScreenState createState() => _PixelArtScreenState();
}

class _PixelArtScreenState extends State<PixelArtScreen> {
  Logger logger = Logger();
  int _sizeGrid = 16;
  Color _selectedColor = Colors.black;
  bool _isPaintMode = false;

  //Matrix for the pixel art
  // This would typically be loaded from a JSON file.
  List<List<int>> _pixelArtGrid = [];
  //Set all the _pixelArtGrid to -1 initially
  



  // The data in the JSON will look like this.
  final Map<String, dynamic> _pixelArtData = {
    "size": 8,
    "palette": [
      0xFF000000,
      0xFFFFFFFF,
      0xFFFF0000,
      0xFF00FF00,
      0xFF0000FF,
      0xFFFFFF00,
      0xFFFF00FF,
      0xFF00FFFF,
    ],
    "grid": [
      0,
      0,
      1,
      1,
      1,
      1,
      0,
      0,
      0,
      1,
      2,
      2,
      2,
      2,
      1,
      0,
      1,
      2,
      3,
      3,
      3,
      3,
      2,
      1,
      1,
      2,
      2,
      2,
      2,
      2,
      2,
      1,
      1,
      2,
      3,
      4,
      4,
      3,
      2,
      1,
      1,
      2,
      3,
      3,
      3,
      3,
      2,
      1,
      0,
      1,
      2,
      2,
      2,
      2,
      1,
      0,
      0,
      0,
      1,
      1,
      1,
      1,
      0,
      0,
    ],
  };

  // Initialize a list to hold the colors of each cell in the grid
  late final List<Color> _cellColors = List<Color>.generate(
    _sizeGrid * _sizeGrid,
    (index) => Colors.transparent,
  );

  List<Color> _getConvertedPaletteColors() {
    return (_pixelArtData['palette'] as List<int>)
        .map((colorValue) => Color(colorValue))
        .toList();
  }

  int _getColorIndexForCell(int cellIndex) {
    final grid = _pixelArtData['grid'] as List<int>;
    if (cellIndex >= 0 && cellIndex < grid.length) {
      return grid[cellIndex];
    }
    return -1;
  }

  void _loadFinalPixelArtFromData() {
    final size = _pixelArtData['size'] as int;
    final grid = _pixelArtData['grid'] as List<int>;
    final paletteColors = _getConvertedPaletteColors();

    setState(() {
      _sizeGrid = size;
      _cellColors.clear();

      int j = 0, k = 0;
      for (int i = 0; i < grid.length; i++) {
         
        _pixelArtGrid[j][k] = grid[i]; // Update the matrix
        final colorIndex = grid[i];
        if (colorIndex >= 0 && colorIndex < paletteColors.length) {
          _cellColors.add(paletteColors[colorIndex]);
        } else {
          _cellColors.add(Colors.transparent);
        }
        k++;
        if (k >= _sizeGrid) {
          k = 0;
          j++;
        }
      }
    });

    _printPixelArtGrid();
    logger.d(
      "Pixel art loaded: ${_sizeGrid}x$_sizeGrid grid with ${paletteColors.length} colors",
    );
  }

  void _initializePixelArtGrid(int size) {
    _pixelArtGrid = List.generate(
      size,
      (_) => List.generate(size, (_) => -1),
    );
  }
  void _printPixelArtGrid() {
    print(_pixelArtGrid);
  } 


  @override
  void initState() {
    super.initState();
    // Initialization code here
    logger.d("PixelArtScreen initialized. Mounted: $mounted");

    _sizeGrid = _pixelArtData['size'] as int;
    logger.d("Grid size set to: $_sizeGrid");

    _initializePixelArtGrid(_sizeGrid);

    _loadFinalPixelArtFromData();

    
    _printPixelArtGrid();


  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Code to handle changes in dependencies
    logger.d("Dependencies changed in PixelArtScreen. Mounted: $mounted");
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
    // Cleanup code here
    super.dispose();
    logger.d("PixelArtScreen disposed. Mounted: $mounted");
  }

  @override
  void reassemble() {
    super.reassemble();
    // Code to handle hot reload
    logger.d("PixelArtScreen reassembled. Mounted: $mounted");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creation Process')),
      body: SafeArea(
        // Wrap the Column with SafeArea
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$_sizeGrid x $_sizeGrid'),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _loadFinalPixelArtFromData,
                    child: const Text('Load'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        for (int i = 0; i < _cellColors.length; i++) {
                          _cellColors[i] = Colors.transparent;
                        }
                      });
                      logger.d('Grid cleared');
                    },
                    child: const Text('Clear'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _isPaintMode,
                        onChanged: (bool? value) {
                          setState(() {
                            _isPaintMode = value ?? false;

                            if (_isPaintMode) {
                              setState(() {
                                for (int i = 0; i < _cellColors.length; i++) {
                                  _cellColors[i] = Colors.transparent;
                                }
                              });
                            }
                          });
                          logger.d('Paint mode: $_isPaintMode');
                        },
                        activeColor: Colors.blue,
                      ),
                      Text(
                        'Paint Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: _isPaintMode ? Colors.blue : Colors.black87,
                        ),
                      ),
                    ],
                  ),
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
                ],
              ),
            ),
            // GridView above the footer
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _sizeGrid,
                ),
                itemCount: _sizeGrid * _sizeGrid,
                itemBuilder: (context, index) {
                  final colorIndex = _getColorIndexForCell(index);
                  return GestureDetector(
                    onTap:
                        _isPaintMode
                            ? () {
                              setState(() {
                                _cellColors[index] = _selectedColor;
                              });
                              logger.d(
                                'Painted cell $index with color $_selectedColor',
                              );
                            }
                            : null, // Only allow tap if in Paint Mode.
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: _cellColors[index],
                        border:
                            _isPaintMode
                                ? Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                  width: 0.5,
                                )
                                : null,
                      ),
                      child: Center(
                        child: Text(
                          colorIndex >= 0 ? '$colorIndex' : '',
                          style: TextStyle(
                            color:
                                _cellColors[index] == Colors.black
                                    ? Colors.white
                                    : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Footer with selectable colors
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.grey[200],
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      _getConvertedPaletteColors().asMap().entries.map((entry) {
                        final int index = entry.key;
                        final Color color = entry.value;
                        final bool isSelected = color == _selectedColor;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = color;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: EdgeInsets.all(isSelected ? 12 : 8),
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border:
                                        isSelected
                                            ? Border.all(
                                              color: Colors.black,
                                              width: 2,
                                            )
                                            : null,
                                  ),
                                  width: isSelected ? 36 : 28,
                                  height: isSelected ? 36 : 28,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '$index',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
