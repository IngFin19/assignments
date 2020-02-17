% runAssignment7
% group 9, AY2018-2019
% 
% to run:
% > runExercise1_9

clear all;
close all;
clc;

%% Read Data

formatData='dd/mm/yy';
[datesSet, ratesSet] = readExcelDis('Data/CapData.xls', formatData);
[capVolatilityData] = readExcelCap( 'Data/CapData.xls', formatData);

%% Bootstrap discount

[dates, discounts] = bootstrap(datesSet, ratesSet);
discountCurve.dates = dates;
discountCurve.discounts = discounts;
% plotDiscountCurve(dates,discounts)

%% Bootstrap vol

capletVolatilities = CapletFromCapVolatilities(capVolatilityData, discountCurve);
capletVolatilityData.surface = capletVolatilities;
capletVolatilityData.strikes = capVolatilityData.strikes;
capletVolatilityData.fixings = capVolatilityData.payment_dates;

%% Certificate 

act360 = 2;
certificate.setDate = datenum('20-Sep-2011');
certificate.maturity = datenum('20-Sep-2017');
certificate.fixingEUR6M = 1.736/100;
certificate.spol = 1.1/100;
certificate.flagYearfrac = act360;

%% Pricing

upfront = certificatePricing(certificate, discountCurve, capletVolatilityData) 
