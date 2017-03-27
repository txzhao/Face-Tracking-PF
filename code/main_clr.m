clear;
addpath('/Users/MMGF2/Desktop/AEpro/videos');

%% initial setup
vid = VideoReader('sample4.mp4');
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
endpoint = 600;
idx = 1;
N = 100;
imsize = [size(im, 2), size(im, 1)];
hist_p = zeros(N, 24);
alpha = 0.1;
p_threshold = 0.01;
sigma = 0.5;
range = [imsize, 0.1];
var = [1500, 1000, 2500, 2500, 30, 30, 0.1];
bounds = [50, 20, 150, 50, 150, 0.1];

%% main algorithm
% initialize target and particles
[target, hist_t, weights, particles] = init_clr(ini_state, im, N, range, sigma);

while (1)
    % resample particles
    [particles, weights] = systematic_resample(particles, weights);
    
    % propagate each particles based on dynamic model
    particles = propagate(particles, var, imsize, bounds);
    
    % read out current frame from video object
    cur_t = ini_t + step;
    if cur_t > endpoint
         break;
    end
    cur_im = read(vid, cur_t);
    
    % show frames
    fig = figure();
    imshow(cur_im);
    hold on;
    
    % add bounding boxes of particles
    for k = 1 : N
        BB = center2corner(particles(k, :));
        rectangle('Position', BB, 'EdgeColor', 'r', 'LineWidth', 2);
    end
    
    % threshold particles with low weights
    weights(find(weights < p_threshold)) = 0;
    weights = weights/sum(weights);
    
    % estimate the mean state of all particles and add bounding box
    estimate = weights * particles;
    state_e = center2corner(estimate);
    rectangle('Position', state_e, 'EdgeColor', 'b', 'LineWidth', 2.5);
    
    % update target histogram with complementary filter
    hist_e = colorDistribute(cur_im, state_e);
    hist_t = (1 - alpha)*hist_t + alpha*hist_e;  
    
    % save this frame with bounding box
    F(idx) = getframe(fig);
    idx = idx + 1;
    
    % calculate color histogram for each particle
    for i = 1 : N
        state = center2corner(particles(i, :));
        hist_p(i, :) = colorDistribute(cur_im, state);
    end
    
    % update weights based on Bhattacharyya distance
    weights = weight_clr(hist_t, hist_p, sigma);
    ini_t = cur_t;
end

% export video into local file
% v = VideoWriter('newfile1.avi');
% v.FrameRate = 1.5/step*vid.FrameRate;
% open(v);
% writeVideo(v, F);
% close(v);

    
    
