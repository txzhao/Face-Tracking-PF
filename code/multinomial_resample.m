function [p, w] = multinomial_resample(particles, weights)
% DENOTE M as the number of features, N as the number of particles
% INPUT     - particles:    N*M
%           - weights:      1*N
% OUTPUT    - p:            N*M
%           - w:            1*N

cdf = cumsum(weights);
N = size(particles, 1);
p = zeros(size(particles));

for n = 1 : N
    r_n = rand;
    i = find(cdf >= r_n, 1, 'first');
    p(n, :) = particles(i, :);
end

w = 1/N*ones(size(weights));

end

