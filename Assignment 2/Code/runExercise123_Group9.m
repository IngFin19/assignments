% runAssignment2
% group 9, AY2018-2019
% Computes Euribor 3m bootstrap with a single-curve model
%
% to run:
% > runExercise123_9

clear all;
close all;
clc;

%% Settings
formatData='dd/mm/yyyy'; %Pay attention to your computer settings 

%% Read market data

[datesSet, ratesSet] = readExcelData('Data/MktData_CurveBootstrap.xls', formatData);

%% Bootstrap (Exercise 1)
% dates includes SettlementDate as first date

[dates, discounts]=bootstrap(datesSet, ratesSet);

%% Compute Zero Rates

zRates = zeroRates(dates, discounts);

%% Plot Results

plotDiscountCurve(dates,discounts)

%% Swap sensitivity (Exercise 2)

fixedRate = 0.04032;
fixedLegPaymentDates = datesSet.swaps(1:5);
setDate = datesSet.settlement;
[DV01, BPV, DV01_z] = sensSwap(setDate, fixedLegPaymentDates, fixedRate, dates, discounts)

%% I.B. Bond 

couponPaymentDates = datesSet.swaps(1:5);
Mac = sensCouponBond(setDate, couponPaymentDates, fixedRate, dates, discounts)

%% I.B. coupon bond (Exercise 3)

fixedRate = 0.04042;
bondPrice = calcBondPrice(setDate,couponPaymentDates,fixedRate,dates,discounts)
