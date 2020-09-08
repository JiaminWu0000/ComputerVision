function result = render(frame, mask, bg, render_mode)

    frame = double(frame);
    bg = double(bg);
    switch render_mode
        case 'foreground'
            % mask is 0 for background pixels
            result = mask.*frame;
        case 'background'
            % invert mask to get 1 for background pixels
            result = ~mask.*frame;
        case 'overlay'
            % different color and diaphaneity for background and foreground
            % extract the red and green channels
            result_R = frame(:,:,1);
            result_G = frame(:,:,2);
            % 0.8 times red channel for foreground
            result_R(find(mask)) = 0.8.*result_R(find(mask));
            % 0.5 times green channel fore background
            result_G(find(~mask)) = 0.5.*result_G(find(~mask));
            % copy the input frame into result
            result = frame;
            % replace with modified red and green channels
            result(:,:,1) = result_R;
            result(:,:,2) = result_G;
        case 'substitute'
            % set background pixels of the input frame to 0
            frame_re = mask.*frame;
            % set foreground pixels of the virtual background to 0
            % also resize virtual background bg to 800x600
            bg_re = ~mask.*imresize(bg,[600 800]);
            result = frame_re + bg_re;
    end
    result = uint8(result);
end
