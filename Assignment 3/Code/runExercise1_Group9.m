% runAssignment3
% group 9, AY2018-2019
% 
% to run:
% > runExercise1_9

clear all;
close all;
clc;

%% Read market data

formatData='dd/mm/yyyy';
[datesSet, ratesSet] = readExcelData('Data/MktData_CurveBootstrap.xls', formatData);

%% P&L impact for an IRS (1. Case study)
% dates includes SettlementDate as first date
[dates, discounts]=bootstrap(datesSet, ratesSet);
N = 100*10^6;
internalMid = 4.06/100;
tardedPrice = 4.045/100;
marketMid = 4.042/100;

dr = internalMid-marketMid;

[NPV_mkt] = ProfitandLoss(N,dates,datesSet,discounts,internalMid,tardedPrice);
[~,B_eval] = shiftCurve(datesSet,ratesSet,dr);
[NPV_approx] = ProfitandLoss(N,dates,datesSet,B_eval,internalMid,tardedPrice);
error = NPV_mkt - NPV_approx %compute the error
