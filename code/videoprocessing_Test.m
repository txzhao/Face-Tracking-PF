clear;

%% initial setup
vid = VideoReader('WeChatSight508.mp4');
nFrames = vid.NumberOfFrames;
startFrame = 1;
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

%% start
N = 100;
sigma = 0.5;
range = [200, 200, 0.1];
var = [30, 30, 30, 30, 30, 30, 0.1];
imsize = [size(im, 2), size(im, 1)];
bounds = [50, 20, 150, 50, 200, 0.1];
[target, hist_t, weights, particles] = init(ini_state, im, N, range, sigma);
endpoint = 60;
hist_p = zeros(N, 24);
idx = 1;

while (1)
    [particles, weights] = systematic_resample(particles, weights);
    particles = propagate(particles, var, imsize, bounds);
    cur_t = ini_t + step;
    if cur_t > endpoint
         break;
    end
    cur_im = read(vid, cur_t);
    fig = figure();
    imshow(cur_im);
    hold on;
    
    for k = 1 : N
        BB = particles(k, [1,2,5,6]);
        rectangle('Position', BB, 'EdgeColor', 'r', 'LineWidth', 2);
    end
    
    F(idx) = getframe(fig);
    idx = idx + 1;
    
    for i = 1 : N
        wi = particles(i, 5);
        hi = particles(i, 6);
        xi = particles(i, 1) - (wi - 1)/2;
        yi = particles(i, 2) - (hi - 1)/2;
        state = [xi, yi, wi, hi];
        hist_p(i, :) = colorDistribute(cur_im, state);
    end
    
    weights = weightUpdate(hist_t, hist_p, sigma);
    ini_t = cur_t;
end

% v = VideoWriter('newfile.avi','Uncompressed AVI');
% open(v);
% writeVideo(v, F);
% close(v);
movie(F)

% movie(F)
    
    