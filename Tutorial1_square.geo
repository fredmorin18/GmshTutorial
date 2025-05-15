// Gmsh project created on Sat Apr  5 11:58:58 2025

// Top right corner of inner square

Point(1) = {0, 0, 0};
Point(2) = {0, 1, 0};
Point(3) = {1, 1, 0};
Point(4) = {1, 0, 0};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

Curve Loop(1) = {1, 2 ,3, 4};
Plane Surface(1) = {1};

// Outer portion of O-grid in top right corner

// Points on arc
Point(5) = {0, 2, 0};
Point(6) = {2*Cos(Pi/4), 2*Cos(Pi/4), 0};
Point(7) = {2, 0, 0};

// New lines to define
Line(5) = {2, 5};
Circle(6) = {5, 1, 6};  // Creates an arc starting from point 5 to point 6 centred on point 1 in
Line(7) = {6, 3};
Circle(8) = {6, 1, 7};
Line(9) = {7, 4};

// Creating new surfaces
// Here we need to reverse some lines (specified by using a - sign) in the surface loops because 
// the lines need to all be clockwise or counterclockwise to define and edge (and thus surface normal)
// orientation
Curve Loop(2) = {5, 6, 7, -2};
Surface(2) = {2};
Curve Loop(3) = {8, 9, -3, -7};
Surface(3) = {3};

// Now let's mesh the sufaces

// Introduce refinement parameters to make it easier to change the mesh later
// These are the number of nodes on each line segment (i,e, number of cells 
// in a direction +1)
dX =  5; // Angular and center refinement parameter
dRad = 5; // Radial refinement parameter

Transfinite Curve {1, 2, 3, 4, 6, 8} = dX;
Transfinite Curve {5, 7, 9} = dRad;
Transfinite Surface {1, 2, 3};
Recombine Surface {1, 2, 3};

// Now let's copy our surface to make te other three quarters of the inlet

Geometry.CopyMeshingMethod = 1;

topLeft[] = Rotate{{0, 0, 1}, {0,0,0}, Pi/2} {Duplicata{Surface{1,2,3};}};
bottomLeft[] = Rotate{{0, 0, 1}, {0,0,0}, Pi} {Duplicata{Surface{1,2,3};}};
bottomRight[] = Rotate{{0, 0, 1}, {0,0,0}, 3*Pi/2} {Duplicata{Surface{1,2,3};}};
Mesh 2;
Coherence;

// Finally, let's extrude our mesh to make the pipe
 pipe[] = Extrude{0, 0, 40} {Surface{:}; Layers{120}; Recombine;};
 Mesh 3;
 
 
 //Physical groups for export
//+
Physical Surface("Inlet", 1) = {177, 89, 67, 133, 111, 287, 265, 309, 221, 199, 243, 155};
//+
Physical Surface("Outlet", 2) = {2, 1, 20, 10, 15, 32, 22, 27, 44, 34, 39, 3};
//+
Physical Surface("Walls", 3) = {146, 230, 164, 80, 98, 278, 296, 212};
//+
Physical Volume("Pipe", 4) = {5, 9, 4, 1, 2, 6, 3, 11, 10, 12, 7, 8};

//Setting the file format for export (2.2 is version 2 ASCII format, the only format supported by OF12 for import).

Mesh.MshFileVersion = 2.2;

