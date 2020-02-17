% runAssignment3
% group 9, AY2018-2019
% 
% to run:
% > runExercise123_9

clear all;
close all;
clc;

%% Read market data

formatData='dd/mm/yyyy';
[datesSet, ratesSet] = readExcelData('Data/MktData_CurveBootstrap.xls', formatData);
spreadsCDS = 1e-4*[28;31;34;37;39];

%% Bootstrap (Exercise 1)
% dates includes SettlementDate as first date

[datesDF, discounts]=bootstrap(datesSet, ratesSet);

%% 3. CDS Bootstrap

datesCDS = datesSet.swaps(1:5);
recovery = 0.3;
SetDate = datesSet.settlement;
flag = 1; % 1 w/o accrual, 2 with accrual, 3 JT
[datesCDS, survProbs1, intensities1] = bootstrapCDS(datesDF, discounts, datesCDS, spreadsCDS, 1, recovery);
[datesCDS, survProbs2, intensities2] = bootstrapCDS(datesDF, discounts, datesCDS, spreadsCDS, 2, recovery);
[datesCDS, survProbs3, intensities3] = bootstrapCDS(datesDF, discounts, datesCDS, spreadsCDS, 3, recovery);

%% Plot Results

plot_intensities(SetDate,datesCDS,intensities1,intensities2,intensities3)
plot_probability(SetDate,datesCDS,survProbs1,survProbs2,survProbs3)
