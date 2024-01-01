r2 = 30.4; // millimeters;  to make sphere volume 118.2 mL = 11.82e-5 m^3
r1 = r2-3.35; // 3.35mm = .00335m
lc = .05*r1;

SetFactory("OpenCASCADE");

//Mesh.Algorithm = 6;
Mesh.CharacteristicLengthMin = lc;
Mesh.CharacteristicLengthMax = lc;

// Spherical Shell
Sphere(1) = {0, 0, 0, r1}; // small
Sphere(2) = {0, 0, 0, r2}; // large
BooleanDifference(3) = { Volume{2}; Delete;}{ Volume{1}; Delete;};

// Cube
Box(4) = {0, 0, 0, r2, -r2, -r2};

// Spherical Octant
BooleanIntersection(5) = { Volume{3}; Delete;}{ Volume{4}; Delete;};

// Splitting Surfaces
Rectangle(6) = {0,0,0,r2,-r2};
Rotate{{0,r2,0}, {0,0,0}, Pi/4}{Surface{6};}
Rectangle(7) = {0,0,0,r2,-r2};
Rotate{{r2,0,0}, {0,0,0}, Pi/4}{Surface{7};}
Rectangle(8) = {0,0,0,r2,-r2};
Rotate{{0,-r2,0}, {0,0,0}, -Pi/2}{Surface{8};}
Rotate{{0,0,-r2}, {0,0,0}, -Pi/4}{Surface{8};}

// Fragmentation
BooleanFragments{Volume{5}; Delete;}{Surface{6:8}; Delete;}
Delete{Surface{25:36}; Curve{36:52};}

/*
Looking at inner surface of Octant and +Z is up
Left and Right are as viewed
Three vertical levels (top, middle, bottom)

Volume(1) = bottom-left = v1
Volume(2) = bottom-right
Volume(3) = middle-left
Volume(4) = middle-right
Volume(5) = top-right
Volume(6) = top-left

From now on, we label surfaces by their associated volume number

Surface(1) = outer1
Surface(2) = volume1/volume2
Surface(3) = v1/v3
Surface(4) = face1
Surface(5) = inner1
Surface(6) = outer2
Surface(7) = face2
Surface(8) = v2/v4
Surface(9) = inner2
Surface(10) = outer3
Surface(11) = v3/v6
Surface(12) = face3
Surface(13) = inner3
Surface(14) = outer4
Surface(15) = face4
Surface(16) = v4/v5
Surface(17) = inner4
Surface(18) = face5
Surface(19) = outer5
Surface(20) = v5/v6
Surface(21) = inner5
Surface(22) = inner6
Surface(23) = outer6
Surface(24) = face6
*/

SetFactory("Built-in");

// Physical Volumes
Physical Volume(1) = {2,4}; // right volume (Y-Z plane)
Physical Volume(2) = {5,6}; // top volume (X-Y plane)
Physical Volume(3) = {1,3}; // left volume (X-Z plane)

// Physical Volumes
Physical Surface(1) = {6,14}; // right outer
Physical Surface(2) = {19,23}; // top outer
Physical Surface(3) = {1,10}; // left outer
Physical Surface(4) = {9,17}; // right inner
Physical Surface(5) = {21,22}; // top inner
Physical Surface(6) = {5,13}; // left inner
Physical Surface(7) = {7,15}; // right face
Physical Surface(8) = {18,24}; // top face
Physical Surface(9) = {4,12}; // left face
Physical Surface(10) = {2}; // v1/v2
Physical Surface(11) = {3}; // v1/v3
Physical Surface(12) = {8}; // v2/v4
Physical Surface(13) = {11}; // v3/v6
Physical Surface(14) = {16}; // v4/v5
Physical Surface(15) = {20}; // v5/v6

