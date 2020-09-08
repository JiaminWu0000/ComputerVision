classdef ImageReader < handle
    % Add class description here
    %
    %
    properties
      % Don't bother with validating src, too hard and not exactly in the project specs
      src
      % L can be 1 or 2, has to be numeric
      L {mustBeNumeric, mustBeGreaterThanOrEqual(L,1), mustBeLessThanOrEqual(L,2)};
      % R can be 2 or 3, has to be numeric
      R {mustBeNumeric, mustBeGreaterThanOrEqual(R,2), mustBeLessThanOrEqual(R,3)};
      % start must be numeric, greater than or equal to 0
      start {mustBeNumeric, mustBeGreaterThanOrEqual(start,0)};
      % N must be numeric, greater than or equal to 0
      N {mustBeNumeric, mustBeGreaterThanOrEqual(N,0)};
      % properties that can be processed at instantiation instead of in the next() method every time
      % the name of the folder for the left camera
      folderNameL;
      % the name of the folder for the right camera
      folderNameR;
      % list of the names of all the images
      imageNames;
      % the total number of images
      maxImages;
    end
    methods
        function obj = ImageReader(src, L, R, varargin)
            % set a parser
            p = inputParser;
            % defaults of optional parameters
            default_start = 0;
            default_N = 1;
            % conditions will be checked in properties, so just use true
            valid_true = @(x) true;
            % required params
            addRequired(p, 'src');
            addRequired(p, 'L');
            addRequired(p, 'R');
            % the optional parameters
            addOptional(p, 'start', default_start, valid_true);
            addOptional(p, 'N', default_N, valid_true);
            % now parse
            parse(p, src, L, R, varargin{:});
            % assign the parsed arguments
            % use fullfile() to remove duplicate separators (but this will
            % not trim trailing separators)
            obj.src = fullfile(p.Results.src);
            obj.L = p.Results.L;
            obj.R = p.Results.R;
            obj.start = p.Results.start;
            obj.N = p.Results.N;
            
            % create the static parts of the path to each picture file. we can also determine
            % if start is out of bounds (i.e. greater than the number of images)
            % use fileparts to determine existence of trailing file seperator
            [~,tmpPS,~] = fileparts(obj.src);
            % if there is a trailing seperator, MATLAB will treat this as a
            % folder path and will not return a 'file' name
            if strcmp(tmpPS,'')
                % length of src string
                srcLength = strlength(obj.src);
                % extract last 6 characters (offset by 1 - the trailing separator) of src to get portal and scene e.g. P1E_S1
                PS = extractBetween(obj.src, srcLength-6, srcLength-1);
            % if there is no trailing separator, MATLAB will return the
            % folder name as if it were a 'file' name
            else
                PS = tmpPS;
            end
            % %s => string: given by PS e.g. P1E_S1
            % _C => indicates camera, e.g. P1E_S1_C*
            % %d => signed integer: the camera number as given by L or R
            folderNameSpec = "%s_C%d";
            % folder name for left camera
            obj.folderNameL = sprintf(folderNameSpec, PS, obj.L);
            % folder name for right camera
            obj.folderNameR = sprintf(folderNameSpec, PS, obj.R);
            % use dir() with wildcard to get all the .jpg files in folder
            % and then convert the struct to cell array
            listFiles = struct2cell(dir(fullfile(obj.src, obj.folderNameL,'*.jpg')));
            % we only need the first row of the cell array for the image names
            obj.imageNames = listFiles(1,:);
            % number of images is simply length of imageNames (minus 1 for 0-index)
            obj.maxImages = length(obj.imageNames) - 1;
            % if start is set beyond the last image, throw error
            if obj.start > obj.maxImages
                error('start cannot be greater than the number of images (0-index)');
            end
            % L cannot be the same as R
            if obj.L == obj.R
                error('L cannot be the same as R');
            end
        end
        function [left, right, loop] = next(obj)
            % inital image number
            imageNumber = obj.start;
            % number of images to display after start
            numImagesAfterStart = obj.N;
            
            % if there are not enough remaining images to display N images after start
            if obj.start+obj.N >= obj.maxImages
                % only display images after start up to the last remaining image
                numImagesAfterStart = obj.maxImages - obj.start;
                % set loop to 1
                loop = 1;
                % set next start to 0
                obj.start = 0;
            else
                % set next start to the next starting image after current start + N
                obj.start = obj.start + obj.N + 1;
                % set loop to 0
                loop = 0;
            end

            % initialise/preallocate left and right tensors
            % it's reasonable to hardcode 600x800, given this is for specific data
            left = zeros(600,800,(numImagesAfterStart+1)*3);
            right = zeros(600,800,(numImagesAfterStart+1)*3);
            for i=1:numImagesAfterStart+1
                % dynamic parts of the file path
                % construct file path for left camera
                pathL = fullfile(obj.src, obj.folderNameL, obj.imageNames{imageNumber+i});
                % construct file path for right camera
                pathR = fullfile(obj.src, obj.folderNameR, obj.imageNames{imageNumber+i});

                % add left camera picture to left tensor
                left(:,:,(i-1)*3+1:i*3) = imread(pathL);
                % add right camera picture to right tensor
                right(:,:,(i-1)*3+1:i*3) = imread(pathR);
            end
            % convert to uint8
            left = uint8(left);
            right = uint8(right);
        end
    end
end

