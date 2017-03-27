function p = colorDistribute(I, state)
% calculate color histogram for input state
% DENOTE H as the height, W as the width of input image I
%        M as the number of color bins in each channel
% INPUT     - I:            H*W*3
%           - state:        1*4 ... [xl, yl, width, height]         
% OUTPUT    - p:            1*3M ... [R:1*M, G:1*M, B:1*M]

% initialize
pR = zeros(1, 8);
pG = zeros(1, 8);
pB = zeros(1, 8);
height = round(state(4));
width = round(state(3));
xl = max(round(state(1)), 1);
yl = max(round(state(2)), 1);
xr = min(xl + width - 1, size(I, 2));
yr = min(yl + height - 1, size(I, 1));
height = yr - yl + 1;
width = xr - xl + 1;
target = I(yl : yr, xl : xr, :);

% assign pixel into color bins and incorporate weight into account
[binR, binG, binB] = colorAssign(target);
k = pixWeight(width, height);
%k = ones(height, width);
wR = binR.*k;
wG = binG.*k;
wB = binB.*k;

for i = 1 : 8
    indR = find(binR == i);
    indG = find(binG == i);
    indB = find(binB == i);
    pR(i) = sum(wR(indR));
    pG(i) = sum(wG(indG));
    pB(i) = sum(wB(indB));
end

% normalize color distribution and get flatten historgram
pR = pR/sum(pR);
pG = pG/sum(pG);
pB = pB/sum(pB);
p = [pR pG pB];

end

function [binR, binG, binB] = colorAssign(target)
% assign each pixel to its corresponding color bin in three channels
% DENOTE H as the height, W as the width of target
%        M as the number of color bins in each channel
% INPUT     - target:       H*W*3
% OUTPUT    - binR:         1*M
%           - binG:         1*M
%           - binB:         1*M

% separate color channels
s = size(target);
tR = target(:, :, 1);
tG = target(:, :, 2);
tB = target(:, :, 3);
tR = reshape(tR, [s(1), s(2)]);
tG = reshape(tG, [s(1), s(2)]);
tB = reshape(tB, [s(1), s(2)]);

% assign colors and count numbers with weights
edges = linspace(0, 255, 9);
[~, ~, binR] = histcounts(tR, edges);
[~, ~, binG] = histcounts(tG, edges);
[~, ~, binB] = histcounts(tB, edges);

end

function k = pixWeight(width, height)
% calculate weights for each pixel in the window
% further pixels away from center will be assigned low weights
% INPUT     - width:        1*1
%           - height:       1*1
% OUTPUT    - k:            height*width

v = zeros(height, width);
vr = reshape(v, 1, height*width);
cr = round(height/2);
cc = round(width/2);

% create distance matrix
for i = 1 : height*width
    %convert linear index to subscript
    [ir, ic] = ind2sub(size(v), i);
    r = sqrt((ir - cr)^2 + (ic - cc)^2);
    vr(i) = r;
end

% get normalized weight matrix
b = sqrt(width^2 + height^2);
v = reshape(vr, height, width);
r = v/b;
k = 1 - r.*r;
k(find(k < 0)) = 0;
% f = sum(sum(1./k));

end