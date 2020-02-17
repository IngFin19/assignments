% runAssignment7
% group 9, AY2018-2019
% 
% to run:
% > runExercise2_9

clear all
clc

%% Load Data

formatData='dd/mm/yyyy';
[datesSet, ratesSet] = readExcelData('Data/MktData_CurveBootstrap.xls', formatData);
[dates, discounts] = bootstrap(datesSet, ratesSet);
load('Data/eurostoxx_Poli.mat');

%% contract parameters

moneyness=-0.2:0.01:0.2;
act365 = 3;
maturityDate = datenum('19-Feb-2009');
setDates = datesSet.settlement;
timeToMaturity= yearfrac(setDates,maturityDate,act365);
discount = queryDiscount(dates,discounts,maturityDate);
forward= cSelect.reference*exp(-cSelect.dividends*timeToMaturity)/discount;

%% model\numerical parameters

sigma=0.25;
k=1;
eta=5;

M=17;
x_1=-1000;
N=2^M;
dx=-2*x_1/(N-1);
dz=2*pi/(N*dx);
z_1=-dz*(N-1)/2;
x_1=-dx*(N-1)/2;
x_N=-x_1;
z_N=-z_1;

numericalMethodParameters = struct('M',M,'x_1',x_1,'N',N,'dx',dx,'dz',...
                                    dz,'z_1',z_1,'x_N',x_N,'z_N',z_N);

numberOfSamples=1e6;

%% Prices

pricesFFT = CallPricesNIGFFT(forward, discount, moneyness, timeToMaturity,... 
                                sigma, k, eta,numericalMethodParameters);
                            
pricesQUAD = CallPricesNIGQuadrature(forward, discount, moneyness, timeToMaturity,...
                                sigma, k, eta,numericalMethodParameters);
                
pricesMC = CallPricesNIGMC(forward, discount, moneyness, timeToMaturity,...
                                    sigma, k, eta, numberOfSamples);

%% VG

pricesVG = CallPricesVGFFT(forward, discount, moneyness, timeToMaturity,...
                            sigma, k, eta,numericalMethodParameters);
                        
