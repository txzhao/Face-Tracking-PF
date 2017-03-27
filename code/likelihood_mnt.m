function d = likelihood_mnt(p, q)
% compute the likelihood of p being q for moment-based implementation
% DENOTE M as the number of moment invariants
% INPUT     - p:        1*M 
%           - q:        1*M
% OUTPUT    - d:        1*1

r = abs((p - q)./(p + q));
d = 1/21*sum(r);

end