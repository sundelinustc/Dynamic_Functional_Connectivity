function SDL_DynamicBC_imgs(SDL)

% Prepare 4D images for DynamicBC preprocessing
% The input images should be *Preproc1.nii.gz that has motion parameters from aCompCor regressed out
% need to set path for SPM12 first
% by Delin Sun (Duke University Medical Center, 07/26/2021)
%
% Input
% --- SDL, a structure containing the important paths & parameters
% Output
% --- An 4D image per subject is saved into a subject-specific folder

%% working paths
if exist('/mnt/BIAC/duhsnas-pri.dhe.duke.edu/dusom_morey/Data/Lab', 'dir') % path
    fdir = '/mnt/BIAC/duhsnas-pri.dhe.duke.edu/dusom_morey/Data/Lab';
elseif exist('Z:\Data\Lab', 'dir')
    fdir = 'Z:\Data\Lab';
else
    error('The path is wrong!!!');
end

%% Functions
for j = 1:size(SDL.site,1) % per StudySite
    % path  
    fsite = SDL.site{j}; % site name
    SDL.path_in = fullfile(fdir, 'beta6_outputs', fsite, 'derivatives', 'halfpipe'); % path to the data preprocessed by Courtney
    
    % list all subjects
    fins = dir(SDL.path_in);
    
    for i = 3:size(fins,1) % extract signals per subject, i=1,2 are . and ..
        tic;
        fsbj = fins(i).name; % subject ID   
        
        fstr = dir(fullfile(fins(i).folder, fsbj,'func','*preproc1_bold.nii.gz')); % searching the file with specified extension
        
        fsbj_fname = fstr.name; % filename of the input image
        fin = fullfile(fullfile(fstr.folder, fsbj_fname)); % fullname of the input image
        % e.g. 'Z:\Data\Lab\beta6_outputs\AMC\derivatives\halfpipe\sub-1138\func\sub-1138_task-rest_setting-preproc1_bold
        
        fout = fullfile(SDL.path, 'DynamicFC', 'Origins', [fsite, '_', fsbj]); % output folder
        if ~exist(fout, 'dir'), mkdir(fout); end % make the output folder is it does not exist
 
        fprintf('\n4D Image preparation: SiteName = %s, SbjID = %s\t',fsite, fsbj);
        gunzip(fin, fout); % extract the GNU zip file (.nii.gz) to a new folder as .nii (for DynamicBC usage)
        toc;
        
    end
    
end
% End
end

