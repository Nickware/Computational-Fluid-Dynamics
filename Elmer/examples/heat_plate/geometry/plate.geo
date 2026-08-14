SetFactory("OpenCASCADE");

L = 1.0;
Point(1) = {0, 0, 0, 0.1};
Point(2) = {L, 0, 0, 0.1};
Point(3) = {L, L, 0, 0.1};
Point(4) = {0, L, 0, 0.1};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

Line Loop(1) = {1,2,3,4};
Plane Surface(1) = {1};

Physical Line("left") = {4};
Physical Line("right") = {2};
Physical Line("top") = {3};
Physical Line("bottom") = {1};
Physical Surface("domain") = {1};

Mesh.MeshSizeMin = 0.05;
Mesh.MeshSizeMax = 0.05;
