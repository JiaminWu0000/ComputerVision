%% Computer Vision Challenge 2020 G37 config.m
%% General Settings
% Group number:
group_number = 37;

% Group members:
members = {'Ryan Leung', 'Hongyu Song','Jiamin Wu','Huiwen Zheng','Yuchong Zheng'};

% Email-Address (from Moodle!):
mail = {'ge69foc@mytum.de', 'ge38xat@mytum.de','ge93xav@mytum.de','ge35mix@mytum.de','ge38nor@mytum.de'};                                                                                                 


%% Setup Image Reader
% Specify Scene Folder
src =  "C:\Users\Ryan\Documents\ss20\CV\P2L_S5";

% Select Cameras
L = 1;  
% or 2
R = 2;  
% or 3

% Choose a start point
start = 0; 

% Choose the number of succeeding frames
N = 0;

ir = ImageReader(src, L, R, start, N);


%% Output Settings
% path to output video file
dest = "output.avi";

% Load Virual Background
% bg should be the image data already if it is still image (imread())
% if it is a video file then just provide the path as a string
bg = zeros(600,800,3);
% video background flag - set to 1 if bg is path to video file
vidbg = 0;

% Select rendering mode
mode = "substitute";
% 'foreground' or 'background' or 'overlay'

% Create a movie array
movie = [];

% Store Output?
store = true;

save('instance.mat', 'N', 'start', 'L', 'R', 'src', 'mode', 'store', 'bg', 'dest', 'ir');
