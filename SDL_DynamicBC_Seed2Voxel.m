function SDL_DynamicBC_Seed2Voxel(SDL)

% load parameters saved, and then run SDL_DynamicBC_run.m

S = [];

S.DataProcessDir = 'C:\Users\sunde\Documents\Projects\Dynamic_rsFC\Origins1';
S.save_dir = 'C:\Users\sunde\Documents\Projects\Dynamic_rsFC\Output\Seed-to-Voxels\STW\L_Amyg\tw=50,overlap=0.6';
S.F = load(fullfile(S.save_dir,'parameters.mat')); % load F structure
S.mask_label_template = 'C:\Users\sunde\Documents\MATLAB\SDLToolBox\spm12\tpm\mask_ICV.nii';
S.seed_ROI_mask = 'C:\Users\sunde\Documents\Projects\Dynamic_rsFC\Scripts\ROIs\L_Amyg_bin_resliced.nii,1';
SDL_DynamicBC_run(S);


%% End
end