%%% runAssignment5
% group 9, AY2018-2019
% 
% to run:
% > runExercise2_9

clear all
close all
clc
format short

%% Parameters and input functions

% File name
inputFile = 'sx5e_historical_data.xls';

% General parameters
formatDate = 'dd/mm/yyyy';
alpha=0.99;
numberOfDaysInYear = 256;
riskMeasureTimeIntervalInYears=10/numberOfDaysInYear;
N=1913220;

% Time parameters
initial_date=datenum('14 Sep 2007'); 
today_date=datenum('14 Sep 2009');
put_expiry_date=datenum('16 Nov 2009');

% Put Parameters
act365 = 3;
timeToMaturityInYears=yearfrac(today_date,put_expiry_date,act365);
strike=23;
volatility=0.214;
rate=0.038;
dividend=0.051;

% Loading data
[stockPrice,logReturns] = loadData(initial_date,today_date,numberOfDaysInYear,formatDate,riskMeasureTimeIntervalInYears);

numberOfShares=N/stockPrice;
numberOfPuts=N/stockPrice;

%% Full monte carlo

VaR = FullMonteCarloVaR(logReturns, numberOfShares, numberOfPuts, stockPrice, strike, rate, dividend, volatility, timeToMaturityInYears, riskMeasureTimeIntervalInYears, alpha)

%% Polynomial Approximation Approach

VaR_Delta  = DeltaNormalVaR(logReturns, numberOfShares, numberOfPuts, stockPrice, strike, rate, dividend, volatility, timeToMaturityInYears, riskMeasureTimeIntervalInYears, alpha)
VaR_Gamma  = GammaNormalVar(logReturns, numberOfShares, numberOfPuts, stockPrice, strike, rate, dividend, volatility, timeToMaturityInYears, riskMeasureTimeIntervalInYears, alpha)
VaR_Higher = HigherNormalVar(logReturns, numberOfShares, numberOfPuts, stockPrice, strike, rate, dividend, volatility, timeToMaturityInYears, riskMeasureTimeIntervalInYears, alpha)

