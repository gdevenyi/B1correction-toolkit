%% [ fittedData, p ] = fitDataWithPolynomeFAT1_PRD( data, polyOrder, mask, FA, T1)
%
% Fits 2D or 3D input data with a polynome of given order to create a
% signal intensity model of the form: SI=f(FA_ordered,T1)
%
% This code uses a modified version of polyfitn available as:
%
% John D'Errico (2018). polyfitn
% https://www.mathworks.com/matlabcentral/fileexchange/34765-polyfitn)
% MATLAB Central File Exchange
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
%%%% data : contains the SIs and FA_ordereds obtained from the measurements
%%%%        in a matrix (FA_ordered,SI) (rows,cols) --> SI_ordered
%%%% polyOrder : order of the polynomial 
%%%% mask : mask of 1s
%%%% FA : is an ordered array with the FA_ordereds used for the 
%%%%      measurements --> FA_ordered
%%%% T1 : is an ordered array with the T1 relaxation times of the 
%%%%      solutions filling the NMR tubes --> T1_ordered
%
% OUTPUT:
%%%% fittedData : contains a matrix (FA_ordered,SI) (rows,cols) with the
%%%%              fitted data 
%%%% p  : structure that contains the regression model
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

function [ fittedData, p ] = fitDataWithPolynomeFAT1_PRD( data, polyOrder, mask, FA, T1)

    if nargin < 3 
        mask = ones(size(data),'logical');
    elseif nargin < 2
        polyOrder = 3;
    end
     % prepare fit
        % define coordinate grid
        X = repmat(FA',[length(T1),1]);
        Y = repmat(T1,length(FA));
        Y(:,length(T1)+1:end) = [];
        Y = Y(:);

        % exclude voxels not covered by mask from fit
        exclude =~ mask;        
        exclude = exclude(:);
        Y = Y(:); Y(exclude) = [];
        X = X(:); X(exclude) = [];
        
        % prepare matrices for fit
        x = [Y(:),X(:)];
        t = data(:);
        t(exclude) = [];

        p = polyfitn(x,t,polyOrder);
        
        % evaluate polynomial on grid and reshape to original size
        X = reshape(X,[length(FA) length(T1)]);
        Y = reshape(Y,[length(FA) length(T1)]);
        fittedData = polyvaln(p,[Y(:),X(:)]);
        fittedData = reshape(fittedData,[length(FA) length(T1)]);

end

