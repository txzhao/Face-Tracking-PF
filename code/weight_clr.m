function pw = weight_clr(target, particles, sigma)
% DENOTE M as the number of bins, N as the number of particles
% INPUT     - target:       1*M
%           - particles:    N*M
%           - sigma:        1*1
% OUTPUT    - pw:           1*N

N = size(particles, 1);
pw = zeros(1, N);
for i = 1 : N
    d = likelihood_clr(target, particles(i, :));
    pw(i) = normpdf(d, 0, sigma);
end
pw = pw/sum(pw);

end