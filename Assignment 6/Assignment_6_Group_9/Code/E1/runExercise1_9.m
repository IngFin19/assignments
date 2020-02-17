% runAssignment6
% group 9, AY2018-2019
% 
% to run:
% > runExercise1_Group9

clear all;
close all;
clc;

%% Parameters

% market data
S0_ENI = 12.3;
S0_AXA = 22.1;
corr = 0.49;
sigma_ENI = 0.201;
sigma_AXA = 0.183;
d_ENI = 0.032;
d_AXA = 0.029;
settalmentDate = datenum('15-Feb-2008');
maturityDate = datenum('15-Feb-2013');
partecipationCoefficient = 1.10;
protection = 0.95;
spol = 30*1e-4;
Act365 = 3;
formatData='dd/mm/yyyy';
[datesSet, ratesSet] = readExcelData('Data/MktData_CurveBootstrap.xls', formatData);
[dates, discounts]=bootstrap(datesSet, ratesSet);
rates = zeroRates(dates, discounts);
M = 1e6;

% struct definition
underlyings = struct('S0',[S0_ENI;S0_AXA],...
                    'd',[d_ENI;d_AXA],...
                    'sigma',[sigma_ENI;sigma_AXA],...
                    'corr',corr);

certificate = struct('setDate',settalmentDate,...
                    'maturity',maturityDate,...
                    'alpha',partecipationCoefficient,...
                    'P',protection,...
                    'spol',spol,...
                    'flagYearfrac',Act365);
                
ratesCurve = struct('dates',dates,...
                    'rates',rates);

%%

X = certificatePricing(underlyings, certificate, ratesCurve, M)


