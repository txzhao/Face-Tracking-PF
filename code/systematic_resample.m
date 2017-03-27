function [p, w] = systematic_resample(particles, weights)
% DENOTE M as the number of features, N as the number of particles
% INPUT     - particles:    N*M
%           - weights:      1*N
% OUTPUT    - p:            N*M
%           - w:            1*N

cdf = cumsum(weights);
N = size(particles, 1);
p = zeros(size(particles));
r_0 = rand / N;

for n = 1 : N
    i = find(cdf >= r_0, 1, 'first');
    p(n, :) = particles(i, :);
    r_0 = r_0 + 1/N;
end

w = 1/N*ones(size(weights));
