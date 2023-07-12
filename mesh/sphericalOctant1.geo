r2 = .0304; // meters;  to make sphere volume 118.2 mL = 11.82e-5 m^3
r1 = r2-.00335; // 3.35mm = .00335m
lc = .025*r1;


// inner
Point(1) = {0,0,0,lc};
Point(2) = {r1,0,0,lc};
// Point(3) = {0,r1,0,lc};
Point(5) = {0,-r1,0,lc};
// Point(6) = {0,0,-r1,lc};
Point(7) = {0,0,-r1,lc};

// Circle(1) = {2,1,3};
Circle(4) = {5,1,2};
// Circle(5) = {3,1,6};
// Circle(6) = {6,1,5};
Circle(7) = {5,1,7};
// Circle(8) = {7,1,3};
Circle(9) = {2,1,7};
// Circle(12) = {6,1,2};

// outer
Point(31) = {0,0,0,lc};
Point(32) = {r2,0,0,lc};
// Point(33) = {0,r2,0,lc};
// Circle(21) = {32,31,33};
Point(35) = {0,-r2,0,lc};
Circle(24) = {35,31,32};
// Point(36) = {0,0,-r2,lc};
Point(37) = {0,0,-r2,lc};
// Circle(25) = {33,31,36};
// Circle(26) = {36,31,35};
Circle(27) = {35,31,37};
// Circle(28) = {37,31,33};
Circle(29) = {32,31,37};
// Circle(32) = {36,31,32};

// connecting lines
// Line(33) = {33, 3};
Line(34) = {37, 7};
Line(35) = {5, 35};
// Line(36) = {6, 36};
Line(90) = {2,32};

// Line Loop(37) = {21,25,32};
// Ruled Surface(38) = {37};
// Line Loop(39) = {29,28,-21};
// Ruled Surface(40) = {39};
Line Loop(41) = {29,-27,24};
Ruled Surface(42) = {41};
// Line Loop(43) = {26,24,-32};
// Ruled Surface(44) = {43};
// Line Loop(45) = {1,5,12};
// Ruled Surface(46) = {45};
// Line Loop(47) = {6,4,-12};
// Ruled Surface(48) = {47};
Line Loop(49) = {4,9,-7};
Ruled Surface(50) = {49};
// Line Loop(51) = {9,8,-1};
// Ruled Surface(52) = {51};
Line Loop(53) = {7,-34,-27,-35};
Ruled Surface(54) = {53};
// Line Loop(55) = {36,26,-35,-6};
// Ruled Surface(56) = {55};
// Line Loop(57) = {33,5,36,-25};
// Ruled Surface(58) = {57};
// Line Loop(59) = {34,8,-33,-28};
// Ruled Surface(60) = {59};
Line Loop(70) = {35,24,-90,-4};
Ruled Surface(71) = {70};
Line Loop(72) = {-9,90,29,34};
Ruled Surface(73) = {72};

Surface Loop(61) = {50,42,54,71,73};
Physical Surface(65) = {50}; // inner
Physical Surface(66) = {42}; // outer
Physical Surface(67) = {71}; // top face (X-Y plane)
Physical Surface(74) = {73}; // left face (X-Z plane)
Physical Surface(75) = {54}; // right face (Y-Z plane)

Volume(62) = {61};
Physical Volume(63) = {62};
