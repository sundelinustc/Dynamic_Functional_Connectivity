% This script aims at calculating dynamic FC/EC on the preprocessed resting-state fMRI data
% The sccript was made by Dr. Delin Sun (12/03/2020)
% The functions reply on the toolboxes of SPM and DynamicBC


%% Parameters
% paths of projects and scripts
cd ..; cd ..; SDL.path = pwd; % project path = /duhsnas-pri.dhe.duke.edu/dusom_morey/Data/Lab/PGC/resting_state/
cd(fullfile(SDL.path,'DynamicFC','Scripts')); % get into the path of scripts

% add paths of SPM and DynamicBC (if the path has not been set)
if isempty(which('spm')), addpath(fullfile(SDL.path,'DynamicFC','Scripts','spm12')); end
if isempty(which('DynamicBC')), addpath(fullfile(SDL.path,'DynamicFC','Scripts','DynamicBC2.2_20181112')); end

% ROI-to-ROI: atlas to extract ROI signals
SDL.atlas = {
    %     'Schaefer400';
    'Power264';
    };

% Seed-to-Voxels: seeds
SDL.seeds = {
    'L_Amyg_bin';
    'R_Amyg_bin';
    };

% study sites
SDL.site = {
        'AMC'; 'Beijing'; 'Capetown'; 'Columbia'; 'Duke'; 'Emory'; 
        'Ghent'; 'Groningen'; 'Leiden'; 'Masaryk'; 'McLean'; 'Michigan';
        'Milwaukee'; 'Minneapolis_VA'; 'Munster'; 'NanjingYixing'; 'Stanford'; 
        'Toledo'; 'Tours'; 'UMN'; 'Utrecht'; 'UWash';
        'Vanderbilt'; 'Waco_VA'; 'WesternOntario'; 'Wisc_Cisler'; 'Wisc_Grupe';
    };

% fls mu value
SDL.mu = {
    %    0.1; 1; 10; 100; 
1000;
    };

% sliding time window: window length, and overlap
SDL.tw = {
%     60, 0.1;
%     60, 0.2;
%     60, 0.3;
%     60, 0.4
%     60, 0.5;
% 50, 0.1;
% 50, 0.2;
% 50, 0.3;
% 50, 0.4;
50, 0.5;
% 40, 0.1;
% 40, 0.2;
% 40, 0.3;
% 40, 0.4;
% 40, 0.5;
    };

%% Subjects' info
%T0 = SDL_sbj_info(SDL); % a mannually made excel file has subjects' info
%merged across site-specific files


%% Seed-to-Voxels
%% Dynamic FC/EC preprocessing functions
% SDL_DynamicBC_imgs(SDL); % prepare 4D images for DynamicBC preprocessing
SDL_DynamicBC_Seed2Voxel(SDL); % run analyses


%% ROI-to-ROI
%% Dynamic FC/EC preprocessing functions
% SDL_DynamicBC_fls_FC_ROIs(SDL); % FC, FLS method, ROI-to-ROI data
% SDL_DynamicBC_sliding_window_FC_ROIs(SDL); % FC, sliding time window method, ROI-to-ROI data
% SDL_DynamicBC_Variances_ROIs(SDL); % variances stored in one .mat per parameter combination

%% Harmonization
% SDL_vect_ROI(SDL);% vectorize the FCM matrix, remove outliers, & fill in missing values

%% Statistical Analyses
% SDL_GLM_ROIs(SDL); % linear models