function [particles, weights] = init_particle(imsize, N, range)
% initialize particles and weights
% DENOTE M as the number of features, N as the number of particles
% INPUT     - imsize:       1*2 ... [imWidth, imHeight]
%           - N:            1*1
%           - range:        1*3 ... [x_limit, y_limit, scale_limit]
% OUTPUT    - particles:    N*M
%           - weights:      1*N

% get image information
im_width = imsize(1);
im_height = imsize(2);
im_center = [round(im_width/2) round(im_height/2)];
x_max = min(range(1), im_width/2);
y_max = min(range(2), im_height/2);

% randomize feature vectors
dx = x_max*(rand(N, 1)*2 - 1);
dy = y_max*(rand(N, 1)*2 - 1);
dsc = range(3)*(rand(N, 1)*2 - 1);
x = im_center(1)*ones(N, 1) + dx;
y = im_center(2)*ones(N, 1) + dy;
Hx = im_width.*(1 + dsc).*ones(N, 1);
Hy = im_height.*(1 + dsc).*ones(N, 1);

% group feature vectors into particle set
% initialize weights with same value
particles = [x, y, dx, dy, Hx, Hy, dsc];
particles(:, 1 : 6) = round(particles(:, 1 : 6));
weights = (1/N)*ones(1, N);

end