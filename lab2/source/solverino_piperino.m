
%%Solve the linear system 2x2
syms GrA12 GrA11 GrA22 e GrA1E GrA2E ux uy su
Matrix = [GrA11 + e GrA12; 
          GrA12 GrA22 + e];
Inverse = simplify(expand(inv(Matrix)));
SimpleInv = Inverse * det(Matrix);
su=SimpleInv * [GrA1E; GrA2E];
