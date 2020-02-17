% runAssignment5
% group 9, AY2018-2019
%   
% to run:
% > runExercise1_9

clear all;
close all;
clc;

%% Parameters
% File name
inputFile = 'sx5e_historical_data.xls';
% General parameters
numberDaysYear = 256;
formatDate = 'dd/mm/yyyy';
alpha=0.99;

% In order to have human readable results 
format bank

%% Portfolio A Data

timeWindow = 48;
refDate=datenum('5 Jul 08');
todayDate=dateAddMonth(refDate, timeWindow);
sharesList=cellstr(['Total     '; 'Telefonica'; 'ENEL      '; 'Volkswagen']); 
bootstrapM = 300;
numberOfShares=1e3*[25;20;25;15];
[~, returnsSelected] = returnsOfInterest(inputFile, refDate, timeWindow, sharesList, formatDate);
[portfolioValue,prices]=computePortfolioValue(inputFile, todayDate, sharesList, formatDate, numberOfShares);
weights=(numberOfShares.*prices)/portfolioValue;

%% A) Risk Measures

sampledReturns = bootstrapStatistical(bootstrapM, returnsSelected);
[HS_ES, HS_VaR] = HSMeasurements(returnsSelected, alpha, weights, portfolioValue)
[bootstrap_ES, bootstrap_VaR] = HSMeasurements(sampledReturns, alpha, weights, portfolioValue)
PlCh_VaR_A = plausibilityCheck(returnsSelected, weights, alpha, portfolioValue)

%% Protfolio B Data

timeWindow = 48;
sharesList=cellstr(['AXA       '; 'Telefonica'; 'ENEL      '; 'BMW       ';'Schneider ']); 
numberAssets = size(sharesList,1);
numberOfShares = ones(numberAssets,1);
[~, returnsSelected] = returnsOfInterest(inputFile, refDate, timeWindow, sharesList, formatDate);
portfolioValue=1e6;
weights=numberOfShares/numberAssets;
lambda = 0.9;

%% B) Risk Measures

[w_ES, w_VaR] = WHSMeasurements(returnsSelected, alpha, lambda, weights, portfolioValue)
PlCh_VaR_B = plausibilityCheck(returnsSelected, weights, alpha, portfolioValue)

%% Portfolio C Data

refDate=datenum('5 Jul 10');
timeWindow = 24;
sharesList=cellstr(['GdF       '; 'Iberdrola '; 'Inditex   '; 'ING       ';'ISP       ';'Philips   '; 'Oreal     '; 'LVMH      '; 'MunichRe  ';'Nokia     ';'Repsol    '; 'RWE       '; 'Sanofi    '; 'SAP       ';'Schneider ';'Siemens   ';'SocGen    '; 'Telefonica'; 'Total     '; 'Unibail   ';'Unicredit ';'Unilever  '; 'Vinci     '; 'Vivendi   '; 'Volkswagen']);
numberAssets = size(sharesList,1);
numberOfShares = ones(numberAssets,1); 

[tSelected, returnsSelected] = returnsOfInterest(inputFile, refDate, timeWindow, sharesList, formatDate);
portfolioValue=1e6;
weights=numberOfShares/sum(numberOfShares);

yearlyCovariance  = cov(returnsSelected)*numberDaysYear;
yearlyMeanReturns = mean(returnsSelected)*numberDaysYear;
H=10/numberDaysYear;
numberOfPrincipalComponents=4;

%% C) Gaussian

[analytic_ES, analytic_VaR] = AnalyticNormal(yearlyCovariance, yearlyMeanReturns, weights, H, alpha);
analytic_ES = analytic_ES*portfolioValue
analytic_VaR = analytic_VaR*portfolioValue
[pca_ES, pca_VaR] = PrincCompAnalysis(yearlyCovariance, yearlyMeanReturns, weights, H, alpha, numberOfPrincipalComponents, portfolioValue)
PlCh_VaR_C = plausibilityCheck(returnsSelected, weights, alpha, portfolioValue)
