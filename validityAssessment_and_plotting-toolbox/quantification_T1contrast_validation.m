%% T1-contrast and quantification performance - Error calculation
% 
% This code computes errors on T1-contrast and quantification after 
% correction, using the formula:
%
%                | meanSI_reference - meanSI_corrected |
% ratio error = ------------------------------------------ * 100 (%)
%                            meanSI_reference
%
% For more information, please check the peer-reviewed publication below:
%
% Ramos Delgado P, Kuehne A, Periquito J, et al. B1 Inhomogeneity 
% Correction of RARE MRI with Transceive SurFA_orderedce Radiofrequency Probes. 
% Magnetic Resonance in Medicine 2020; 00:1-20. 
% https://doi.org/10.1002/mrm.28307
%
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
%
% INPUT:
%%%% img_vol_n#          : volume RF coil image
%%%% img_ori_n#          : original cryoprobe or Tx/Rx surface RF coil image
%%%% sensCorrected_n#    : B1-corrected (sensitivity) image
%%%% MBCorrected_n#      : B1-corrected (model-based) image
%%%% hybCorrected_n#     : B1-corrected (hybrid) image
%
% Nomenclature used:
% n1 : uniform phantom, 100% water, low T1
% n2 : uniform phantom, 50% water/50% d2O, low T1
% n3 : uniform phantom, 100% water, high T1
% n4 : uniform phantom, 50% water/50% d2O, high T1
%
% OUTPUT:
%%%% Q_lowT1    : ratio for quantification at low T1 (n1n2)
%%%% Q_highT1   : ratio for quantification at low T1 (n3n4)
%%%% T1c_water  : ratio for quantification at low T1 (n1n3)
%%%% T1c_half   : ratio for quantification at low T1 (n2n4)
%
% 
%
% April 2020
% Paula Ramos Delgado
% ramosdelgado.paula@gmail.com
%


%% Load data

load('O:\Users\pramosdelgado\results_folder\B1correction\rtSUC\validationPhantoms_data_flipback.mat');


%% User-defined parameters

pathOUT = 'O:\Users\pramosdelgado\output_folder';

% Select ROI positions
pos1 = [59.7654720198284 51.0017642518875 4 4];
pos2 = [75.8746498280826 32.3286616487316 4 4];
pos3 = [44.4305570902095 36.9066716453902 4 4];
pos4 = [65.5289128800435 41.5564716310223 4 4];
pos5 = [85.4230369248567 41.8191113303876 4 4];


%% ROI placement and mask computation

% ROI placement
figure(), imagesc(MBCorrected_n1, [0 7500]), colormap(jet(256)),shg;set(gca,'XTick',[]); set(gca,'YTick',[]);
h1 = imrect(gca,pos1); 
h2 = imrect(gca,pos2); 
h3 = imrect(gca,pos3); 
h4 = imrect(gca,pos4); 
h5 = imrect(gca,pos5); 

% Compute masks
roi1 = h1.createMask;
roi2 = h2.createMask;
roi3 = h3.createMask;
roi4 = h4.createMask;
roi5 = h5.createMask;

clear h1 h2 h3 h4 h5
clear pos1 pos2 pos3 pos4 pos5
close;

all_roiMasks = cat(3,roi1,roi2,roi3,roi4,roi5);
all_roiMasks = repmat(all_roiMasks,[1 1 1 4]);
clear roi1 roi2 roi3 roi4 roi5


%% Order data

% Data matrices: 128x128x5(rois)x4(flasks)
ori = cat(4, repmat(img_ori_n1,[1 1 5]), repmat(img_ori_n2,[1 1 5]), repmat(img_ori_n3,[1 1 5]), repmat(img_ori_n4,[1 1 5]));
vol = cat(4, repmat(img_vol_n1,[1 1 5]), repmat(img_vol_n2,[1 1 5]), repmat(img_vol_n3,[1 1 5]), repmat(img_vol_n4,[1 1 5]));
MBcorr = cat(4, repmat(MBCorrected_n1,[1 1 5]), repmat(MBCorrected_n2,[1 1 5]), repmat(MBCorrected_n3,[1 1 5]), repmat(MBCorrected_n4,[1 1 5]));
sens = cat(4, repmat(sensCorrected_n1,[1 1 5]), repmat(sensCorrected_n2,[1 1 5]), repmat(sensCorrected_n3,[1 1 5]), repmat(sensCorrected_n4,[1 1 5]));
hybrid = cat(4, repmat(hybCorrected_n1,[1 1 5]), repmat(hybCorrected_n2,[1 1 5]), repmat(hybCorrected_n3,[1 1 5]), repmat(hybCorrected_n4,[1 1 5]));

clear MBCorrected_n1 MBCorrected_n2 MBCorrected_n3 MBCorrected_n4
clear img_ori_n1 img_ori_n2 img_ori_n3 img_ori_n4
clear img_vol_n1 img_vol_n2 img_vol_n3 img_vol_n4
clear sensCorrected_n1 sensCorrected_n2 sensCorrected_n3 sensCorrected_n4
clear hybCorrected_n1 hybCorrected_n2 hybCorrected_n3 hybCorrected_n4


%% Get ROI data and calculate mean SI within

ori_roiData = ori .* all_roiMasks;
ori_roiData(ori_roiData==0) = NaN; 
ori_roiData = squeeze(nanmean(nanmean(ori_roiData)));

vol_roiData = vol .* all_roiMasks;
vol_roiData(vol_roiData==0) = NaN; 
vol_roiData = squeeze(nanmean(nanmean(vol_roiData)));

MBcorr_roiData = MBcorr .* all_roiMasks;
MBcorr_roiData(MBcorr_roiData==0) = NaN; 
MBcorr_roiData = squeeze(nanmean(nanmean(MBcorr_roiData)));

sens_roiData = sens .* all_roiMasks;
sens_roiData(sens_roiData==0) = NaN; 
sens_roiData = squeeze(nanmean(nanmean(sens_roiData)));

hybrid_roiData = hybrid .* all_roiMasks;
hybrid_roiData(hybrid_roiData==0) = NaN; 
hybrid_roiData = squeeze(nanmean(nanmean(hybrid_roiData)));

clear ori vol MBcorr hybrid sens all_roiMasks


%% ROI ratio quantification ratios (n1n2, n3n4)

ori_n1n2_ratios = zeros(5,5);
vol_n1n2_ratios = zeros(5,5);
MBcorr_n1n2_ratios = zeros(5,5);
sens_n1n2_ratios = zeros(5,5);
hyb_n1n2_ratios = zeros(5,5);

ori_n3n4_ratios = zeros(5,5);
vol_n3n4_ratios = zeros(5,5);
MBcorr_n3n4_ratios = zeros(5,5);
sens_n3n4_ratios = zeros(5,5);
hyb_n3n4_ratios = zeros(5,5);


for c1 = 1:5
    for c2 = 1:5
        ori_n1n2_ratios(c1,c2) = ori_roiData(c1,2) / ori_roiData(c2,1);
        vol_n1n2_ratios(c1,c2) = vol_roiData(c1,2) / vol_roiData(c2,1);
        MBcorr_n1n2_ratios(c1,c2) = MBcorr_roiData(c1,2) / MBcorr_roiData(c2,1);
        sens_n1n2_ratios(c1,c2) = sens_roiData(c1,2) / sens_roiData(c2,1);
        hyb_n1n2_ratios(c1,c2) = hybrid_roiData(c1,2) / hybrid_roiData(c2,1);
        
        ori_n3n4_ratios(c1,c2) = ori_roiData(c1,4) / ori_roiData(c2,3);
        vol_n3n4_ratios(c1,c2) = vol_roiData(c1,4) / vol_roiData(c2,3);
        MBcorr_n3n4_ratios(c1,c2) = MBcorr_roiData(c1,4) / MBcorr_roiData(c2,3);
        sens_n3n4_ratios(c1,c2) = sens_roiData(c1,4) / sens_roiData(c2,3);
        hyb_n3n4_ratios(c1,c2) = hybrid_roiData(c1,4) / hybrid_roiData(c2,3);       
    end
end

clear c1 c2


%% ROI ratio T1-contrast ratios (n1n3, n2n4)

ori_n1n3_ratios = zeros(5,5);
vol_n1n3_ratios = zeros(5,5);
MBcorr_n1n3_ratios = zeros(5,5);
sens_n1n3_ratios = zeros(5,5);
hyb_n1n3_ratios = zeros(5,5);

ori_n2n4_ratios = zeros(5,5);
vol_n2n4_ratios = zeros(5,5);
MBcorr_n2n4_ratios = zeros(5,5);
sens_n2n4_ratios = zeros(5,5);
hyb_n2n4_ratios = zeros(5,5);


for c1 = 1:5
    for c2 = 1:5
        ori_n1n3_ratios(c1,c2) = ori_roiData(c1,3) / ori_roiData(c2,1);
        vol_n1n3_ratios(c1,c2) = vol_roiData(c1,3) / vol_roiData(c2,1);
        MBcorr_n1n3_ratios(c1,c2) = MBcorr_roiData(c1,3) / MBcorr_roiData(c2,1);
        sens_n1n3_ratios(c1,c2) = sens_roiData(c1,3) / sens_roiData(c2,1);
        hyb_n1n3_ratios(c1,c2) = hybrid_roiData(c1,3) / hybrid_roiData(c2,1);
        
        ori_n2n4_ratios(c1,c2) = ori_roiData(c1,4) / ori_roiData(c2,2);
        vol_n2n4_ratios(c1,c2) = vol_roiData(c1,4) / vol_roiData(c2,2);
        MBcorr_n2n4_ratios(c1,c2) = MBcorr_roiData(c1,4) / MBcorr_roiData(c2,2);
        sens_n2n4_ratios(c1,c2) = sens_roiData(c1,4) / sens_roiData(c2,2);
        hyb_n2n4_ratios(c1,c2) = hybrid_roiData(c1,4) / hybrid_roiData(c2,2);       
    end
end

clear c1 c2
clear hybrid_roiData MBcorr_roiData ori_roiData sens_roiData vol_roiData


%% Error

% Quantification, lowT1
error_n1n2_MBcorr = abs(vol_n1n2_ratios - MBcorr_n1n2_ratios)./vol_n1n2_ratios * 100;
error_n1n2_sens = abs(vol_n1n2_ratios - sens_n1n2_ratios)./vol_n1n2_ratios * 100;
error_n1n2_hyb = abs(vol_n1n2_ratios - hyb_n1n2_ratios)./vol_n1n2_ratios * 100;
error_n1n2_ori = abs(vol_n1n2_ratios - ori_n1n2_ratios)./vol_n1n2_ratios * 100;

% Quantification, highT1
error_n3n4_MBcorr = abs(vol_n3n4_ratios - MBcorr_n3n4_ratios)./vol_n3n4_ratios * 100;
error_n3n4_sens = abs(vol_n3n4_ratios - sens_n3n4_ratios)./vol_n3n4_ratios * 100;
error_n3n4_hyb = abs(vol_n3n4_ratios - hyb_n3n4_ratios)./vol_n3n4_ratios * 100;
error_n3n4_ori = abs(vol_n3n4_ratios - ori_n3n4_ratios)./vol_n3n4_ratios * 100;

% T1-contrast, 100% water
error_n1n3_MBcorr = abs(vol_n1n3_ratios - MBcorr_n1n3_ratios)./vol_n1n3_ratios * 100;
error_n1n3_sens = abs(vol_n1n3_ratios - sens_n1n3_ratios)./vol_n1n3_ratios * 100;
error_n1n3_hyb = abs(vol_n1n3_ratios - hyb_n1n3_ratios)./vol_n1n3_ratios * 100;
error_n1n3_ori = abs(vol_n1n3_ratios - ori_n1n3_ratios)./vol_n1n3_ratios * 100;

% T1-contrast, 50% water/50% d2O
error_n2n4_MBcorr = abs(vol_n2n4_ratios - MBcorr_n2n4_ratios)./vol_n2n4_ratios * 100;
error_n2n4_sens = abs(vol_n2n4_ratios - sens_n2n4_ratios)./vol_n2n4_ratios * 100;
error_n2n4_hyb = abs(vol_n2n4_ratios - hyb_n2n4_ratios)./vol_n2n4_ratios * 100;
error_n2n4_ori = abs(vol_n2n4_ratios - ori_n2n4_ratios)./vol_n2n4_ratios * 100;

clear hyb_n1n2_ratios hyb_n1n3_ratios hyb_n2n4_ratios hyb_n3n4_ratios
clear MBcorr_n1n2_ratios MBcorr_n1n3_ratios MBcorr_n2n4_ratios MBcorr_n3n4_ratios
clear sens_n1n2_ratios sens_n1n3_ratios sens_n2n4_ratios sens_n3n4_ratios
clear ori_n1n2_ratios ori_n1n3_ratios ori_n2n4_ratios ori_n3n4_ratios
clear vol_n1n2_ratios vol_n1n3_ratios vol_n2n4_ratios vol_n3n4_ratios


%% Concatenate results

quant_ori = cat(2,error_n1n2_ori,error_n3n4_ori);
quant_easy = cat(2,error_n1n2_sens,error_n3n4_sens);
quant_corr = cat(2,error_n1n2_MBcorr,error_n3n4_MBcorr);
quant_hyb = cat(2,error_n1n2_hyb,error_n3n4_hyb);

contr_ori = cat(2,error_n1n3_ori,error_n2n4_ori);
contr_easy = cat(2,error_n1n3_sens,error_n2n4_sens);
contr_corr = cat(2,error_n1n3_MBcorr,error_n2n4_MBcorr);
contr_hyb = cat(2,error_n1n3_hyb,error_n2n4_hyb);

save(fullfile(pathOUT, 'quant_T1contrast_errors_flipback.mat'));