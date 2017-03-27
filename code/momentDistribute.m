function phi = momentDistribute(I, state)
% calculate moment invariants for input state
% DENOTE H as the height, W as the width of input image I
%        M as the number of moment invariants in each channel
% INPUT     - I:            H*W*3
%           - state:        1*4 ... [xl, yl, width, height]         
% OUTPUT    - phi:          1*3M ... [R:1*M, G:1*M, B:1*M]

I = double(I);
% I = I - min(I(:));
% I = I / max(I(:));

height = round(state(4));
width = round(state(3));
xl = max(round(state(1)), 1);
yl = max(round(state(2)), 1);
xr = min(xl + width - 1, size(I, 2));
yr = min(yl + height - 1, size(I, 1));
target = I(yl : yr, xl : xr, :);
phi = [];

for i = 1 : 3
    eta = calNCM(target(:, :, i));
    I1 = eta(1) + eta(5);
    I2 = (eta(5) - eta(1))^2 + 4*eta(3)^2;
    I3 = (eta(7) - 3*eta(4))^2 + (3*eta(6) - eta(2))^2;
    I4 = (eta(7) + eta(4))^2 + (eta(6) + eta(2))^2;
    I5 = (eta(7) - 3*eta(4)) * (eta(7) + eta(4)) * ((eta(7) + eta(4))^2 - ...
        3*(eta(6) + eta(2))^2) + (3*eta(6) - eta(2)) * (eta(6) + eta(2)) *...
        (3*(eta(7) + eta(4))^2 - (eta(6) + eta(2))^2);
    I6 = (eta(5) - eta(1)) * ((eta(7) + eta(4))^2 - (eta(6) + eta(2))^2)...
        + 4 * eta(3) * (eta(7) + eta(4)) * (eta(6) + eta(2));
    I7 = (3*eta(6) - eta(2)) * (eta(7) + eta(4)) * ((eta(7) + eta(4))^2 - ...
        3*(eta(6) + eta(2))^2) - (eta(7) - 3*eta(4)) * (eta(6) + eta(2)) *...
        (3*(eta(7) + eta(4))^2 - (eta(6) + eta(2))^2);
    phi = [phi, [I1, I2, I3, I4, I5, I6, I7]];
end

end

function eta = calNCM(I)
% calculate normalized central moment
% DENOTE H as the height, W as the width of input image I
%        M as the number of moment invariants in each channel
% INPUT     - I:            H*W       
% OUTPUT    - eta:          1*7

[mu00, mu02, mu03, mu11, mu12, mu20, mu21, mu30]= calmu(I);
e02 = mu02/mu00^2;
e03 = mu03/mu00^2.5;
e11 = mu11/mu00^2;
e12 = mu12/mu00^2.5;
e20 = mu20/mu00^2;
e21 = mu21/mu00^2.5;
e30 = mu30/mu00^2.5;
eta = [e02, e03, e11, e12, e20, e21, e30];

end


function [mu00, mu02, mu03, mu11, mu12, mu20, mu21, mu30]= calmu(I)
% calculate central moment
% DENOTE H as the height, W as the width of input image I
%        M as the number of moment invariants in each channel
% INPUT     - I:            H*W       
% OUTPUT    - mu00:         1*1
%           - mu02:         1*1
%           - mu03:         1*1
%           - mu11:         1*1
%           - mu12:         1*1
%           - mu20:         1*1
%           - mu21:         1*1
%           - mu30:         1*1

[row, column] = size(I);
x = 1 : row;
y = 1 : column;
m00 = calMoment(0, 0, x, y, I);
m10 = calMoment(1, 0, x, y, I);
m01 = calMoment(0, 1, x, y, I);
xmu = m10/m00;
ymu = m01/m00;
mu00 = calCenMoment(0, 0, x, y, xmu, ymu, I);
mu02 = calCenMoment(0, 2, x, y, xmu, ymu, I);
mu03 = calCenMoment(0, 3, x, y, xmu, ymu, I);
mu11 = calCenMoment(1, 1, x, y, xmu, ymu, I);
mu12 = calCenMoment(1, 2, x, y, xmu, ymu, I);
mu20 = calCenMoment(2, 0, x, y, xmu, ymu, I);
mu21 = calCenMoment(2, 1, x, y, xmu, ymu, I);
mu30 = calCenMoment(3, 0, x, y, xmu, ymu, I);

end

function mpq = calMoment(p, q, x, y, I)
% calculate moment for a 2D image
% DENOTE H as the height, W as the width of input image I
%        M as the number of moment invariants in each channel
% INPUT     - I:            H*W   
%           - p:            1*1
%           - q:            1*1
%           - x:            1*H
%           - y:            1*W
% OUTPUT    - mpq:          1*1

xp = x.^p;
yq = y.^q;
mpq = xp*I*yq';

end

function mupq = calCenMoment(p, q, x, y, xmu, ymu, I)
% calculate central moment for a 2D image
% DENOTE H as the height, W as the width of input image I
%        M as the number of moment invariants in each channel
% INPUT     - I:            H*W   
%           - p:            1*1
%           - q:            1*1
%           - x:            1*H
%           - y:            1*W
%           - xmu:          1*1
%           - ymu:          1*1
% OUTPUT    - mupq:         1*1

xp = (x - xmu).^p;
yq = (y - ymu).^q;
mupq = xp*I*yq';

end

