function SDL_DynamicBC_fls_FC_ROIs(SDL)
% calculating the ROI-to-ROI dynamic FC using FLS method
% Input
% - SDL, a structure contains the below info
% -- atlas, the ROIs for extracting data
% -- site, study site name
% -- mu, mu parameter
% We also need the following info for running DynamicBC_fls_FC.m
% - ROIsig, a matrix (row=time point, column=ROI)
% - pvalue, default = [];
% - save_info, a structure contains the below info
% -- save_dir, the directory for outputs
% -- flag_1n, default = 0;
% -- seed_index, default = [];
% -- flag_nii, default = 0;
% -- nii_mat_name, output filename



%% Calculation
for i = 1:size(SDL.atlas,1) % per atlas
    for j = 1:size(SDL.site,1) % per site
        for k = 1:size(SDL.mu,1) % per mu value
            
            fin = fullfile(SDL.path,'1_PipelineOutput','atlas_connectivity',SDL.site{j,1}); % data path
            fdir = dir(fin); % all folders under the data path
            fot  = fullfile(SDL.path,'DynamicFC','Results','FLS',['mu=',num2str(SDL.mu{k,1})],SDL.atlas{i,1}); % results path
            
            for n = 1:size(fdir,1) % per folder under the dtaa path
                if fdir(n).isdir && ~strcmp(fdir(n).name,'.') && ~strcmp(fdir(n).name,'..') % only searching the data folder
                    tic;
                    fsbj = fdir(n).name; % subject name
                    fn0  = fullfile(fin,fsbj,['brainatlas_timeseries_',SDL.atlas{i,1},'.txt']); % input filename
                    fn   = ['brainatlas_timeseries_',SDL.site{j,1},'_',fsbj]; % output filename
                    
                    % Dynamic FC (FLS)
                    tic
                    try 
                        ROI_sig = importdata(fn0);% input data file
                        mu = SDL.mu{k,1};
                        save_info.save_dir = fot;
                        save_info.flag_ln = 0;
                        save_info.seed_index = [];
                        save_info.flag_nii = 0;
                        save_info.nii_mat_name = fullfile(fot,fn,['TV_',fn,'_FCM.mat']);
                        
                        DynamicBC_fls_FC(ROI_sig,mu,save_info); % dynamic FC (fls)
                        
                        fprintf('\nDynamic FC, method=FLS, mu=%d, site=%s, sbj=%s, ',mu,SDL.site{j,1},fsbj);
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

%%End
end