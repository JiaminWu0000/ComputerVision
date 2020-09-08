README

Requires
- Image Processing Toolbox

Quick Start Guide
- Make sure the folder that contains the code is the current open folder in MATLAB, or otherwise add it to the PATH. 
- Open 'config.m' and change 'src', 'L', 'R', 'start', 'dest', 'store' as desired. 
- Virtual background: for a still image, set bg=imread('/path/to/file') and 'vidbg' to 0. 
 - For a video background, set bg='/path/to/video' and the file will be read later in 'challenge.m'. Set 'vidbg' to 1. 
  - The video background is assumed to be 30fps, i.e. each frame will be used for each image from the dataset. If the video background has fewer frames than the dataset, it will loop back to the beginning. 
- When running 'challenge.m', 'N' MUST be set to 0 in 'config.m'

GUI
- Enter 'start_gui' into the console to start the GUI. 
- Change the settings as desired and then press the 'START' button to start the program
- You MUST provide a virtual background with one of the extensions 'jpg','png','avi','mp4' - 'jpg','png' for still images and 'avi','mp4' for a video background
- All settings can be changed online (on-the-fly), but: 
 - if you change 'Save Path': you will lose previously displayed frames and only new frames will be written
 - if you change 'Scene Folder Path' or the cameras, the program will reset to whatever 'Starting Point' is set as
 - if you change only 'Starting Point' after the program has started it will have no effect
 - if the program has already reached the end of the folder once and an output video has already been saved, changing the parameters will trigger a new video to be written over the previous one, unless the program is paused
 - if the program has not yet reached the end of the folder once, then the new frames written to the output video will reflect the new settings, 
  - except if you change 'Scene Folder Path' or the cameras, which will trigger a new output video regardless if the background or rendering mode are still the same

