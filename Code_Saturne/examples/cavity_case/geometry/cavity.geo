// Geometría base para caso de cavidad 2D
// Este archivo representa un dominio cuadrado y se usa como plantilla inicial.

L = 1.0;
Point(1) = {0, 0, 0, 1.0};
Point(2) = {L, 0, 0, 1.0};
Point(3) = {L, L, 0, 1.0};
Point(4) = {0, L, 0, 1.0};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

Line Loop(1) = {1, 2, 3, 4};
Plane Surface(1) = {1};

Physical Line("bottom") = {1};
Physical Line("right") = {2};
Physical Line("top") = {3};
Physical Line("left") = {4};
Physical Surface("fluid") = {1};
