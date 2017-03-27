function W = stateFusion(alpha, Dclr, Dmnt)
% fuse two implementation to get a weight for both estimations
% DENOTE H as the height, W as the width of input image I
%        M as the number of moment invariants in each channel
% INPUT     - alpha:        1*1
%           - Dclr:         1*1 
%           - Dmnt:         1*1 
% OUTPUT    - W:            1*2 

Wclr = exp(-alpha*Dclr);
Wmnt = exp(-alpha*Dmnt);
W = [Wclr, Wmnt];
W = W/sum(W);

end