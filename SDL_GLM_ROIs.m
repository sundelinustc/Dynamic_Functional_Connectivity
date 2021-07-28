function SDL_GLM_ROIs(SDL)
% Linear models for statistical analyses

% path
fdir = fullfile(SDL.path,'DynamicFC','Results','STW','tw=50,overlap=0.5','Power264');

% load sbjinfo & data (no-outliers)
fprintf('Loading: subjects`s info\t');tic;
Tsubj = readtable(fullfile(fdir,'sbjinfo.csv'));toc;
size(Tsubj)
fprintf('Loading: data\ttime consuming...\t');tic;
Tdata = readtable(fullfile(fdir,'FCM_variance_vo.csv'),'HeaderLines',1);toc;

% Tdata = Tdata(:,1:20); % sample data

fprintf('Size of Tdata:\t');size(Tdata)
T = [Tsubj,Tdata]; % table for analyses

Nsubj = size(Tsubj,1); % number of subjects
Nfix  = 3; % number of variables for fixed effects, i.e. Age, Sex, and Group
Ndata = size(Tdata,2); % number of features (connections)
% MP = ones(3,Ndata,Nfix); % matrix of coefficients & p-values, 3(coef,p,p_fdr)xNdataxNfix

poolobj = parpool(24); % begin parallel processing
parfor i = 1:Ndata % per feature (connection)
    fprintf('Calculating: %d/%d feature\t',i,Ndata);tic;
    lme = fitlme(T,['Var',num2str(i),' ~ Age + Sex + Group + (1|ScannerSite)']);
    MP{i} = lme.Coefficients;
    %     MP(1,i,1) = lme.Coefficients{2,2}; MP(2,i,1) = lme.Coefficients{2,6};% Age
%     MP(1,i,2) = lme.Coefficients{3,2}; MP(2,i,2) = lme.Coefficients{3,6};% Sex
%     MP(1,i,3) = lme.Coefficients{4,2}; MP(2,i,3) = lme.Coefficients{4,6};% Group
    toc;
end
delete(poolobj); % end parallel pool (idletime=30min)

save('tmp2.mat','MP');
fprintf('\n+++++++++DEBUG+++++++++++\n');

% % fdr_corrected p-values
% for i = 1:Nfix % correction per effect
%     MP(3,:,i) = mafdr(MP(2,:,i));
% end
% 
% fprintf('Saving: results matrix MP into Results.mat\t');tic
% save(fullfile(fdir,'Results.mat'),'MP');toc;
% 
% % Effects of Age, 3(coef,p,p_fdr) x Nfeatures
% fprintf('Saving: results of Age\t');tic;
% Tmp = array2table(MP(:,:,1)'); 
% Tmp.Properties.VariableNames = {'Coef';'p';'p_fdr'};
% writetable(Tmp,fullfile(fdir,'Results.xlsx'),'sheet','Age');toc
% 
% % Effects of Sex, 3(coef,p,p_fdr) x Nfeatures
% fprintf('Saving: results of Sex\t');tic;
% Tmp = array2table(MP(:,:,2)'); 
% Tmp.Properties.VariableNames = {'Coef';'p';'p_fdr'};
% writetable(Tmp,fullfile(fdir,'Results.xlsx'),'sheet','Sex');toc
% 
% % Effects of Group, 3(coef,p,p_fdr) x Nfeatures
% fprintf('Saving: results of Group\t');tic;
% Tmp = array2table(MP(:,:,3)'); 
% Tmp.Properties.VariableNames = {'Coef';'p';'p_fdr'};
% writetable(Tmp,fullfile(fdir,'Results.xlsx'),'sheet','Group');toc

%% End
end