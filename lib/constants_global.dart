
const double cellHitBoxRelativeSize = 0.6;

// Each shape is a list. The list contains tuples specifying the column
// and row of each tile that makes up the shape:
//  tuples of (row, column), represent where the cell is in the block tile
const constBlockShapesListAlt = [
  [(1, 1)],

  // Wedge shape
  [(1, 1), (1, 2), (1, 1)],
  [(0, 0), (0, 1), (1, 0)],
  [(1, 1), (0, 1), (1, 0)],
  [(1, 1), (0, 1), (1, 0)],

  // Line shapes, horizontal and vertical, 3 and 2 piece versions
  [(0, 1), (1, 1), (2, 1)],
  [(0, 1), (1, 1)],
  [(1, 0), (1, 1), (1, 2)],
  [(1, 0), (1, 1)],

  // Box
  [(0, 0), (0, 1), (1, 0), (1, 1)],

  // [(0, 0), (1, 0), (2, 0), (3, 0)], // This one is a flat line shape
  // [(0, 0), (1, 0), (0, 1), (1, 1)],
  // [(0, 0), (1, 0), (2, 0), (2, 1)],
  // [(0, 0), (1, 0), (2, 0), (1, 1)],
];

const List<List<List<int>>> constBlockShapesList = [ // 2 x 2 Array
  // Full 4 x 4 block
  /*
  [ [1, 1, 1, 1],
    [1, 1, 1, 1],
    [1, 1, 1, 1],
    [1, 1, 1, 1]
  ],*/

  // Box
  [ [0, 0, 0, 0],
    [0, 1, 1, 0],
    [0, 1, 1, 0],
    [0, 0, 0, 0],
  ],

  // Lines
  [ [0, 0, 0, 0],
    [1, 1, 1, 1],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
  ],

  // Wedges
  [ [0, 0, 0, 0],
    [0, 1, 0, 0],
    [0, 1, 1, 0],
    [0, 0, 0, 0],
  ],

  // L shapes
  [ [0, 1, 0, 0],
    [0, 1, 0, 0],
    [0, 1, 1, 0],
    [0, 0, 0, 0],
  ],

  // Middle block
  [ [0, 1, 0, 0],
    [0, 1, 0, 0],
    [0, 1, 1, 0],
    [0, 0, 0, 0],
  ],

  // Z block
  [ [0, 0, 0, 0],
    [0, 1, 1, 0],
    [1, 1, 0, 0],
    [0, 0, 0, 0],
  ],
];