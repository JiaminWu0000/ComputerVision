% Computer Vision Challenge 2020 G37
% load the variables
load('instance.mat');
% begin time count
tic

% Use First Picture as Background
ir2 = ImageReader(src, L, R, 0, 0);
[leftImages,~,~] = next(ir2);
background_one = rgb2gray(im2double(leftImages));

% if we are saving video output
if store
    % fps of the video
    fps = 30;
    % VideoWriter object at path of output video file (from config.m)
    aviobj = VideoWriter(fullfile(dest));
    % set framerate
    aviobj.FrameRate = fps;
    % open the VideoWriter object so we can write into it
    open(aviobj);
end

% if the background is a video
if vidbg
    % VideoReader object
    v = VideoReader(fullfile(bg));
    % read the frames of the video
    vidFrames = read(v);
    % set the current background frame to index 0
    bgFrame = 0;
end

% loop is 0 initially
loop = 0;
while loop == 0
    % if the background is a video
    if vidbg
        % increment frame counter by 1
        bgFrame = bgFrame + 1;
        % extract the next frame from the background video
        bg = vidFrames(:,:,:,bgFrame);
        % if we've reached the end of the background video, loop back to the beginning
        if bgFrame==v.NumFrames
            bgFrame = 0;
        end
    end
    [left, right, loop] = next(ir);
    % obtain segmentation mask
    mask = segmentation(left, background_one);
    % render the frame with the mask, background and mode
    renderedFrame = render(left,mask,bg,mode);
    % save the output to video file if this is desired
    if store
        writeVideo(aviobj,renderedFrame);
    end
end
% close the output video file
if store
    close(aviobj);
end

% Calculate elapsed time
toc
elasped_time = toc;
