#!usr/bin/env python

# Import packages
from nilearn import plotting # to plot .nii or .nii.gz files
import os # to list folders and files within a path

# Paths
#path_project = 'Z:\\Data\\Lab\\PGC\\resting_state\\DynamicFC\\' # path to the project
path_project = '../' # path to the project
path_in = path_project + 'Results/Seed-to-Voxels/STW/L_Amyg/tw=36,overlap=0.5/FC_SW_Variance/' # path to the input data
fdir_in = os.listdir(path_in) # list the folder names of all subjects
path_out = path_project + '/Results/QC/' # path to the outputs

# Save .png file per subject
i = 0 # index of the current .png generated
N = len(fdir_in) # number of the total images
for fdir in fdir_in:
    fin  = path_in  + fdir + '/' + 'Z_TV_' + fdir + '_FCM_variance.nii' # input image name
    fout = path_out + fdir + '.png' # output image name
    plotting.plot_img(fin, title=fdir, output_file=fout, cut_coords=(0,0,0), draw_cross=False) # nilearn function to plot images
    i += 1 # index+1 every time a png file is generated successfully
    print(f'\nCompleted: img={i}/{N}, file={fout}\n') # output info