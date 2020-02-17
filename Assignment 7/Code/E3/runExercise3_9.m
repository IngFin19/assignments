% runAssignment7
% group 9, AY2018-2019
% 
% to run:
% > runExercise3_9

clear all
clc

%% Parameters

formatData='dd/mm/yyyy';
[datesSet, ratesSet] = readExcelData('Data/MktData_CurveBootstrap.xls', formatData);
[dates, discounts] = bootstrap(datesSet, ratesSet);
discountCurve=struct('dates', dates,'discounts' ,discounts); 

load('Data/eurostoxx_Poli.mat');
volatilityData=cSelect;

%% Calibration

[sigma, k, eta] = CalibrateNIGToVolatilitySurface(volatilityData, discountCurve)

%% prices compare

maturityDate = datenum('19-Feb-2009');
act365 = 3;
timeToMaturity= yearfrac(discountCurve.dates(1), maturityDate, act365);
discount = queryDiscount(discountCurve.dates, discountCurve.discounts, maturityDate);
rate = -log(discount)/timeToMaturity;
forward_price = volatilityData.reference*exp((rate-volatilityData.dividends)*timeToMaturity);
moneyness = log(forward_price./volatilityData.strikes);

M = 15;
N = 2^M;
x_1 = -1000;
dx = -2*x_1/(N-1);
dz = 2*pi/(N*dx);
z_1 = -dz*(N-1)/2;
x_1 = -dx*(N-1)/2;

param_fftnumericalMethodParameters = struct('M',15,'x_1',-1000,'N',N,'dx',dx,'dz',dz,...
                                 'z_1',z_1,'x_N',-x_1,'z_N',-z_1);

calibrated_prices = CallPricesNIGFFT(forward_price, discount, moneyness, timeToMaturity, sigma, k, eta, param_fftnumericalMethodParameters);

call_blk = blkprice(forward_price, volatilityData.strikes, rate, timeToMaturity, volatilityData.surface);


%% plot 

figure
subplot(1,2,1)
plot(moneyness,call_blk,'*-')
hold on
plot(moneyness,calibrated_prices,'d-')
grid on
impv_vol = blkimpv(forward_price, volatilityData.strikes, rate, timeToMaturity, calibrated_prices);
xlabel('Moneyness')
ylabel('Prices')
legend('call blk','calibrated prices')
subplot(1,2,2)
plot(moneyness,volatilityData.surface,'*-')
hold on
plot(moneyness,impv_vol,'d-')
grid on
xlabel('Moneyness')
ylabel('Volatilities')
legend('Model vol','Market vol')


