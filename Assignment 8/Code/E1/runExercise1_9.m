% runAssignment 8
% group 9, AY2018-2019
% 
% to run:
% > runExercise1_9

clear all;
close all;
clc;

%% Load Data and Bootstrap

formatData ='dd/mm/yyyy';
[datesSet, ratesSet] = readExcelData('Data/MktData_CurveBootstrap.xls', formatData);
[dates, discounts] = bootstrap(datesSet, ratesSet);
rateCurve.dates = dates;
rateCurve.discounts = discounts;

%% Calibration....

load('Data/eurostoxx_Poli.mat');
volatilityData=cSelect;

%% NIG params

sigma   = 0.1742;
k       = 0.4553;
eta     = 10.1836;
underlying.params = [sigma,k,eta];
underlying.S0 = cSelect.reference;
underlying.dividends       = cSelect.dividends;
underlying.strikes = cSelect.strikes;
underlying.surface = cSelect.surface;
%% Contract parameters

certificate.setDate         = datesSet.settlement;
certificate.maturityDate    = datenum('19-Feb-2010');
certificate.spol            = 0.012;
certificate.coupons         = [0.04;0.02];
certificate.trigger         = 0.04;
certificate.strike          = 3200;

%% Upfront pricing using NIG model

Xa   = certificatePricing(underlying, certificate, rateCurve, volatilityData)

%% Upfront pricing using Black adjusted 

Xb   = certificatePricingBlackAdjusted(certificate, rateCurve, cSelect)

%% Upfront pricing using Black

Xc   = certificatePricingBlack(certificate, rateCurve, cSelect)
errorBlack=abs(Xa-Xc)

%% Upfront pricing using NIG model for three years 

numberOfSamples = 10e5;

Xe   = certificatePricingNIG(underlying, certificate, rateCurve, numberOfSamples)
