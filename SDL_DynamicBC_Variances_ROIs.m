function SDL_DynamicBC_Variances_ROIs(SDL)
% organizing the variances of the ROI-to-ROI dynamic FC (both FLS and method
% Input
% - SDL, a structure contains the below info
% -- atlas, the ROIs for extracting data
% -- site, study site name

ddir = {
%     'FLS';
    'STW'
    };

% % organize & save FCM_variance.mat (containing ROI x ROI x sbj matrix)
% for i1 = 1:size(ddir,1) % per analyses approach
%     fin1 = fullfile(SDL.path,'DynamicFC','Results',ddir{i1,1}); % data path, e.g. ..\Lab\PGC\resting_state\DynamicFC\Results\FLS
%     fdir1 = dir(fin1); % different parameter combinations
%     
%     for i2 = 1:size(fdir1,1) % per parameter combination
%         if fdir1(i2).isdir && ~strcmp(fdir1(i2).name,'.') && ~strcmp(fdir1(i2).name,'..') % only searching the data folder
%             fin2 = fullfile(SDL.path,'DynamicFC','Results',ddir{i1,1},fdir1(i2).name); % data path, e.g. ..\Lab\PGC\resting_state\DynamicFC\Results\FLS\mu=10
%             fdir2 = dir(fin2); % different atlas
%             
%             for i3 = 1:size(fdir2,1) % per atlas
%                 if fdir2(i3).isdir && ~strcmp(fdir2(i3).name,'.') && ~strcmp(fdir2(i3).name,'..') % only searching the data folder
%                     fin3 = fullfile(SDL.path,'DynamicFC','Results',ddir{i1,1},fdir1(i2).name,fdir2(i3).name,'FCM'); % data path, e.g. ..\Lab\PGC\resting_state\DynamicFC\Results\FLS\mu=10\Power264\FCM
%                     fdir3 = dir(fin3); % different subjects
%                     
%                     k = 0; % initialize subject index
%                     data = [];% initialize data
%                     fot  = fullfile(SDL.path,'DynamicFC','Results',ddir{i1,1},fdir1(i2).name,fdir2(i3).name,'FCM_variance.mat'); % variance data of all subjects
%                     
%                     for i = 1:size(fdir3,1) % per subject
%                         if fdir3(i).isdir && ~strcmp(fdir3(i).name,'.') && ~strcmp(fdir3(i).name,'..') % only searching the data folder
%                             tic
%                             fin = fullfile(SDL.path,'DynamicFC','Results',ddir{i1,1},fdir1(i2).name,fdir2(i3).name,'FCM',fdir3(i).name); % data path, e.g. ..\Lab\PGC\resting_state\DynamicFC\Results\FLS\mu=10\Power264\FCM\brainatlas_timeseries_AMC_1132
%                             clear FCM;
%                             load(fullfile(fin,['TV_',fdir3(i).name,'_FCM.mat']));
%                             k = k + 1;
%                             try
%                                 data(:,:,k) = FCM.variance;
%                                 fprintf('\nLoaded: Method=%s, Parameters:%s, atlas=%s, sbj=%s, ',ddir{i1,1},fdir1(i2).name,fdir2(i3).name,fdir3(i).name);
%                                 toc
%                             catch
%                                 fprintf('\nError !! May be wrong file: Method=%s, Parameters:%s, atlas=%s, sbj=%s, ',ddir{i1,1},fdir1(i2).name,fdir2(i3).name,fdir3(i).name);   
%                                 % !! Duke 5818 has only 260x260 but not 264x264 matrix
%                             end
%                         end
%                     end
%                     
%                     save(fot,'data','-v7.3');
%                     fprintf('\n\n\n---Saved: %s ---\n\n\n',fot);
%                     
%                 end
%             end
%             
%         end
%     end
%     
% end


fprintf('\n\n=============Completed !!!===================');

%% End
end