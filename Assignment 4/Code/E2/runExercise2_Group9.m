% runAssignment4
% group 9, AY2018-2019
% 
% to run:
% > runExercise2_9

clear all;
close all;
clc;

%% Market Data

formatData='dd/mm/yyyy';
[datesSet, ratesSet] = readExcelData('Data/MktData_CurveBootstrap.xls', formatData);
[dates, discounts]=bootstrap(datesSet, ratesSet);

%% Counterparty risk Data

Nsim = 5e5;
SetDate=datesSet.settlement;
sigma=0.2;
recovery =0.3;
[datesPayoff]= calcdates(datesSet);
spreadsCDS = 1e-4*[28;31;34;37;39];
datesCDS = datesSet.swaps(1:5);

%% Counterparty risk 

price_no_ctp = price_no_ctp_risk(sigma,Nsim,SetDate,datesPayoff,dates,discounts)

price_ctp = price_ctp_risk(sigma,Nsim,SetDate,datesPayoff,dates,discounts,recovery,spreadsCDS,datesCDS)
