function [corrFact_1, corrFact_2,corr_field, B1_tx_corrected, B1_corrected, maskGoodness] = calculateB1correction(img_ori,T1map,polyModel7,FAmap,B1_rx,mask,plotFlag)
% This correction method uses a signal intensity model of the RARE MR
% imaging sequence to compute the correction factors necessary to correct
% for B1+ and B1- inhomogeneities 
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
% INPUT:
%%%% img_ori    : image to be corrected
%%%% T1map      : T1 map of image to be corrected
%%%% polyModel7 : contains the RARE signal intensity model (7th order)
%%%% FAmap      : FA map (Tx)
%%%% B1_rx      : B1- map (Rx)
%%%% mask       : contains mask of pixels to be corrected
%%%% plotFlag   : 1 (plot), 0 (no plot)
%
% OUTPUT:
%%%% corrFact_1 : correction factor 1 (SI=f(FA,T1))
%%%% corrFact_2 : correction factor 2 (SI=f(90,T1))
%%%% corr_field : correction field (corrFact_2/corrFact_1)
%%%% B1_tx_corrected : B1+ corrected image
%%%% B1_corrected : B1+ & B1- corrected image
%%%% maskGoodness : mask with wrong pixels due to the damping in the signal 
%                   intensity model for high orders
%
%
% April 2020
% Paula Ramos Delgado
% ramosdelgado.paula@gmail.com
%

%% Prior calculations

FArel = FAmap .* 90 ./ 60; % Relative FA map

% mask of goodness 
maskGoodness = (img_ori.*mask)~=0; 
maskGoodness = double(maskGoodness);
maskGoodness(maskGoodness==0) = NaN;


%% Correction Factor 1 - SI=f(FA,T1)

nx = size(img_ori,1);
ny = size(img_ori,2);

corrFact_1 = zeros(nx,ny);

for x = 1:nx
    for y = 1:ny

        T1_act = T1map(x,y);
        FA_act = FArel(x,y);

        if (T1_act==0)||(FA_act==0)
            corrFact_1(x,y) = 0;
        else
            corrFact_1(x,y) = polyvaln(polyModel7,[T1_act, FA_act]); 

            if corrFact_1(x,y)<0
                maskGoodness(x,y)=0.5;
            end           
        end

    end
end


if plotFlag == 1
    figure(), 
    subplot(121), imagesc(squeeze(corrFact_1),[0 180]); colormap(jet(256)), colorbar; shg;set(gca,'XTick',[]); set(gca,'YTick',[]);
    title('Correction factor 1')
    
    subplot(122), imagesc(squeeze(maskGoodness),[0 1]); colormap(jet(256)), colorbar; shg;set(gca,'XTick',[]); set(gca,'YTick',[]);
    title('Mask of Goodness after correction factor 1')
end

%% Correction Factor 2 - SI=f(90,T1)

FAmap_90 = FAmap;
FAmap_90(FAmap~=0) = 90;

corrFact_2 = zeros(nx,ny);

for x = 1:nx
    for y = 1:ny

        T1_act = T1map(x,y);
        FA_act = FAmap_90(x,y);

        if (T1_act==0)||(FA_act==0)
            corrFact_2(x,y) = 0;
        else
            corrFact_2(x,y) = polyvaln(polyModel7,[T1_act, FA_act]); 
            
            if corrFact_2(x,y)<0
                maskGoodness(x,y)=0.5;
            end
            
        end

    end
end

if plotFlag == 1
    figure(), 
    subplot(121), imagesc(squeeze(corrFact_2),[0 180]); colormap(jet(256)), colorbar; shg;set(gca,'XTick',[]); set(gca,'YTick',[]);
    title('Correction factor 2')
    
    subplot(122), imagesc(squeeze(maskGoodness),[0 1]); colormap(jet(256)), colorbar; shg;set(gca,'XTick',[]); set(gca,'YTick',[]);
    title('Mask of Goodness after correction factor 2')
end

%% Correction field 

corr_field = corrFact_2 ./ corrFact_1;

if plotFlag == 1
    figure(), 
    subplot(121), imagesc(squeeze(corr_field),[0 2]); colormap(jet(256)), colorbar; shg;set(gca,'XTick',[]); set(gca,'YTick',[]);
    title('Correction field')
    
    subplot(122), imagesc(squeeze(maskGoodness),[0 1]); colormap(jet(256)), colorbar; shg;set(gca,'XTick',[]); set(gca,'YTick',[]);
    title('Mask of Goodness')
end


%% B1+ corrected image
B1_tx_corrected = img_ori .* corr_field;

if plotFlag == 1
    figure(), 
        subplot(131),imagesc(img_ori,[0 2e8]); colormap(gray(256)), title('Original image')
        subplot(132),imagesc(corr_field,[0 20]); colormap(jet(256)), title('Correction field')
        subplot(133),imagesc(B1_tx_corrected,[0 2e8]); title('B1+ corrected image')
end

%% B1- corrected image
B1_corrected = B1_tx_corrected ./ B1_rx;
B1_corrected(B1_corrected==-Inf) = 0;

if plotFlag == 1
    figure(), 
        subplot(131),imagesc(img_ori,[0 2e8]); colormap(gray(256)), title('Original image')
        subplot(132),imagesc(squeeze(B1_tx_corrected),[0 2e8]); colormap(gray(256)), title('B1+ corrected image')
        subplot(133),imagesc(squeeze(B1_corrected),[0 2e8]); colormap(jet(256)); title('B1 corrected image')
end 

end

