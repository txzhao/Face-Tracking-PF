function d = likelihood_clr(p, q)
% compute the likelihood of p being q
% DENOTE M as the number of color bins
% INPUT     - p:        1*M 
%           - q:        1*M
% OUTPUT    - d:        1*1

p = sqrt(p);
q = sqrt(q);
rho = dot(p, q);
d = sqrt(1 - rho);

end

