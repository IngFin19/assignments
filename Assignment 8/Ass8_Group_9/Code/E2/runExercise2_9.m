% runAssignment 8
% group 9, AY2018-2019
% 
% to run:
% > runExercise2_9

clear all;
close all;
clc;

%% Load Data and Bootstrap

formatData ='dd/mm/yyyy';
[datesSet, ratesSet] = readExcelData('Data/MktData_CurveBootstrap.xls', formatData);
[dates, discounts] = bootstrap(datesSet, ratesSet);
rateCurve.dates = dates;
rateCurve.discounts = discounts;

setDate = rateCurve.dates(1);

%% HW params

a = 10/100;
sigma = 1/100;
M = 40;

%% 2x8

D1 = 2;
D2 = 8;
swaption_2y8y   = Swaption_HW_ATM(D1,D2,rateCurve,sigma,a)
swaption_2y8y_T = Tree_Swaption(D1,D2,rateCurve,sigma,a,M)

%% 5x5

D1 = 5;
D2 = 5;
swaption_5y5y   = Swaption_HW_ATM(D1,D2,rateCurve,sigma,a)
swaption_5y5y_T = Tree_Swaption(D1,D2,rateCurve,sigma,a,M)
