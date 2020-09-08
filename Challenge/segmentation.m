function mask = segmentation(frame, background_one)
%% foreground segmentation
    % initial setting
    frame = rgb2gray(im2double(frame));
    threshold = 0.12;
    % initial mask: if the absolute difference between frame and background
    % is greater than the threshold, then the pixel is 1
    % (foreground), otherwise 0 (background)
    foreground_gray = abs(frame - background_one) > threshold;
%% digital image Morphological processing
    mask = foreground_gray;
    % remove small connected components
    mask = bwareaopen(mask, 50);
    % if there are fewer than 3000 foreground pixels, set the mask to all
    % zeros (image has no foreground objects)
    if length(find(foreground_gray~=0))<=3000
        mask = zeros(600,800);
    else
        mask = double(mask);
        % Use gaussian filter to blur the edges
        mask = imgaussfilt(mask,2)*10;
        % Removing salt and pepper noise by twice median filtering
        mask = medfilt2(mask,[5 5]);
        % thicken edges to clump together small connected components
        mask = bwmorph(mask,'thicken',1);
        % fill holes
        mask = imfill(mask,'holes');
        mask = medfilt2(mask,[40 40]);
        mask = imfill(mask,'holes');
        mask = medfilt2(mask,[25 25]);
        mask = imfill(mask,'holes');
    end
end
