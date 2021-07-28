function SDL_vect_ROI(SDL)

fdir = fullfile(SDL.path,'DynamicFC','Results','STW','tw=50,overlap=0.5','Power264');

%% filenames of all mat files in the subfolders
% fprintf('Loading: mat files in: %s\t',fullfile(fdir,'FCM'));tic;
% flist = dir(fullfile(fdir,'FCM','**','*.mat')); % file list of all .mat files in subfolders
% T = struct2table(flist);toc;
% % capture fID
% for i = 1:size(T,1)
%     T.fID{i} = T{i,1}{1}(26:end-8);
% end
% 
% %% vectorize the FCM matrix
% fn = fullfile(fdir,'FCM_variance.mat');
% fprintf('Loading data: %s\t',fn);tic;load(fn);toc;
% M = [];% matrix to contain the vectorized FCM
% for i = 1:size(data,3) % per subject
%     fprintf('Vectorizing: sbj%d/%d\t',i,size(data,3));tic;
%     A = data(:,:,i); % FCM_variance matrix of ith subject
%     m = triu(true(size(A)),1); % upper triagle (because of symatric matrix) without diagonal
%     M(i,:) = A(m); toc;% per row = vectorized (rowwise) upper triagle of FCM matrix per subject
% end
% 
% %% organize & save FCM_variance.csv (sbj x vectorized FCM_variance matrix)
% T = [T.fID,array2table(M)]; % combine fileID & data
% T.Properties.VariableNames(1) = {'fID'};
% fout = fullfile(fdir,'FCM_variance_v.csv');tic; % _v means vectorized FCM matrix
% fprintf('Writing data to: %s\t',fout);toc;
% writetable(T,fout);
% fprintf('Number of imaging files = %d\n',size(T,1));

% %% load & clean demographic & clinical info
% fn = fullfile(SDL.path,'DynamicFC','Scripts','SbjDemoClinScanInfo.xlsx');
% fprintf('Loading: %s\t',fn);tic;
% T0 = readtable(fn,'sheet','All');toc;
% T0 = T0(:,{'fID','ScannerSite','CurrentPTSDDiagnosis','Age','Sex'}); % variables of interest
% T0.Properties.VariableNames(3) = {'Group'}; % change name
% fprintf('Number of subjects based on demographic & clinical info = %d\n',size(T0,1));
% 
% % change contents of Group
% T0(strcmp(T0.Group,'CONTROL') |...
%     strcmp(T0.Group,'Controls') |...
%     strcmp(T0.Group,'Healthy control') |...
%     strcmp(T0.Group,'Subthreshold') |...
%     strcmp(T0.Group,'control') |...
%     strcmp(T0.Group,'Trauma Control') |...
%     strcmp(T0.Group,'trauma-exposed adults without PTSD'),'Group')={'Control'};
% T0(strcmp(T0.Group,'PTSD-DS') | strcmp(T0.Group,'PTSDpDS'),'Group') = {'PTSD'};
% T0(strcmp(T0.Group,''),:) = []; % remove the subjects without clear diagnosis of current PTSD
% fprintf('Number of subjects with clear diagnosis = %d\n',size(T0,1));
% 
% % change contents of Age
% T0 = T0(T0.Age>0,:); % remove those without Age info or Age<=0
% fprintf('Number of subjects with age info = %d\n',size(T0,1));
% 
% % change contents of Sex
% T0(strcmp(T0.Sex,'Female'),'Sex') = {'F'};
% T0(strcmp(T0.Sex,'Male'),'Sex') = {'M'};
% T0(strcmp(T0.Sex,'Ambiguous'),:) = []; % remove those without clear Sex info
% fprintf('Number of subjects with sex info = %d\n',size(T0,1));
% 
% % change contents of ScannerSite
% T0(strcmp(T0.ScannerSite,''),:) = []; % remove those without clear site info
% fprintf('Number of subjects with ScannerSite info = %d\n',size(T0,1));
% 
% 
% %% merge with demographic & clinical info
% fn = fullfile(fdir,'FCM_variance_v.csv');
% fprintf('Loading: %s\t',fn);tic;
% T = readtable(fn); toc;% load vectorized FCM_variance matrix
% T = innerjoin(T0,T,'Keys','fID'); % merge using the key-variable fID
% fprintf('Number of subjects after merge = %d\n',size(T,1));
% 
% save('tmp.mat','T');

% %% outliers -> NaN -> mean of corresponding group per site
% % 
% load('tmp.mat');
% 
% fprintf('Removing Outliers: ...\n');tic;
% 
% %poolobj = parpool('local'); % begin parallel processing, 1083 sec
% 
% InputVariables  = T.Properties.VariableNames(6:size(T,2)); % variables to be calculated, i.e., M1, M2, ...
% T1 = varfun(@SDL_fun_RmvOutliers,T,'GroupingVariables',{'ScannerSite','Group'},'InputVariables',InputVariables);
% 
% %delete(poolobj); % end parallel pool (idletime=30min)
% 
% % [idx,sitename] = findgroups(T(:,{'ScannerSite','Group'})); %idx=numeric index of each scanner site, sitename=name of scanner site & diagnosis
% % n_sbj_scanner  = splitapply(@SDL_fun_RmvOutliers,T.ScannerSite,idx); % number of subjects per scanner site
% % Tsite = table(sitename,n_sbj_scanner) % list the number of subjects per scanner site
% 
% toc;
% 
% save('tmp1.mat','T','T1','T2');

%% replace missing data per row to row-median (i.e. subject-median)
load('tmp1.mat');

T2 = sortrows(T,{'ScannerSite','Group'}); % to match the rows of T1
T3 = [T2(:,1:5),T1(:,4:end)]; % demographic/clinical info (fID,ScannerSite,Group,Age,Sex) + data without outliers
% [x,y] = find(isnan(T3{:,6:end}));% locate the data that are still missing
% size(unique(x)); % 51 subjects still have NaN values after outliers->group-median

T3.Properties.VariableNames(6:end) = T2.Properties.VariableNames(6:end); % data names go back to M1, M2, M3,...

tic;
% InputVariables = T3.Properties.VariableNames(7:10);
% T4 = rowfun(@SDL_fun_fill,T3(:,{'M1','M2'})); % rowfun does not work to
% table with multiple columns
n_sbj = size(T3,1);
InputVariables = T3.Properties.VariableNames(6:end);
poolobj = parpool('local'); % begin parallel processing
% starttime = tic;
parfor i = 1:n_sbj % per subject
    fprintf('Filling NaN in row = %06d/%d\t',i,n_sbj);tic
    d = T3{i,InputVariables}; % data of this subject
    d = SDL_fun_fill(d);
    T3{i,InputVariables} = d;
    toc;
end
% endtime = toc;
delete(poolobj); % end parallel pool (idletime=30min)
fprintf('\nTime consumed: parallel processing = %\n');

save('tmp.mat','T','T3');

% writetable(T3(:,1:5),'sbjinfo.csv'); % subjects' demographic & clinical info
% writetable(T3(:,6:end),'FCM_variance_vo.csv'); % FCM_variance after vectorization and outlier removal (also filling missing data)
writetable(T3(:,6:105),'FCM_variance_vo_sample.csv'); % sample data (for test purpose only), FCM_variance after vectorization and outlier removal (also filling missing data)

fprintf('\n+++++++++++Time to Debug+++++++++++++\n');

%% End
end

%% outliers -> NaN -> group_median
% per column in the Table
function col = SDL_fun_RmvOutliers(col)

fprintf('Removing Outliers: col(1) = [%1.3f]\n',col(1));

% parameters
Q = quantile(col,[0.25,0.5,0.75]); % 25%,50%,and 75% quantiles, NaN automatically removed
IQR = Q(3) - Q(1); % IQR = 75% quantile - 25% quantile;
low  = Q(1) - 1.5*IQR; % lower limit = 25% - 1.5*IQR
up   = Q(3) + 1.5*IQR; % upper limit = 75% + 1.5*IQR
med  = Q(2); % median = 50% quantile

% outliers -> NaN
col(col<low | col>up) = NaN;

% NaN -> group_median
col(find(isnan(col))) = med;

end

%% fill missing data per row by subject-median
function row = SDL_fun_fill(row)

% fprintf('Filling: row(1) = [%1.3f]\n',row(1));

% parameters
[~,y] = find(isnan(row(1,:))); 
med = quantile(row,0.5);

% NaN -> subject_median
row(1,y) = med;
 
end