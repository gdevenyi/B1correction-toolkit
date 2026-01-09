%% RARE model - fitting tool: SI=f(FA_ordered,T1)
% 
% This code uses a modified version of polyfitn available as:
%
% John D'Errico (2018). polyfitn
% https://www.mathworks.com/matlabcentral/fileexchange/34765-polyfitn)
% MATLAB Central File Exchange
%
% to create a signal intensity (SI) model using images of NMR tubes with 
% different T1 values and acquired using RARE with different reference
% powers (flip angles, FA)
%
% This code generates the model using a polynomial fit of the chosen order 
% and returns the R-square parameter
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
%%%% SI_ordered : contains the SIs and FA_ordereds obtained from the measurements
%%%%              in a matrix (FA_ordered,SI) (rows,cols)
%%%% T1_ordered : is an ordered array with the T1 relaxation times of the 
%%%%              solutions filling the NMR tubes
%%%% FA_ordered : is an ordered array with the FA_ordereds used for the measurements 
%
% OUTPUT:
%%%% fittedData : contains a matrix (FA_ordered,SI) (rows,cols) with the
%%%%              fitted data 
%%%% polyModel  : structure that contains the regression model
%%%%      polymodel.ModelTerms = list of terms in the model
%%%%      polymodel.Coefficients = regression coefficients
%%%%      polymodel.ParameterVar = variances of model coefficients
%%%%      polymodel.ParameterStd = standard deviation of model coefficients
%%%%      polymodel.DoF = Degrees of freedom remaining
%%%%      polymodel.p = double sided t-probability, as a test against zero
%%%%      polymodel.R2 = R^2 for the regression model
%%%%      polymodel.AdjustedR2 = Adjusted R^2 for the regression model
%%%%      polymodel.RMSE = Root mean squared error
%%%%      polymodel.VarNames = Cell array of variable names as parsed from 
%%%%      a char based model specification.
%
%
% DON'T FORGET TO ADD THE PATH TO "RAREmodel_fitting-toolbox"
%
% IMPORTANT:
% 1. Always plot your fits.   
% 2. Choose the highest polynomial order that represents your data the most 
%    accurately. Check the R-squared value but always plot your fit data. 
% 3. Be aware that for higher polynomial orders there will be some ringing
%    between data points, typically on the edges for very low and very high 
%    FA_ordereds. Decide if you can live with that (the typical answer would be 
%    yes) and choose your polynomial order accordingly.
% 4. At FA_ordered=0 for any T1, the SI should be 0. You can add this point to your
%    fit to reduce the negative values at very low and very high FA_ordereds due to
%    the ringing mentioned in (2).
%
%
% April 2020
% Paula Ramos Delgado
% ramosdelgado.paula@gmail.com
%


%% Add path to "model_fitting-toolbox"

addpath(genpath('O:\Users\pramosdelgado\RARE_fitting-toolbox')); %set the path that contains the RAREmodel_fitting-toolbox


%% Load the data and set paths

pathData = 'O:\Users\pramosdelgado\test_data\RAREmodel_data\RAREraw_flipback_modelData.mat'; % select INPUT path where the data is saved
load(pathData); % load data

pathOUT = 'O:\Users\pramosdelgado\output_folder\'; % select OUTPUT path to save the resulting images and data


%% User-defined parameters

plotFlag = 1; % select 1 for saving a .png with the fits, any other value for not saving


%% Important stuff for plotting

cmap = [0 0 0.6667; 0 0 1; 0.3333 1 0.6667; 1 1 0; 1 0 0; 0 0.3333 1; 0.6667 1 0.3333; 0 0.6667 1; 1 0.6667 0; 1 0.3333 0; 0 1 1; 0.6667 0 0];


%% Plot data prior to fit (advisable)

if plotFlag == 1
    figure()
        plot(FA_ordered,SI_ordered(:,1), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(1,:)), hold on,
        plot(FA_ordered,SI_ordered(:,2), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(5,:)), 
        plot(FA_ordered,SI_ordered(:,3), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(3,:)),
        plot(FA_ordered,SI_ordered(:,4), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(4,:)),
        plot(FA_ordered,SI_ordered(:,5), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(10,:)),

        plot(FA_ordered,SI_ordered(:,6), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(7,:)), 
        plot(FA_ordered,SI_ordered(:,7), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(2,:)), 
        plot(FA_ordered,SI_ordered(:,8), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(12,:)),
        plot(FA_ordered,SI_ordered(:,9), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(11,:)),
        plot(FA_ordered,SI_ordered(:,10), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(9,:)),

    title('Signal Intensity in selected NMR tubes','fontsize',12)
    ylabel('SI (a.u.)','fontsize',12);
    legend (num2str(T1_ordered(1)), num2str(T1_ordered(2)), num2str(T1_ordered(3)),num2str(T1_ordered(4)),num2str(T1_ordered(5)),num2str(T1_ordered(6)), num2str(T1_ordered(7)), num2str(T1_ordered(8)), num2str(T1_ordered(9)), num2str(T1_ordered(10)))
end


%% Fitting the model
%
% Here I have selected orders 1st (a simple line) to 8th, but it is just an
% example

mask = true(size(SI_ordered)); % create mask for function

[ fittedData8, polyModel8 ] = fitDataWithPolynomeFAT1_PRD(SI_ordered, 8, mask, FA_ordered, T1_ordered);
[ fittedData7, polyModel7 ] = fitDataWithPolynomeFAT1_PRD(SI_ordered, 7, mask, FA_ordered, T1_ordered);
[ fittedData6, polyModel6 ] = fitDataWithPolynomeFAT1_PRD(SI_ordered, 6, mask, FA_ordered, T1_ordered);
[ fittedData5, polyModel5 ] = fitDataWithPolynomeFAT1_PRD(SI_ordered, 5, mask, FA_ordered, T1_ordered);
[ fittedData4, polyModel4 ] = fitDataWithPolynomeFAT1_PRD(SI_ordered, 4, mask, FA_ordered, T1_ordered);
[ fittedData3, polyModel3 ] = fitDataWithPolynomeFAT1_PRD(SI_ordered, 3, mask, FA_ordered, T1_ordered);
[ fittedData2, polyModel2 ] = fitDataWithPolynomeFAT1_PRD(SI_ordered, 2, mask, FA_ordered, T1_ordered);
[ fittedData1, polyModel1 ] = fitDataWithPolynomeFAT1_PRD(SI_ordered, 1, mask, FA_ordered, T1_ordered);

save((fullfile(pathOUT,'RAREmodel_flipback_allOrders.mat'))); 


%% Plot each T1 all fits (advisable)

fits = cat(3,fittedData1,fittedData2,fittedData3,fittedData4,fittedData5,fittedData6,fittedData7,fittedData8);

for t = 1:size(SI_ordered,2)
    hF=figure(t);
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    
    maxSI = max(SI_ordered(:,t));
    maxT1_fit = squeeze(fits(:,t,:));
    maxFit = max(maxT1_fit(:));
    maxSI = max([maxSI,maxFit]);
    
    subplot(2,4,1)
    plot(FA_ordered,SI_ordered(:,t), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(1,:)), hold on
    plot(FA_ordered,fittedData8(:,t), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(5,:))
    title(sprintf('fitted polynomial 8th order \nRMSE = %.3f, R^{2} = %.3f for T1=%.3f ms',polyModel6.RMSE, polyModel6.R2, T1_ordered(t)))
    ylabel('SI mean (a.u.)','fontsize',12);
    xlabel('FA_ordered (deg.)','fontsize',12);
    legend('data','fit','Location', 'southeast')
    set(gca,'XTick',FA_ordered)
    ylim([0 maxSI])
    xlim([0 max(FA_ordered)])
    
    subplot(2,4,2)
    plot(FA_ordered,SI_ordered(:,t), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(1,:)), hold on
    plot(FA_ordered,fittedData7(:,t), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(5,:))
    title(sprintf('fitted polynomial 7th order \nRMSE = %.3f, R^{2} = %.3f for T1=%.3f ms',polyModel6.RMSE, polyModel6.R2, T1_ordered(t)))
    ylabel('SI mean (a.u.)','fontsize',12);
    xlabel('FA_ordered (deg.)','fontsize',12);
    legend('data','fit','Location', 'southeast')
    set(gca,'XTick',FA_ordered)
    ylim([0 maxSI])
    xlim([0 max(FA_ordered)])
    
    subplot(2,4,3)
    plot(FA_ordered,SI_ordered(:,t), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(1,:)), hold on
    plot(FA_ordered,fittedData6(:,t), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(5,:))
    title(sprintf('fitted polynomial 6th order \nRMSE = %.3f, R^{2} = %.3f for T1=%.3f ms',polyModel6.RMSE, polyModel6.R2, T1_ordered(t)))
    ylabel('SI mean (a.u.)','fontsize',12);
    xlabel('FA_ordered (deg.)','fontsize',12);
    legend('data','fit','Location', 'southeast')
    set(gca,'XTick',FA_ordered)
    ylim([0 maxSI])
    xlim([0 max(FA_ordered)])

    subplot(2,4,4)
    plot(FA_ordered,SI_ordered(:,t), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(1,:)), hold on
    plot(FA_ordered,fittedData5(:,t), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(5,:))
    title(sprintf('fitted polynomial 5th order \nRMSE = %.3f, R^{2} = %.3f for T1=%.3f ms',polyModel5.RMSE, polyModel5.R2, T1_ordered(t)))
    ylabel('SI mean (a.u.)','fontsize',12);
    xlabel('FA_ordered (deg.)','fontsize',12);
    legend('data','fit','Location', 'southeast')
    set(gca,'XTick',FA_ordered)
    ylim([0 maxSI])
    xlim([0 max(FA_ordered)])

    subplot(2,4,5)
    plot(FA_ordered,SI_ordered(:,t), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(1,:)), hold on
    plot(FA_ordered,fittedData4(:,t), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(5,:))
    title(sprintf('fitted polynomial 4th order \nRMSE = %.3f, R^{2} = %.3f for T1=%.3f ms',polyModel4.RMSE, polyModel4.R2, T1_ordered(t)))
    ylabel('SI mean (a.u.)','fontsize',12);
    xlabel('FA_ordered (deg.)','fontsize',12);
    legend('data','fit','Location', 'southeast')
    set(gca,'XTick',FA_ordered)
    ylim([0 maxSI])
    xlim([0 max(FA_ordered)])

    subplot(2,4,6)
    plot(FA_ordered,SI_ordered(:,t), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(1,:)), hold on
    plot(FA_ordered,fittedData3(:,t), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(5,:))
    title(sprintf('fitted polynomial 3rd order \nRMSE = %.3f, R^{2} = %.3f for T1=%.3f ms',polyModel3.RMSE, polyModel3.R2, T1_ordered(t)))
    ylabel('SI mean (a.u.)','fontsize',12);
    xlabel('FA_ordered (deg.)','fontsize',12);
    legend('data','fit','Location', 'southeast')
    set(gca,'XTick',FA_ordered)
    ylim([0 maxSI])
    xlim([0 max(FA_ordered)])

    subplot(2,4,7)
    plot(FA_ordered,SI_ordered(:,t), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(1,:)), hold on
    plot(FA_ordered,fittedData2(:,t), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(5,:))
    title(sprintf('fitted polynomial 2nd order \nRMSE = %.3f, R^{2} = %.3f for T1=%.3f ms',polyModel2.RMSE, polyModel2.R2, T1_ordered(t)))
    ylabel('SI mean (a.u.)','fontsize',12);
    xlabel('FA_ordered (deg.)','fontsize',12);
    legend('data','fit','Location', 'southeast')
    set(gca,'XTick',FA_ordered)
    ylim([0 maxSI])
    xlim([0 max(FA_ordered)])

    subplot(2,4,8)
    plot(FA_ordered,SI_ordered(:,t), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(1,:)), hold on
    plot(FA_ordered,fittedData1(:,t), '-o', 'LineWidth',2, 'MarkerSize',5, 'MarkerEdgeColor','k', 'Color',cmap(5,:))
    title(sprintf('fitted polynomial 1st order \nRMSE = %.3f, R^{2} = %.3f for T1=%.3f ms',polyModel1.RMSE, polyModel1.R2, T1_ordered(t)))
    ylabel('SI mean (a.u.)','fontsize',12);
    xlabel('FA_ordered (deg.)','fontsize',12);
    legend('data','fit','Location', 'southeast')
    set(gca,'XTick',FA_ordered)
    ylim([0 maxSI])
    xlim([0 max(FA_ordered)])
  
    if plotFlag==1 
        namePng = strcat('allOrderFits_', num2str(T1_ordered(t)), 'ms.png'); 
        saveas(hF, fullfile(pathOUT, namePng));
    end
    close all;
end

