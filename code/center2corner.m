function state = center2corner(particle)
% DENOTE M as the number of features
% INPUT     - particle:     1*M
% OUTPUT    - state:        1*4

w = particle(5);
h = particle(6);
x = particle(1) - (w - 1)/2;
y = particle(2) - (h - 1)/2;
state = [x, y, w, h];

end