function particles = propagate(particles, var, imsize, bounds)
% DENOTE M as the number of features, N as the number of particles
% INPUT     - particles:    N*M
%           - var:          1*M
%           - imsize:       1*2 ... [imWidth, imHeight]
%           - bounds:       1*6 ... [vmax, minWidth, maxWidth, minHeight, maxHeight, maxScale]       
% OUTPUT    - particles:    N*M

N = size(particles, 1);
A = eye(7);
A(1, 3) = 1;
A(2, 4) = 1;

for i = 1 : N
    p = particles(i, :);
    A(5, 5) = 1 + p(7);
    A(6, 6) = 1 + p(7);
    
    % rounding to integers (pixels)
    p = p*A + randn(1, 7).*sqrt(var);
    p(1 : 6) = round(p(1 : 6));
    
    % make sure particles stay within the image
    p(1) = min(max(p(1), 1), imsize(1));
    p(2) = min(max(p(2), 1), imsize(2));
    
    % bounds on velocity
    p(3) = min(max(p(3), -bounds(1)), bounds(1));
    p(4) = min(max(p(4), -bounds(1)), bounds(1));
    
    % bounds on width and height
    p(5) = min(max(p(5), bounds(2)), bounds(3));
    p(6) = min(max(p(6), bounds(4)), bounds(5));
    
    % bounds on scale
    p(7) = min(max(p(7), -bounds(6)), bounds(6));
    
    particles(i, :) = p;
end
    
