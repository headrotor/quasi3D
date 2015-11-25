# quasi3D
Processing and OpenSCAD code to generate 3D quasicrystal solids seen in my Instructable at http://www.instructables.com/id/3D-Printing-Quasicrystal-Shapes/

This code is not that user-friendly, sorry. Options are chosen by changing the code. 

Processing: 

quasic.pde:
generates a grayscale image of a quasicrystal, or a gallery. Uncomment
lines in setup() to choose.

zslices.c
OpenSCAD: reads grayscale image and lofts it into a 3D solid. To get inside (opaque) and outside (clear resin) you must run twice with "inside" variable set to true and false respectively. This gives you two .STL files you print at once. Warning: rendering can take the better part of an hour or more.
