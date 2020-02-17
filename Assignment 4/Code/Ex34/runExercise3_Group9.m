% Risk Measurements of a Linear Portfolio
% Financial Engineering: Politecnico Milano
% 
%
% In order to run the script:
% >> runExercise3
%
% Last Modified: 19.03.2017

clc;
clear all;

%% Parameters
% File name
inputFile = 'sx5e_historical_data.xls';
% General parameters
numberDaysYear = 256;
formatDate = 'dd/mm/yyyy';
alpha=0.99;

% Input parameters
refDate=datenum('4 Jul 09'); 
timeWindow = 36;
sharesList=cellstr(['Generali '; 'AXA      '; 'Santander'; 'Bayer    ']); 
numberAssets = size(sharesList,1);
w=0.25*ones(numberAssets,1);
bootstrapM = 400;
H = 1/numberDaysYear;

%% Select returns of interest
[tSelected, returnsSelected] = returnsOfInterest(inputFile, refDate, timeWindow, sharesList, formatDate);

%% Analytic VaR & ES (Normal)
% Compute dayly Pearson correlation 
%         yearly mean mu, yearly VarCovar V

V  = cov(returnsSelected)*numberDaysYear;
mu = mean(returnsSelected)*numberDaysYear;

% Compute Measurements
try
    [ES, VaR] = AnalyticMeasurements(V,mu,w,H,alpha)
catch err
    err.message
end


