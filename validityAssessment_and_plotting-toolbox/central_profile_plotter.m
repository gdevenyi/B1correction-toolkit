%% Central profile plotter
% 
% This code creates a central profile line (i.e. the SI profile along a 
% central line perpendicular to the RF coil surface) and plots it against 
% distance to the RF coil surface
%
% This allows comparison between the original image, the different B1
% correction methods, and the images acquired with a volume resonator
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
%%%% img_vol          : volume RF coil image
%%%% img_ori          : original cryoprobe or Tx/Rx surface RF coil image
%%%% sensCorrected    : B1-corrected (sensitivity) image
%%%% MBCorrected      : B1-corrected (model-based) image
%%%% hybCorrected     : B1-corrected (hybrid) image
%
% OUTPUT:
%%%% plot of normalized central lines
%
%
% April 2020
% Paula Ramos Delgado
% ramosdelgado.paula@gmail.com
%

%% Load data

load('O:\Users\pramosdelgado\test_data\cryoprobe_data\exVivoData_cryo.mat','img_ori', 'img_vol','params_crp');
load('O:\Users\pramosdelgado\results_folder\B1correction\sensCorrection_exVivo.mat','sensCorrected');
load('O:\Users\pramosdelgado\results_folder\B1correction\modelBasedCorrection_exVivo.mat','MBCorrected');
load('O:\Users\pramosdelgado\results_folder\B1correction\hybridCorrection_exVivo.mat','hybCorrected');


%% User-defined parameters

pathOUT = 'O:\Users\pramosdelgado\output_folder';

plotFlag = 1; % select 1 for saving a .png with the fits, any other value for not saving

center = 65; % center of the profile
pxCount = 3; % thickness of line for averaging values (2*pxCount+1)

% Which kind of sample are you plotting?
sample = 'phantom'; % uniform phantom or ex vivo
%sample = 'mouse'; % in vivo mouse


%% Important stuff for plotting

cmap = [0 0 170; 255 128 0; 255 0 127; 0 153 76; 255 255 0; 102 0 102; 146 226 55; 51 51 255; 153 0 0; 64 64 64; 0 102 0; 0 153 153];
cmap = cmap ./ 256;


%% Profile calculation

pixSize = params_crp.method.PVM_SpatResol(1); % read pixel size 
xaxis = pixSize:pixSize:params_crp.method.PVM_Fov; % convert pixel to mm

% Calculate profiles 
vArray = center-pxCount:center+pxCount; 

verLine_sens = sensCorrected(:,vArray);
verLine_hyb = hybCorrected(:,vArray);
verLine_MB = MBCorrected(:,vArray);
verLine_ori = img_ori(:,vArray);
verLine_vol = img_vol(:,vArray);

avgProf_sens = squeeze(mean(verLine_sens,2)); avgProf_sens(isnan(avgProf_sens)) = 0;
avgProf_hyb = squeeze(mean(verLine_hyb,2)); avgProf_hyb(isnan(avgProf_hyb)) = 0;
avgProf_MB = squeeze(mean(verLine_MB,2)); avgProf_MB(isnan(avgProf_MB)) = 0;
avgProf_ori = squeeze(mean(verLine_ori,2)); avgProf_ori(isnan(avgProf_ori)) = 0;
avgProf_vol = squeeze(mean(verLine_vol,2)); avgProf_vol(isnan(avgProf_vol)) = 0;

clear center pxCount pixSize vArray verLine_hyb verLine_sens verLine_MB verLine_ori verLine_sens verLine_vol
clear sensCorrected hybCorrected MBCorrected img_ori img_vol


%% Normalize profiles [0,1]

avgProf_sens(avgProf_sens==Inf) = 0;
avgProf_hyb(avgProf_hyb==Inf) = 0;
avgProf_MB(avgProf_MB==Inf) = 0;

avgProf_sensN = avgProf_sens/mean(avgProf_sens); 
avgProf_hybN = avgProf_hyb/mean(avgProf_hyb); 
avgProf_MBN = avgProf_MB/mean(avgProf_MB); 
avgProf_oriN = avgProf_ori/mean(avgProf_ori); 
avgProf_volN = avgProf_vol/mean(avgProf_vol); 

avgProf_sensN(isnan(avgProf_sensN))=0;
avgProf_sensN(avgProf_sensN<0)=0;
avgProf_hybN(isnan(avgProf_hybN))=0;
avgProf_hybN(avgProf_hybN<0)=0;
avgProf_MBN(isnan(avgProf_MBN))=0;
avgProf_MBN(avgProf_MBN<0)=0;
avgProf_oriN(isnan(avgProf_oriN))=0;
avgProf_volN(isnan(avgProf_volN))=0;

maxAvgProf_oriN = max(avgProf_oriN);
maxAvgProf_volN = max(avgProf_volN);
if strcmp(sample,'phantom')
    maxAvgProf_sensN = max(avgProf_sensN(1:85,:));
    maxAvgProf_hybN = max(avgProf_hybN(1:85,:));
    maxAvgProf_MBN = max(avgProf_MBN(1:85,:));
elseif strcmp(sample,'mouse')
    maxAvgProf_sensN = max(avgProf_sensN(41:85,:));
    maxAvgProf_hybN = max(avgProf_hybN(41:85,:));
    maxAvgProf_MBN = max(avgProf_MBN(41:85,:));
end
 
clear avgProf_hyb avgProf_MB avgProf_ori avgProf_sens avgProf_vol 

avgProf_sensN2 = avgProf_sensN/maxAvgProf_sensN; %CRP-corrected
avgProf_hybN2 = avgProf_hybN/maxAvgProf_hybN; %CRP-corrected
avgProf_MBN2 = avgProf_MBN/maxAvgProf_MBN; %CRP-corrected
avgProf_oriN2 = avgProf_oriN/maxAvgProf_oriN; %CRP-uncorrected 
avgProf_volN2 = avgProf_volN/maxAvgProf_volN; % VOL

clear maxAvgProf_sensN maxAvgProf_hybN maxAvgProf_MBN maxAvgProf_oriN maxAvgProf_volN

% Profile
hF = figure(); 
if strcmp(sample,'phantom')
    plot(avgProf_sensN2(23:108)', xaxis(23:108)', 'LineWidth', 3, 'LineStyle', '-', 'Color',cmap(1,:)); axis ij; hold on;  
    plot(avgProf_hybN2(23:108)', xaxis(23:108)', 'LineWidth', 3, 'LineStyle', '-', 'Color',cmap(8,:)); axis ij; 
    plot(avgProf_MBN2(23:108)', xaxis(23:108)', 'LineWidth', 3, 'LineStyle', '-', 'Color',cmap(6,:)); axis ij;  
    plot(avgProf_oriN2(23:108)', xaxis(23:108)', 'LineWidth', 3, 'LineStyle', '-', 'Color',cmap(9,:)); axis ij; 
    plot(avgProf_volN2(23:108)', xaxis(23:108)', 'LineWidth', 3, 'LineStyle', '-', 'Color',cmap(4,:)); axis ij; 
elseif strcmp(sample,'mouse')
    plot(avgProf_sensN2(19:104)', xaxis(19:104)', 'LineWidth', 3, 'LineStyle', '-', 'Color',cmap(1,:)); axis ij; hold on;  
    plot(avgProf_hybN2(19:104)', xaxis(19:104)', 'LineWidth', 3, 'LineStyle', '-', 'Color',cmap(8,:)); axis ij;  
    plot(avgProf_MBN2(19:104)', xaxis(19:104)', 'LineWidth', 3, 'LineStyle', '-', 'Color',cmap(6,:)); axis ij;  
    plot(avgProf_oriN2(19:104)', xaxis(19:104)', 'LineWidth', 3, 'LineStyle', '-', 'Color',cmap(9,:)); axis ij; 
    plot(avgProf_volN2(19:104)', xaxis(19:104)', 'LineWidth', 3, 'LineStyle', '-', 'Color',cmap(4,:)); axis ij; 
end
set(gca, 'FontSize', 14)
legend('Sensitivity correction', 'Hybrid correction', 'Model-based correction', 'Original', 'Reference')
legend boxoff
grid on;
xlim([0 1.5])
ax = gca; 
ax.XAxis.TickValues = 0:0.5:1.5;
set(gcf,'units','normalized','outerposition',[0 0 0.25 1]);
xlabel ('SI normalized (a.u.)')
ylabel ('distance (mm)')

if plotFlag == 1
	saveas(hF, fullfile(pathOUT, 'profiles_exvivo_7pix_normalized.png'));
end

save(fullfile(pathOUT, 'profiles_exvivo_7pix_normalizedDATA.mat'),'avgProf_sensN2','avgProf_hybN2','avgProf_MBN2','avgProf_oriN2','avgProf_volN2','xaxis');