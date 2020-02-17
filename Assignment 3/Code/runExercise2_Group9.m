% runAssignment3
% group 9, AY2018-2019
% 
% to run:
% > runExercise2_9

clear all;
close all;
clc;

%% Market Data

Bondprice = 0.98;
coupon = 0.046;
formatData='dd/mm/yyyy';
[datesSet, ratesSet] = readExcelData('Data/MktData_CurveBootstrap.xls', formatData);
[dates, discounts]=bootstrap(datesSet, ratesSet);

%% Asset Swap (2. Exercise)

settlementDate=datesSet.settlement;
fixedLegPaymentDates = datesSet.swaps(1:3);
[floatLegPaymentDates] = calcfloatLegPaymentDates(datesSet);
[ Spread ] = CalculateAssetSwapSpread(settlementDate,coupon,Bondprice,fixedLegPaymentDates,floatLegPaymentDates,dates,discounts)
