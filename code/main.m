clear;

%% initial setup
vid = VideoReader('sample3.mp4');
nFrames = vid.NumberOfFrames;
startFrame = 150;
step = 5;

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
N = 100;
sigma = 0.5;
range = [size(im, 2), size(im, 1), 0.1];
var = [1000, 400, 1000, 1000, 30, 30, 0.1];
imsize = [size(im, 2), size(im, 1)];
bounds = [50, 20, 150, 50, 150, 0.1];
[target, hist_t, weights, particles] = init(ini_state, im, N, range, sigma);
endpoint = 500;
hist_p = zeros(N, 24);
idx = 1;
alpha = 0.1;
p_threshold = 0.01;

%% main algorithm
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
    weights = weightUpdate(hist_t, hist_p, sigma);
    ini_t = cur_t;
end

% v = VideoWriter('newfile.avi','Uncompressed AVI');
% open(v);
% writeVideo(v, F);
% close(v);
% movie2avi(F, 'moviename.avi', 'compression', 'None');
movie(F)
    
    