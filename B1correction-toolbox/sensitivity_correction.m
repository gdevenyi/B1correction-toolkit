%% Sensitivity correction method
% 
% This correction method is well established in the literature as a 
% sensitivity (B1-) correction method. For more information see:
%
% Axel L, Constantini J, Listerud J. Intensity correction in surface-coil 
% MR imaging. American Journal of Roentgenology. 1987;148(2):418-420
%
% Wicks D, Barker G, Tofts P. Correction of intensity nonuniformity in MR 
% images of any orientation. Magnetic Resonance Imaging. 1993;11(2):183-196
%
%
% In our peer-reviewed publication (see below), we demonstrated that this 
% method is also effective for correction of B1+ inhomogeneities. 
%
% If you use or modify this code, please cite:
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ramos Delgado P, Kuehne A, Periquito J, et al. B1 Inhomogeneity 
% Correction of RARE MRI with Transceive SurFA_orderedce Radiofrequency Probes. 
% Magnetic Resonance in Medicine 2020; 00:1-20. 
% https://doi.org/10.1002/mrm.28307
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUT:
%%%% img_unifSens : uniform phantom image 
%%%% img_ori      : image to be corrected
%
% OUTPUT:
%%%% sensCorr : corrected image
%
% IMPORTANT:
% 1. You must register your data (img_unif, img_ori) before running the
% correction.
%
%
% April 2020
% Paula Ramos Delgado
% ramosdelgado.paula@gmail.com
%

%% Set paths

pathOUT = 'O:\Users\pramosdelgado\output_folder\'; % select OUTPUT path to save the resulting images and data


%% Load data

load('O:\Users\pramosdelgado\test_data\cryoprobe_dataAUX\phantom_sensCorrection_cryo.mat'); 
load('O:\Users\pramosdelgado\test_data\cryoprobe_data\exVivoData_cryo.mat');


%% User input

% Which kind of sample are you correcting?

sample = 'phantom'; % uniform phantom or ex vivo
%sample = 'mouse'; % in vivo mouse
%sample = 'flask'; % flask for validation


%% Normalize and calculate inverse of uniform phantom data: CORRECTION FACTOR

img_unif_N = img_unifSens ./ max(max(img_unifSens(:)));
corrFactor = 1 ./ img_unif_N;


%% Compute B1 correction
  
sensCorrected = img_ori .* corrFactor; %correction

% Mask the correction
if strcmp(sample, 'phantom')
    sensCorrected = sensCorrected.*mask_unif; 
elseif strcmp(sample, 'mouse')
    sensCorrected = sensCorrected.*maskinvivo; % select a mask manually
elseif strcmp(sample, 'flask')
    sensCorrected = sensCorrected.*mask_2; 
end

save(fullfile(pathOUT, 'sensCorrection_exVivo_cryo.mat'),'sensCorrected', 'corrFactor');
