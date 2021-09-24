#!usr/bin/env python
#pip install neuroHarmonize
import pandas as pd
import numpy as np
import os # to list folders and files within a path
#from neuroHarmonize import harmonizationLearn
from neuroHarmonize.harmonizationNIFTI import createMaskNIFTI # can't be in the same folder with previous versions of neuroHarmonize

# Paths
path_project = '../' # path to the project
path_in = path_project + 'Results/Seed-to-Voxels/STW/L_Amyg/tw=36,overlap=0.5/FC_SW_Variance/' # path to the input data
path_out = path_in # path to the outputs

# Subjects' info
df_doc  = pd.read_csv(path_project + 'Scripts/' + 'SbjDemoClinScanInfo_nonotes.csv', 
    usecols=['StudySite','Current PTSD diagnosis','Age','Sex','fID1'], na_values=['nan',' '])
df_doc = df_doc.rename(columns={'StudySite':'SITE', 'Current PTSD diagnosis':'Diagnosis', 'Sex':'Sex_M', 'fID1':'name'}) # change column names

# Images: Input & Output
fdir_in = os.listdir(path_in) # list the folder names of all subjects
df_img = pd.DataFrame(fdir_in, columns=['name'])
df = df_doc.merge(df_img, how='inner', on='name') # get the subjects that shared by both Sbj & Img info

# Remove bad subjects with bad image QC (Excluded=1)
df_badQC = pd.read_csv(path_project + 'Results/' + 'QC_Sbj_to_Remove.csv',
    usecols=['name','Excluded'], na_values=[0]) # subjects to be removed due to bad img QC
df = df.merge(df_badQC, how='outer', on='name')
df = df[df.Excluded!=1] # remove those with Excluded=1

# Clean covars
## Diagnosis (PTSD=1, Control=0)
df.Diagnosis.replace(to_replace=['PTSD','PTSD ','PTSD  ','PTSD-DS','PTSDpDS'], value=1, inplace=True) # Diagnosis, PTSD
df.Diagnosis.replace(to_replace=['Control','control','Subthreshold','Subthreshold ','Controls','trauma-exposed adults without PTSD','Trauma Control','Healthy control','CONTROL'], value=0, inplace=True) # Diagnosis, Control
df = df[df.Diagnosis.isin([0,1])] # keep subjects with clear labels, i.e. PTSD or Control

## Age
df = df[~df.Age.isnull() & df.Age!=0] # remove sujects wtih age=NaN or age=0

## Sex_M (M=0, F=1)
df.Sex_M.replace(to_replace=['M','Male'], value=0, inplace=True)
df.Sex_M.replace(to_replace=['F','Female','F '], value=1, inplace=True)
df = df[df.Sex_M.isin([0,1])]


# Input & Output image full path
fin  = [] # list of input images is empty at beginning
fout = [] # list of output images is empty at beginning
for fdir in df.name[21:40]:
    fin.append(path_in   + fdir +  '/Z_TV_' + fdir + '_FCM_variance.nii') # input image name
    fout.append(path_out + fdir + '/NZ_TV_' + fdir + '_FCM_variance.nii') # output image name

nifti_list = pd.DataFrame({'PATH':fin, 'PATH_NEW':fout}) # input & output img info from data but not .csv file

#nifti_list = pd.read_csv('brain_images_paths.csv')
print('\nnifti_list.PATH=\n',nifti_list.PATH)


# Making a mask image for training set
nifti_avg, nifti_mask, affine, hdr0 = createMaskNIFTI(nifti_list, threshold=0) # create a mask image called thresholded_mask.nii.gz


# Flattern the images to 2D np.array
from neuroHarmonize.harmonizationNIFTI import flattenNIFTIs
nifti_array = flattenNIFTIs(nifti_list, 'thresholded_mask.nii.gz')

# Model & adjusted data
import neuroHarmonize as nh
covars = df.loc[:,['SITE','Diagnosis','Age','Sex_M']] # covariates of interest & of no interest
print('\ncovars=\n',covars)
my_model, nifti_array_adj = nh.harmonizationLearn(nifti_array, covars.iloc[21:40,:])
#my_model, nifti_array_adj = nh.harmonizationLearn(nifti_array, covars, smooth_terms=['Age']) # condier the nonlinear effect of Age
print('\nnifti_array_adj=\n',nifti_array_adj)
# np.savetxt("Data_harmonized.csv", nifti_array_adj, delimiter=",") # save adjusted data (not in nifti format)
#nh.saveHarmonizationModel(my_model, 'MY_MODEL')

# Adjusted images
from neuroHarmonize.harmonizationNIFTI import applyModelNIFTIs
# my_model = nh.loadHarmonizationModel('MY_MODEL') # load pre-trained model
applyModelNIFTIs(covars, my_model, nifti_list, 'thresholded_mask.nii.gz')