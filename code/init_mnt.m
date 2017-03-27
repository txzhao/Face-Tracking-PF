function [target, phi_t, weights, particles] = init_mnt(ini_state, im, N, range, sigma)
% initialize target (and its moment invariants) and particles
% DENOTE H as the height, W as the width of the input image
%        N as the number of particles, M as the number of features
%        P as the number of moment invariants in each channel
% INPUT     - ini_state:        1*4 ... [xc, yc, width, height]
%           - im:               H*W*3            
%           - N:                1*1
%           - range:            1*3 ... [x_limit, y_limit, scale_limit]
%           - sigma:            1*1
% OUTPUT    - target:           1*M
%           - phi_t:            1*P
%           - weights:          1*N
%           - particles:        N*M

width = ini_state(3);
height = ini_state(4);
center = [ini_state(1) + (width - 1)/2, ini_state(2) + (height - 1)/2];
target = [center(1), center(2), 0, 0, width, height, 0];
[particles, ~] = init_particle([size(im, 2), size(im, 1)], N, range);
phi_p = zeros(N, 21);

for i = 1 : N
    state = center2corner(particles(i, :));
    phi_p(i, :) = momentDistribute(im, state);
end

phi_t = momentDistribute(im, ini_state);
weights = weight_mnt(phi_t, phi_p, sigma);

end
