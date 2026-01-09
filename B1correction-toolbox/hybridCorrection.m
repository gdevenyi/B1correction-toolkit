%% Hybrid correction method
% 
% This correction method uses a signal intensity model of the RARE MR
% imaging sequence to compute the correction factors necessary to correct
% for B1+ and B1- inhomogeneities
%
% An RF coil characterization (FA map) performed on a uniform phantom, as
% well as a T1 map of the sample to be corrected are needed
%
% The difference with the model-based correction is that, in this case, the
% B1- map is not calculated from measurements, but from a B1+ corrected
% uniform phantom 
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
%%%% img_ori    : image to be corrected
%%%% T1map      : T1 map of image to be corrected
%%%% polyModel7 : contains the RARE signal intensity model (7th order)
%%%% FAmap      : FA map (Tx)
%%%% B1_rx      : B1- map (Rx)
%%%% mask       : contains mask of pixels to be corrected
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


%% Set and add paths

pathOUT = 'O:\Users\pramosdelgado\output_folder\'; % select OUTPUT path to save the resulting images and data

addpath(genpath('O:\Users\pramosdelgado\RAREmodel_fitting-toolbox'));
addpath(genpath('O:\Users\pramosdelgado\B1correction-toolbox'));


%% Load data

% Sample data 
load('O:\Users\pramosdelgado\test_data\cryoprobe_data\exVivoData_cryo.mat', 'img_ori', 'mask_2', 'T1map');
% RF coil characterization data 
load('O:\Users\pramosdelgado\test_data\cryoprobe_data\b1maps_cryo.mat', 'FAmap');
load('O:\Users\pramosdelgado\test_data\cryoprobe_dataAUX\B1_rx_hybrid_cryo.mat', 'B1_rx_hybridN');
% RARE signal intensity model data
load('O:\Users\pramosdelgado\results_folder\RAREmodels\RAREmodel_flipback_allOrders.mat', 'polyModel7');


%% Calculate model-based correction

plotFlag = 0;

[corrFact_1, corrFact_2,corr_field, B1_tx_corrected,maskGoodness] = calculateB1Pluscorrection(img_ori,T1map,polyModel7,FAmap,mask_2,plotFlag);


%% B1- correction

hybCorrected = B1_tx_corrected .* corrFactor_hyb;

save(fullfile(pathOUT,'hybridCorrection_exVivo_cryo.mat'),'B1_tx_corrected','hybCorrected','maskGoodness','corrFact_1','corrFact_2','corr_field');
