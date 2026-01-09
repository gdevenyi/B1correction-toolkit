%% Percentage Integral Uniformity - uniform phantom
% 
% The PIU can quantitatively assess the homogeneity of the corrected images
%
% This code calculates the PIU on 5 internally-tangential circular ROIs 
% defined with increasing diameter on the central vertical line.
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
%%%% img_vol          : volume RF coil image
%%%% img_ori          : original cryoprobe or Tx/Rx surface RF coil image
%%%% sensCorrected    : B1-corrected (sensitivity) image
%%%% MBCorrected      : B1-corrected (model-based) image
%%%% hybCorrected     : B1-corrected (hybrid) image
%
% OUTPUT:
%%%% PIU_all = [PIU_vol,PIU_ori,PIU_MBcorr,PIU_sens,PIU_hyb];
%%%% excel sheet with PIU values
%
%
% IMPORTANT: a PIU of 100% represents perfect image homogeneity
%
% April 2020
% Paula Ramos Delgado
% ramosdelgado.paula@gmail.com
%

%% Load data

load('O:\Users\pramosdelgado\test_data\cryoprobe_data\uniformData_cryo.mat','img_ori', 'img_vol','params_crp');
load('O:\Users\pramosdelgado\results_folder\B1correction\sensCorrection_uniform.mat','sensCorrected');
load('O:\Users\pramosdelgado\results_folder\B1correction\modelBasedCorrection_uniform.mat','MBCorrected');
load('O:\Users\pramosdelgado\results_folder\B1correction\hybridCorrection_uniform.mat','hybCorrected');


%% User-defined parameters

pathOUT = 'O:\Users\pramosdelgado\output_folder';

% Select ROI positions
pos1 = [60 37 10 10];
pos2 = [54 37 22 22];
pos3 = [48 37 34 34];
pos4 = [42 37 46 46];
pos5 = [36 37 58 58];

centerLine = 65; % Select central line for plot


%% Define ROIs
figure(), imagesc(img_vol), colormap(gray(256))

c1 = imellipse(gca, pos1);
c2 = imellipse(gca, pos2);
c3 = imellipse(gca, pos3);
c4 = imellipse(gca, pos4);
c5 = imellipse(gca, pos5);

c1 = c1.createMask;
c2 = c2.createMask;
c3 = c3.createMask;
c4 = c4.createMask;
c5 = c5.createMask;

clear pos1 pos2 pos3 pos4 pos5

close;


%% Define in images

c1_MBcorr = MBCorrected .* c1;
c2_MBcorr = MBCorrected .* c2;
c3_MBcorr = MBCorrected .* c3;
c4_MBcorr = MBCorrected .* c4;
c5_MBcorr = MBCorrected .* c5;

c1_hyb = hybCorrected .* c1;
c2_hyb = hybCorrected .* c2;
c3_hyb = hybCorrected .* c3;
c4_hyb = hybCorrected .* c4;
c5_hyb = hybCorrected .* c5;

c1_sens = sensCorrected .* c1;
c2_sens = sensCorrected .* c2;
c3_sens = sensCorrected .* c3;
c4_sens = sensCorrected .* c4;
c5_sens = sensCorrected .* c5;

c1_ori = img_ori .* c1;
c2_ori = img_ori .* c2;
c3_ori = img_ori .* c3;
c4_ori = img_ori .* c4;
c5_ori = img_ori .* c5;

c1_vol = img_vol .* c1;
c2_vol = img_vol .* c2;
c3_vol = img_vol .* c3;
c4_vol = img_vol .* c4;
c5_vol = img_vol .* c5;

clear c1 c2 c3 c4 c5


%% Calculations

c1_vol(c1_vol==0) = NaN; c2_vol(c2_vol==0) = NaN; c3_vol(c3_vol==0) = NaN; c4_vol(c4_vol==0) = NaN; c5_vol(c5_vol==0) = NaN;
c1_ori(c1_ori==0) = NaN; c2_ori(c2_ori==0) = NaN; c3_ori(c3_ori==0) = NaN; c4_ori(c4_ori==0) = NaN; c5_ori(c5_ori==0) = NaN;
c1_MBcorr(c1_MBcorr==0) = NaN; c2_MBcorr(c2_MBcorr==0) = NaN; c3_MBcorr(c3_MBcorr==0) = NaN; c4_MBcorr(c4_MBcorr==0) = NaN; c5_MBcorr(c5_MBcorr==0) = NaN;
c1_sens(c1_sens==0) = NaN; c2_sens(c2_sens==0) = NaN; c3_sens(c3_sens==0) = NaN; c4_sens(c4_sens==0) = NaN; c5_sens(c5_sens==0) = NaN;
c1_hyb(c1_hyb==0) = NaN; c2_hyb(c2_hyb==0) = NaN; c3_hyb(c3_hyb==0) = NaN; c4_hyb(c4_hyb==0) = NaN; c5_hyb(c5_hyb==0) = NaN;
 
% Smax, Smin
Smax_c1_vol = max(c1_vol(:)); Smin_c1_vol = min(c1_vol(:));
Smax_c2_vol = max(c2_vol(:)); Smin_c2_vol = min(c2_vol(:));
Smax_c3_vol = max(c3_vol(:)); Smin_c3_vol = min(c3_vol(:));
Smax_c4_vol = max(c4_vol(:)); Smin_c4_vol = min(c4_vol(:));
Smax_c5_vol = max(c5_vol(:)); Smin_c5_vol = min(c5_vol(:));

Smax_c1_ori = max(c1_ori(:)); Smin_c1_ori = min(c1_ori(:));
Smax_c2_ori = max(c2_ori(:)); Smin_c2_ori = min(c2_ori(:));
Smax_c3_ori = max(c3_ori(:)); Smin_c3_ori = min(c3_ori(:));
Smax_c4_ori = max(c4_ori(:)); Smin_c4_ori = min(c4_ori(:));
Smax_c5_ori = max(c5_ori(:)); Smin_c5_ori = min(c5_ori(:));

Smax_c1_MBcorr = max(c1_MBcorr(:)); Smin_c1_MBcorr = min(c1_MBcorr(:));
Smax_c2_MBcorr = max(c2_MBcorr(:)); Smin_c2_MBcorr = min(c2_MBcorr(:));
Smax_c3_MBcorr = max(c3_MBcorr(:)); Smin_c3_MBcorr = min(c3_MBcorr(:));
Smax_c4_MBcorr = max(c4_MBcorr(:)); Smin_c4_MBcorr = min(c4_MBcorr(:));
Smax_c5_MBcorr = max(c5_MBcorr(:)); Smin_c5_MBcorr = min(c5_MBcorr(:));

Smax_c1_sens = max(c1_sens(:)); Smin_c1_sens = min(c1_sens(:));
Smax_c2_sens = max(c2_sens(:)); Smin_c2_sens = min(c2_sens(:));
Smax_c3_sens = max(c3_sens(:)); Smin_c3_sens = min(c3_sens(:));
Smax_c4_sens = max(c4_sens(:)); Smin_c4_sens = min(c4_sens(:));
Smax_c5_sens = max(c5_sens(:)); Smin_c5_sens = min(c5_sens(:));

Smax_c1_hyb = max(c1_hyb(:)); Smin_c1_hyb = min(c1_hyb(:));
Smax_c2_hyb = max(c2_hyb(:)); Smin_c2_hyb = min(c2_hyb(:));
Smax_c3_hyb = max(c3_hyb(:)); Smin_c3_hyb = min(c3_hyb(:));
Smax_c4_hyb = max(c4_hyb(:)); Smin_c4_hyb = min(c4_hyb(:));
Smax_c5_hyb = max(c5_hyb(:)); Smin_c5_hyb = min(c5_hyb(:));

clear c1_vol c2_vol c3_vol c4_vol c5_vol
clear c1_ori c2_ori c3_ori c4_ori c5_ori
clear c1_MBcorr c2_MBcorr c3_MBcorr c4_MBcorr c5_MBcorr
clear c1_sens c2_sens c3_sens c4_sens c5_sens
clear c1_hyb c2_hyb c3_hyb c4_hyb c5_hyb
clear MBCorrected hybCorrected sensCorrected img_ori img_vol


%% Integral non-uniformity or percent image uniformity (PIU)

PIU_vol = zeros(5,1);
PIU_ori = zeros(5,1);
PIU_MBcorr = zeros(5,1);
PIU_sens = zeros(5,1);
PIU_hyb = zeros(5,1);

delta_c1_vol = Smax_c1_vol - Smin_c1_vol; mid_c1_vol = Smax_c1_vol + Smin_c1_vol;
delta_c2_vol = Smax_c2_vol - Smin_c2_vol; mid_c2_vol = Smax_c2_vol + Smin_c2_vol;
delta_c3_vol = Smax_c3_vol - Smin_c3_vol; mid_c3_vol = Smax_c3_vol + Smin_c3_vol;
delta_c4_vol = Smax_c4_vol - Smin_c4_vol; mid_c4_vol = Smax_c4_vol + Smin_c4_vol;
delta_c5_vol = Smax_c5_vol - Smin_c5_vol; mid_c5_vol = Smax_c5_vol + Smin_c5_vol;

PIU_vol(1,:) = (1- delta_c1_vol/mid_c1_vol) * 100;
PIU_vol(2,:) = (1- delta_c2_vol/mid_c2_vol) * 100;
PIU_vol(3,:) = (1- delta_c3_vol/mid_c3_vol) * 100;
PIU_vol(4,:) = (1- delta_c4_vol/mid_c4_vol) * 100;
PIU_vol(5,:) = (1- delta_c5_vol/mid_c5_vol) * 100;
clear delta_c1_vol delta_c2_vol delta_c3_vol delta_c4_vol delta_c5_vol
clear mid_c1_vol mid_c2_vol mid_c3_vol mid_c4_vol mid_c5_vol
clear Smax_c1_vol Smax_c2_vol Smax_c3_vol Smax_c4_vol Smax_c5_vol
clear Smin_c1_vol Smin_c2_vol Smin_c3_vol Smin_c4_vol Smin_c5_vol

delta_c1_ori = Smax_c1_ori - Smin_c1_ori; mid_c1_ori = Smax_c1_ori + Smin_c1_ori;
delta_c2_ori = Smax_c2_ori - Smin_c2_ori; mid_c2_ori = Smax_c2_ori + Smin_c2_ori;
delta_c3_ori = Smax_c3_ori - Smin_c3_ori; mid_c3_ori = Smax_c3_ori + Smin_c3_ori;
delta_c4_ori = Smax_c4_ori - Smin_c4_ori; mid_c4_ori = Smax_c4_ori + Smin_c4_ori;
delta_c5_ori = Smax_c5_ori - Smin_c5_ori; mid_c5_ori = Smax_c5_ori + Smin_c5_ori;

PIU_ori(1,:) = (1- delta_c1_ori/mid_c1_ori) * 100;
PIU_ori(2,:) = (1- delta_c2_ori/mid_c2_ori) * 100;
PIU_ori(3,:) = (1- delta_c3_ori/mid_c3_ori) * 100;
PIU_ori(4,:) = (1- delta_c4_ori/mid_c4_ori) * 100;
PIU_ori(5,:) = (1- delta_c5_ori/mid_c5_ori) * 100;
clear delta_c1_ori delta_c2_ori delta_c3_ori delta_c4_ori delta_c5_ori
clear mid_c1_ori mid_c2_ori mid_c3_ori mid_c4_ori mid_c5_ori
clear Smax_c1_ori Smax_c2_ori Smax_c3_ori Smax_c4_ori Smax_c5_ori
clear Smin_c1_ori Smin_c2_ori Smin_c3_ori Smin_c4_ori Smin_c5_ori

delta_c1_MBcorr = Smax_c1_MBcorr - Smin_c1_MBcorr; mid_c1_MBcorr = Smax_c1_MBcorr + Smin_c1_MBcorr;
delta_c2_MBcorr = Smax_c2_MBcorr - Smin_c2_MBcorr; mid_c2_MBcorr = Smax_c2_MBcorr + Smin_c2_MBcorr;
delta_c3_MBcorr = Smax_c3_MBcorr - Smin_c3_MBcorr; mid_c3_MBcorr = Smax_c3_MBcorr + Smin_c3_MBcorr;
delta_c4_MBcorr = Smax_c4_MBcorr - Smin_c4_MBcorr; mid_c4_MBcorr = Smax_c4_MBcorr + Smin_c4_MBcorr;
delta_c5_MBcorr = Smax_c5_MBcorr - Smin_c5_MBcorr; mid_c5_MBcorr = Smax_c5_MBcorr + Smin_c5_MBcorr;

PIU_MBcorr(1,:) = (1- delta_c1_MBcorr/mid_c1_MBcorr) * 100;
PIU_MBcorr(2,:) = (1- delta_c2_MBcorr/mid_c2_MBcorr) * 100;
PIU_MBcorr(3,:) = (1- delta_c3_MBcorr/mid_c3_MBcorr) * 100;
PIU_MBcorr(4,:) = (1- delta_c4_MBcorr/mid_c4_MBcorr) * 100;
PIU_MBcorr(5,:) = (1- delta_c5_MBcorr/mid_c5_MBcorr) * 100;
clear delta_c1_MBcorr delta_c2_MBcorr delta_c3_MBcorr delta_c4_MBcorr delta_c5_MBcorr
clear mid_c1_MBcorr mid_c2_MBcorr mid_c3_MBcorr mid_c4_MBcorr mid_c5_MBcorr
clear Smax_c1_MBcorr Smax_c2_MBcorr Smax_c3_MBcorr Smax_c4_MBcorr Smax_c5_MBcorr
clear Smin_c1_MBcorr Smin_c2_MBcorr Smin_c3_MBcorr Smin_c4_MBcorr Smin_c5_MBcorr

delta_c1_sens = Smax_c1_sens - Smin_c1_sens; mid_c1_sens = Smax_c1_sens + Smin_c1_sens;
delta_c2_sens = Smax_c2_sens - Smin_c2_sens; mid_c2_sens = Smax_c2_sens + Smin_c2_sens;
delta_c3_sens = Smax_c3_sens - Smin_c3_sens; mid_c3_sens = Smax_c3_sens + Smin_c3_sens;
delta_c4_sens = Smax_c4_sens - Smin_c4_sens; mid_c4_sens = Smax_c4_sens + Smin_c4_sens;
delta_c5_sens = Smax_c5_sens - Smin_c5_sens; mid_c5_sens = Smax_c5_sens + Smin_c5_sens;

PIU_sens(1,:) = (1- delta_c1_sens/mid_c1_sens) * 100;
PIU_sens(2,:) = (1- delta_c2_sens/mid_c2_sens) * 100;
PIU_sens(3,:) = (1- delta_c3_sens/mid_c3_sens) * 100;
PIU_sens(4,:) = (1- delta_c4_sens/mid_c4_sens) * 100;
PIU_sens(5,:) = (1- delta_c5_sens/mid_c5_sens) * 100;
clear delta_c1_sens delta_c2_sens delta_c3_sens delta_c4_sens delta_c5_sens
clear mid_c1_sens mid_c2_sens mid_c3_sens mid_c4_sens mid_c5_sens
clear Smax_c1_sens Smax_c2_sens Smax_c3_sens Smax_c4_sens Smax_c5_sens
clear Smin_c1_sens Smin_c2_sens Smin_c3_sens Smin_c4_sens Smin_c5_sens

delta_c1_hyb = Smax_c1_hyb - Smin_c1_hyb; mid_c1_hyb = Smax_c1_hyb + Smin_c1_hyb;
delta_c2_hyb = Smax_c2_hyb - Smin_c2_hyb; mid_c2_hyb = Smax_c2_hyb + Smin_c2_hyb;
delta_c3_hyb = Smax_c3_hyb - Smin_c3_hyb; mid_c3_hyb = Smax_c3_hyb + Smin_c3_hyb;
delta_c4_hyb = Smax_c4_hyb - Smin_c4_hyb; mid_c4_hyb = Smax_c4_hyb + Smin_c4_hyb;
delta_c5_hyb = Smax_c5_hyb - Smin_c5_hyb; mid_c5_hyb = Smax_c5_hyb + Smin_c5_hyb;

PIU_hyb(1,:) = (1- delta_c1_hyb/mid_c1_hyb) * 100;
PIU_hyb(2,:) = (1- delta_c2_hyb/mid_c2_hyb) * 100;
PIU_hyb(3,:) = (1- delta_c3_hyb/mid_c3_hyb) * 100;
PIU_hyb(4,:) = (1- delta_c4_hyb/mid_c4_hyb) * 100;
PIU_hyb(5,:) = (1- delta_c5_hyb/mid_c5_hyb) * 100;
clear delta_c1_hyb delta_c2_hyb delta_c3_hyb delta_c4_hyb delta_c5_hyb
clear mid_c1_hyb mid_c2_hyb mid_c3_hyb mid_c4_hyb mid_c5_hyb
clear Smax_c1_hyb Smax_c2_hyb Smax_c3_hyb Smax_c4_hyb Smax_c5_hyb
clear Smin_c1_hyb Smin_c2_hyb Smin_c3_hyb Smin_c4_hyb Smin_c5_hyb

PIU_all = cat(2,PIU_vol,PIU_ori,PIU_MBcorr,PIU_sens,PIU_hyb);
clear PIU_vol PIU_ori PIU_MBcorr PIU_hyb PIU_sens

save(fullfile(pathOUT,'PIU_values_uniform.mat'), 'PIU_all');


%% Important stuff for plot

cmap = [0 0 170; 255 128 0; 255 0 127; 0 153 76; 255 255 0; 102 0 102; 146 226 55; 51 51 255; 153 0 0; 64 64 64; 0 102 0; 0 153 153];
cmap = cmap ./ 256;


%% Calculate distance ranges for plot

pixSize = params_crp.method.PVM_SpatResol(1); % pixel size = [scanParamsRefPow{1,1}.method.PVM_SpatResol scanParamsRefPow{1,1}.method.PVM_SliceThick]
xaxis = pixSize:pixSize:params_crp.method.PVM_Fov; % pixel to mm

dVector_pix = [37, 47, 59, 71, 83, 95]; % select pixels start-end of the ranges
dVector_pos = xaxis(dVector_pix);


%% Plot

PIU_all(PIU_all<0)=0;
roi_labels = {''; '7.2 - 9.2'; '7.2 - 11.5'; '7.2 - 13.9'; '7.2 - 16.2'; '7.2 - 18.6'}; %dvector_pos

hF = figure(); 
plot(PIU_all(:,4), 1:5, 'LineWidth', 3, 'MarkerSize',25,'Marker','.', 'Color',cmap(1,:)), axis ij, hold on, 
plot(PIU_all(:,3), 1:5,  'LineWidth', 3, 'MarkerSize',25,'Marker','.', 'Color',cmap(6,:)),axis ij,          
plot(PIU_all(:,5), 1:5, 'LineWidth', 3, 'MarkerSize',25,'Marker','.', 'Color',cmap(8,:)), axis ij,          
plot(PIU_all(:,2),1:5,  'LineWidth', 3, 'MarkerSize',25,'Marker','.', 'Color',cmap(9,:)), axis ij,         
plot(PIU_all(:,1), 1:5, 'LineWidth', 3, 'MarkerSize',25,'Marker','.', 'Color',cmap(4,:)), axis ij, hold off 

xlim([0 105])
ax = gca; 
ax.YAxis.TickValues = 0:1:5;
ax.XAxis.TickValues = [0,35,70,100];
yticklabels(roi_labels);
set(gca, 'FontSize', 14)
grid on; 
set(gcf,'units','normalized','outerposition',[0 0 0.25 1]);
saveas(hF, fullfile(pathOUT, 'PIU_plot_uniform.png'));


