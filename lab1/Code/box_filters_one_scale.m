function [ interest_map] = box_filters_one_scale(I, s )
%% Returns the array of interest points

thresh=0.912;
threshold = 0.02;
%threshold = 0.001;
n = ceil(3*s)*2+1;

xDxx = 2*floor(n/6) + 1;
yDxx = 4*floor(n/6) + 1;
rDxx = floor((n-yDxx)/2);
xDyy = 4*floor(n/6) + 1;
yDyy = 2*floor(n/6) + 1;
xDxy = 2*floor(n/6)+1;
yDxy = 2*floor(n/6)+1;
rDxy = floor((n - xDxy - yDxy)/3);

sDxy = floor((n - xDxy - yDxy)/3);
mDxy = ceil((n - xDxy - yDxy)/3);
if(sDxy + sDxy + mDxy ~= n-xDxy - yDxy)
    sDxy = ceil((n - xDxy - yDxy)/3);
    mDxy = floor((n - xDxy - yDxy)/3);
end

Ipadded = padarray(I,[floor(n/2) floor(n/2)], 'replicate');
intI = integralImage(Ipadded);

% dxx = integralKernel([1,1,n,n; 1,rDxx+1,n,yDxx; floor((n-xDxx)/2)+1,rDxx+1,xDxx,yDxx], [0,1,-3]);
% %dyy = integralKernel([1,1,n,n; rDxx+1,1,xDyy,n; rDxx+1,yDyy+1,xDyy,yDyy], [0,1,-3]);
% dyy = dxx.';
% dxy = integralKernel([1,1,n,n; sDxy+1,sDxy+1,xDxy,yDxy; xDxy+sDxy+mDxy+1,xDxy+sDxy+mDxy+1,xDxy,yDxy; sDxy+1,xDxy+sDxy+mDxy+1,xDxy,yDxy; xDxy+sDxy+mDxy+1,sDxy+1,xDxy,yDxy;], [0,1,1,-1,-1]);


%%%% Lxx
%Central Box
magn = -3;
shiftX = (xDxx -1)/2;
shiftY = (yDxx -1)/2;
pad = floor(n/2) + 1;
[ tsA,tsB,tsC,tsD ] = computeSs_Integral( intI, shiftX, shiftY , 0, 0);
sA = unpad(tsA,pad);
sB = unpad(tsB,pad);
sC = unpad(tsC,pad);
sD = unpad(tsD,pad);
Lxx = (sD + sA - sB - sC) * magn;
%Left and Right Box
magn = 1;
shiftX = (xDxx -1)/2 + xDxx;
shiftY = (yDxx -1)/2;
[ tsA,tsB,tsC,tsD ] = computeSs_Integral( intI, shiftX, shiftY ,0, 0);
sA = unpad(tsA,pad);
sB = unpad(tsB,pad);
sC = unpad(tsC,pad);
sD = unpad(tsD,pad);
Lxx = (sD + sA - sB - sC) * magn + Lxx;


%%%% Lyy
%Central Box
magn = -3;
shiftX = (xDyy -1)/2;
shiftY = (yDyy -1)/2;
[ tsA,tsB,tsC,tsD ] = computeSs_Integral( intI, shiftX, shiftY ,0, 0);
sA = unpad(tsA,pad);
sB = unpad(tsB,pad);
sC = unpad(tsC,pad);
sD = unpad(tsD,pad);
Lyy = (sD + sA - sB - sC) * magn;
%Top and Bottom Box
magn = 1;
shiftX = (xDyy -1)/2;
shiftY = (yDyy -1)/2 + yDyy;
[ tsA,tsB,tsC,tsD ] = computeSs_Integral( intI, shiftX, shiftY , 0 , 0);
sA = unpad(tsA,pad);
sB = unpad(tsB,pad);
sC = unpad(tsC,pad);
sD = unpad(tsD,pad);
Lyy = (sD + sA - sB - sC) * magn + Lyy;


%%% Prosoxh thewrw pws h endiamesh lorida einai panta 1 paxos
if( mod(ceil((n-2*xDxy)/3),2) == 1)
    rDxy = ceil((n-2*xDxy)/3);
else
    rDxy = floor((n-2*xDxy)/3);
end;



%%%% Lxy
%Top Right Box
magn = -1;
offsetx = -(rDxy-1)/2 - (xDxy -1)/2; 
offsety = (rDxy-1)/2 + (yDxy -1)/2; 
shiftX = (xDxy -1)/2;
shiftY = (yDxy -1)/2;
[ tsA,tsB,tsC,tsD ] = computeSs_Integral( intI, shiftX, shiftY, offsetx, offsety );
sA = unpad(tsA,pad);
sB = unpad(tsB,pad);
sC = unpad(tsC,pad);
sD = unpad(tsD,pad);
Lxy = (sD + sA - sB - sC) * magn;
%Top Left Box
magn = 1;
offsetx = (rDxy-1)/2 + (xDxy -1)/2; 
offsety = (rDxy-1)/2 + (yDxy -1)/2; 
shiftX = (xDxy -1)/2;
shiftY = (yDxy -1)/2;
[ tsA,tsB,tsC,tsD ] = computeSs_Integral( intI, shiftX, shiftY, offsetx, offsety  );
sA = unpad(tsA,pad);
sB = unpad(tsB,pad);
sC = unpad(tsC,pad);
sD = unpad(tsD,pad);
Lxy = (sD + sA - sB - sC) * magn + Lxy;
%Bottom Left Box
magn = -1;
offsetx = (rDxy-1)/2 + (xDxy -1)/2; 
offsety = -(rDxy-1)/2 - (yDxy -1)/2; 
shiftX = (xDxy -1)/2;
shiftY = (yDxy -1)/2;
[ tsA,tsB,tsC,tsD ] = computeSs_Integral( intI, shiftX, shiftY, offsetx, offsety  );
sA = unpad(tsA,pad);
sB = unpad(tsB,pad);
sC = unpad(tsC,pad);
sD = unpad(tsD,pad);
Lxy = (sD + sA - sB - sC) * magn + Lxy;
%Bottom Right Box
magn = 1;
offsetx = -(rDxy-1)/2 - (xDxy -1)/2; 
offsety = -(rDxy-1)/2 - (yDxy -1)/2; 
shiftX = (xDxy -1)/2;
shiftY = (yDxy -1)/2;
[ tsA,tsB,tsC,tsD ] = computeSs_Integral( intI, shiftX, shiftY, offsetx, offsety  );
sA = unpad(tsA,pad);
sB = unpad(tsB,pad);
sC = unpad(tsC,pad);
sD = unpad(tsD,pad);
Lxy = (sD + sA - sB - sC) * magn + Lxy;


%Lxx = integralFilter(intI,dxx);
%Lxy = integralFilter(intI,dxy);
%Lyy = integralFilter(intI,dyy);
%criterion
R=Lxx.*Lyy - (thresh*Lxy).^2;


%Finds maxima
ns=ceil(3*s)*2+1;
B_sq = strel('disk', ns);
maxima = (R==imdilate(R,B_sq));
Rmax = max(max(R));

interest_map = (maxima & (R >= threshold * Rmax));




end

