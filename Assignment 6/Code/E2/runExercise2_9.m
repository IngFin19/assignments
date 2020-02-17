% runAssignment6
% group 9, AY2018-2019
% 
% to run:
% > runExercise1_9

clear all;
close all;
clc;

%% Discounts

formatData='dd/mm/yyyy';
[datesSet, ratesSet] = readExcelData('Data/MktData_CurveBootstrap.xls', formatData);
[dates, discounts] = bootstrap(datesSet, ratesSet);

%% Parameters

load("Data/eurostoxx_Poli.mat");
notional = 1e7;
act365 = 3;
optionPayoff = 0.05;
setDates = datesSet.settlement;
maturityDate = datenum('18-Feb-2009');
optionTTM = yearfrac(setDates,maturityDate,3);
discount = queryDiscount(dates,discounts,maturityDate);
optionStrike = cSelect.reference;

%% Pricing

[priceBlack,priceSmile] = priceDigital(cSelect, notional, optionPayoff, optionStrike, optionTTM, discount)
