function [ES, VaR, CES, CVaR]=AnalyticMeasurements(V,mu,w,H,alpha,dof,flagModel)
% Analytic Measurements
%
% INPUTS:
%  V:     Covariance matrix (yearly volatilities)
%  mu:    (Yearly) Expected returns (column vector) 
%  w:     Portfolio weights (column vector)
%  h:     time lag (in yearfrac: e.g. 1/52 for 1w)
%  alpha: e.g. 0.99
%  dof:   degrees of freedom (only used in t-Student)
%  flagModel: selects model. 1: Normal, 2: t-Student 
%
% OUTPUTS:
%  VaR, ES
%  ContributionVaR, ContributionES

%% Initial check
numFactors=max(size(w));
if ((numFactors ~= max(size(V)))|| numFactors ~= max(size(mu)))
    error('Error: dimensions do not match');
end

if ((alpha < 0)|| (alpha > 1))
    error('Error: not a proper level of confidence');
end

if (nargin<6)
    dof = 4;
end

if ( dof < 1)
    error('Error: degrees of freedom must be > 1');
end

if (nargin<7)
    flagModel = 1;
end

%% Measurement computations
switch (flagModel)
    case 1  % Normal
        [ES, VaR]=AnalyticNormal(V,mu,w,H,alpha);
    case 2  % t-Student
        [ES, VaR]=AnalyticTstudent(V,mu,w,H,alpha,dof);
    otherwise
end

end
 
