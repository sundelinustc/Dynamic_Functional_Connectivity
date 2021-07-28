function SDL_DynamicBC_sliding_window_FC_ROIs(SDL)
% calculating the ROI-to-ROI dynamic FC using sliding time window method
% Input
% - SDL, a structure contains the below info
% -- atlas, the ROIs for extracting data
% -- site, study site name
% -- tw, tw{1}=time window length, tw{2}=overlap
% We also need the following info for running DynamicBC_sliding_window_FC.m
% - data, a matrix (row=time point, column=ROI)
% - window, timw window (unit: sec)
% - overlap, overlap between adjacent windows, e.g. 0.1, 0.2 ...
% - pvalue, default = [];
% - save_info, a structure contains the below info
% -- save_dir, the directory for outputs
% -- slw_alignment, default = 1;
% -- flag_1n, default = 0;
% -- seed_index, default = [];
% -- flag_nii, default = 0;
% -- nii_mat_name, output filename


%% Calculation
for i = 1:size(SDL.atlas,1) % per atlas
    for j = 1:size(SDL.site,1) % per site
        for k = 1:size(SDL.tw,1) % per time window & overlap combination value
            
            fin  = fullfile(SDL.path,'1_PipelineOutput','atlas_connectivity',SDL.site{j,1}); % data path
            fdir = dir(fin); % all folders under the data path
            fot  = fullfile(SDL.path,'DynamicFC','Results','STW',['tw=',num2str(SDL.tw{k,1}),',overlap=',num2str(SDL.tw{k,2})],SDL.atlas{i,1}); % results path
            
            for n = 1:size(fdir,1) % per folder under the dtaa path
                if fdir(n).isdir && ~strcmp(fdir(n).name,'.') && ~strcmp(fdir(n).name,'..') % only searching the data folder
                    tic;
                    fsbj = fdir(n).name; % subject name
                    fn0  = fullfile(fin,fsbj,['brainatlas_timeseries_',SDL.atlas{i,1},'.txt']); % input filename
                    fn   = ['brainatlas_timeseries_',SDL.site{j,1},'_',fsbj]; % output filename
                    
                    % Dynamic FC (FLS)
                    tic
                    try 
                        data = importdata(fn0);% input data file
                        window = SDL.tw{k,1};
                        overlap = SDL.tw{k,2};
                        pvalue = [];
                        save_info.save_dir = fot;
                        save_info.slw_alignment = 1;
                        save_info.flag_1n = 0;
                        save_info.seed_index = [];
                        save_info.flag_nii = 0;
                        save_info.nii_mat_name = fullfile(fot,fn,['TV_',fn,'_FCM.mat']);

                        DynamicBC_sliding_window_FC(data,window,overlap,pvalue,save_info); % dynamic FC (sliding time window)
                        
                        fprintf('\nDynamic FC, method=STW, tw=%d, overlap=%0.1f, site=%s, sbj=%s, ',window,overlap,SDL.site{j,1},fsbj);
                        toc
                    catch
                        fprintf('\nError !!: %s, ',fn0);
                        toc
                    end
                    
                end
            end
        end
    end
end

fprintf('\n\n=============Completed !!!===================');
%% End
end