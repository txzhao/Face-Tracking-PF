clear;
addpath('/Users/MMGF2/Desktop/AEpro/videos');

%% initial setup
vid = VideoReader('sample1.mp4');
nFrames = vid.NumberOfFrames;
startFrame = 1;
step = 4;

%% acquire initial face state
for i = startFrame : step : nFrames
    im = read(vid, i);
    try
        ini_state = faceDetect(im, 0); % 1: plot the image
    end
    % if succeed in detecting faces
    if exist('ini_state') == 1 && isequal(size(ini_state), [1 4]) == 1
        ini_state = faceDetect(im, 0); 
        ini_t = i;
        break;
    end
end

%% initialize parameters
endpoint = 500;
idx = 1;
N = 50;
imsize = [size(im, 2), size(im, 1)];
hist_p = zeros(N, 24);
phi_p = zeros(N, 21);
alpha = 0.1;
threshold_c = 1/N;
threshold_m = 0.02;
sigma_c = 0.5;
sigma_m = 0.3;
range_c = [imsize, 0.1];
range_m = [imsize/4, 0.1];
var_c = [1500, 1000, 2500, 2500, 30, 30, 0.1];
var_m = [900, 500, 500, 500, 30, 30, 0.1];
bounds_c = [50, 20, 150, 50, 150, 0.1];
bounds_m = [25, 20, 150, 50, 150, 0.1];
att = 0.5;

%% main algorithm
% initialize target and particles in two implementations
[target, hist_t, w_clr, p_clr] = init_clr(ini_state, im, N, range_c, sigma_c);
[~, phi_t, w_mnt, p_mnt] = init_mnt(ini_state, im, N, range_m, sigma_m);

err = [];
err_c = [];
err_m = [];

while (1)
    % resample particles
    [p_clr, w_clr] = systematic_resample(p_clr, w_clr);
    [p_mnt, w_mnt] = systematic_resample(p_mnt, w_mnt);
%     [p_clr, w_clr] = multinomial_resample(p_clr, w_clr);
%     [p_mnt, w_mnt] = multinomial_resample(p_mnt, w_mnt);
        
    % propagate each particles based on dynamic model
    p_clr = propagate(p_clr, var_c, imsize, bounds_c);
    p_mnt = propagate(p_mnt, var_m, imsize, bounds_m);
    
    % read out current frame from video object
    cur_t = ini_t + step;
    if cur_t > endpoint
         break;
    end
    cur_im = read(vid, cur_t);
    t_state = faceDetect(cur_im, 0);
    t_state = corner2center(t_state);
    
    % show frames
    fig = figure();
    imshow(cur_im);
    hold on;
    
    % add bounding boxes of particles
%     for k = 1 : N
%         BB_clr = center2corner(p_clr(k, :));
%         BB_mnt = center2corner(p_mnt(k, :));
%         rectangle('Position', BB_clr, 'EdgeColor', 'r', 'LineWidth', 2);
%         rectangle('Position', BB_mnt, 'EdgeColor', 'g', 'LineWidth', 2);
%     end
    
    % threshold particles with low weights
    w_clr(find(w_clr < threshold_c)) = 0;
    w_clr = w_clr/sum(w_clr);
    w_mnt(find(w_mnt < threshold_m)) = 0;
    w_mnt = w_mnt/sum(w_mnt);
    
    % estimate the mean state of all particles and add bounding box
    est_clr = w_clr * p_clr;
    state_clr = center2corner(est_clr);
    rectangle('Position', state_clr, 'EdgeColor', 'b', 'LineWidth', 2.5);
    
    est_mnt = w_mnt * p_mnt;
    state_mnt = center2corner(est_mnt);
    rectangle('Position', state_mnt, 'EdgeColor', 'k', 'LineWidth', 2.5);
    
    % update target histogram with complementary filter
    hist_e = colorDistribute(cur_im, state_clr);
    hist_t = (1 - alpha)*hist_t + alpha*hist_e; 
    
    phi_e = momentDistribute(cur_im, state_mnt);
%     phi_t = (1 - alpha)*phi_t + alpha*phi_e; 
    
    % fuse two implementations together and draw bounding box
    Dclr = likelihood_clr(hist_t, hist_e);
    Dmnt = likelihood_mnt(phi_t, phi_e);
    W = stateFusion(att, Dclr, Dmnt);
    
    est_f = W*[est_clr; est_mnt];
    state_f = center2corner(est_f);
    rectangle('Position', state_f, 'EdgeColor', 'm', 'LineWidth', 2.5);
    
    % compute errors of different PFs
    err = [err, sqrt((est_f(1) - t_state(1))^2 + (est_f(2) - t_state(2))^2)];
    err_c = [err_c, sqrt((est_clr(1) - t_state(1))^2 + (est_clr(2) - t_state(2))^2)];
    err_m = [err_m, sqrt((est_mnt(1) - t_state(1))^2 + (est_mnt(2) - t_state(2))^2)];
    
    % save this frame with bounding box
    F(idx) = getframe(fig);
    idx = idx + 1;
    
    % calculate color histogram for each particle
    for i = 1 : N
        state = center2corner(p_clr(i, :));
        hist_p(i, :) = colorDistribute(cur_im, state);
        phi_state = center2corner(p_mnt(i, :));
        phi_p(i, :) = momentDistribute(cur_im, phi_state);
    end
    
    % update weights based on Bhattacharyya distance
    w_clr = weight_clr(hist_t, hist_p, sigma_c);
    w_mnt = weight_mnt(phi_t, phi_p, sigma_m);
    
    ini_t = cur_t;
end

% plot the error performances of PFs
figure()
plot(1 : step : step*(size(err, 2) - 1) + 1, err, 'k-o');
hold on
plot(1 : step : step*(size(err_c, 2) - 1) + 1, err_c, 'b-o');
plot(1 : step : step*(size(err_m, 2) - 1) + 1, err_m, 'r-o');


% export video into local file
v = VideoWriter('newfile1.avi');
v.FrameRate = 1.5/step*vid.FrameRate;
open(v);
writeVideo(v, F);
close(v);

   
