r2 = 30.4; // millimeters;  to make sphere volume 118.2 mL = 11.82e-5 m^3
r1 = r2-3.35; // 3.35mm = .00335m
lc = .05*r1;

// extra points for new blocks
a1 = r1/Sqrt(3);
a2 = r2/Sqrt(3);
Point(201) = {a1,-a1,-a1,lc};
Point(202) = {a2,-a2,-a2,lc};

// inner
Point(1) = {0,0,0,lc};
Point(2) = {r1,0,0,lc};
Point(5) = {0,-r1,0,lc};
Point(7) = {0,0,-r1,lc};
Circle(4) = {5,1,2};
Circle(7) = {5,1,7};
Circle(9) = {2,1,7};

// outer
Point(31) = {0,0,0,lc};
Point(32) = {r2,0,0,lc};
Point(35) = {0,-r2,0,lc};
Circle(24) = {35,31,32};
Point(37) = {0,0,-r2,lc};
Circle(27) = {35,31,37};
Circle(29) = {32,31,37};

// dividing lines
Circle(13) = {7,1,201};
Circle(14) = {2,1,201};
Circle(15) = {5,1,201};
Circle(16) = {37,1,202};
Circle(17) = {32,1,202};
Circle(18) = {35,1,202};
Line(200) = {201,202};

// connecting lines
Line(34) = {37, 7};
Line(35) = {5, 35};
Line(90) = {2,32};

// main surfaces
Line Loop(53) = {7,-34,-27,-35}; // right face (Y-Z plane)
Ruled Surface(54) = {53}; // right face (Y-Z plane)
Line Loop(70) = {35,24,-90,-4}; // top face (X-Y plane)
Ruled Surface(71) = {70}; // top face (X-Y plane)
Line Loop(72) = {-9,90,29,34}; // left face (X-Z plane)
Ruled Surface(73) = {72}; // left face (X-Z plane)

// dividing surfaces
Line Loop(274) = {13,200,-16,34};
Ruled Surface(275) = {274};
Line Loop(276) = {14,200,-17,-90};
Ruled Surface(277) = {276};
Line Loop(278) = {15,200,-18,-35};
Ruled Surface(279) = {278};

// inner surfaces
Line Loop(280) = {15,-13,-7};
Ruled Surface(281) = {280};
Line Loop(282) = {15,-14,-4};
Ruled Surface(283) = {282};
Line Loop(284) = {13,-14,9};
Ruled Surface(285) = {284};

// outer surfaces
Line Loop(286) = {16,-18,27};
Ruled Surface(287) = {286};
Line Loop(288) = {18,-17,-24};
Ruled Surface(289) = {288};
Line Loop(290) = {16,-17,29};
Ruled Surface(291) = {290};

// Physical Surfaces - MOOSE Side Sets
Physical Surface(65) = {281,283,285}; // inner
Physical Surface(66) = {287,289,291}; // outer
Physical Surface(67) = {71}; // top face (X-Y plane)
Physical Surface(74) = {73}; // left face (X-Z plane)
Physical Surface(75) = {54}; // right face (Y-Z plane)

// block volumes
Surface Loop(80) = {281,275,54,279,287};
Volume(81) = {80};  // right volume (Y-Z plane)
Surface Loop(83) = {283,277,71,279,289}; 
Volume(84) = {83}; // top volume (X-Y plane)
Surface Loop(86) = {285,73,277,275,291};
Volume(87) = {86}; // left volume (X-Z plane)

// Physical volumes - MOOSE Node Sets?
Physical Volume(82) = {81};  // right volume (Y-Z plane)
Physical Volume(85) = {84}; // top volume (X-Y plane)
Physical Volume(88) = {87}; // left volume (X-Z plane)
// Physical Volume(91) = {81,84,87}; // total volume