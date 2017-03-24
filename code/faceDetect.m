function bbox = faceDetect(im, verbose)
% detect one face from a frame and return its initial state
% DENOTE H as the height, W as the width of input image I
% INPUT     - im:           H*W*3
%           - verbose:      1*1 ... 0: default, 1: plot the frame with detected face       
% OUTPUT    - bbox:         1*4 ... [xl, yl, width, height]

if nargin < 2
    verbose = 0;
end

FDetect = vision.CascadeObjectDetector;
bbox = step(FDetect, im);

if verbose == 1
    figure,
    imshow(im); hold on
    rectangle('Position', bbox(1, :), 'LineWidth', 5, 'LineStyle', '-', ...
        'EdgeColor', 'r');
    title('Initial Face Detection');     
end

end
