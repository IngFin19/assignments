function [S] = Simulate_Levels(sigma,Nsim,datesDF,discounts,datesPayoff,SetDate)
%function that simulate the underlying prices using the Monte Carlo method with antithetic variables 
%
%INPUT
%  _ sigma = volatility
%  _ Nsim = number of simulations
%  _ datesDF = dates on which the discount curve is defined
%  _ discounts = discounts of the curve
%  _ datesPayoff = vector of payment dates for the option
%  _ SetDate = settlement date
% 
%OUTPUT
%  _ S = matrix of the underlyng prices 
%
%FUNCTION
%  _ queryDiscount = main function to performe queries on the disc curve.
%                    if t is in between the start date and end date the 
%                    function performes interpolation of the discount factor 
%                    on the curve defined on dates and with correpsonding 
%                    discounts at a query point t calling interpolateDiscount
%                    if the query point t is greater that the last given date, 
%                    it performs an extrapolation according to the function
%                    extrapolateDiscount.

F0=1;
rng(1);
thirty360 = 6;
yearfractions = yearfrac([SetDate;datesPayoff(1:end-1)],datesPayoff,thirty360)';
Z = randn(Nsim,length(datesPayoff));
Nsim = Nsim*2;
Z = [Z;-Z]; %AV
drift = (-0.5*sigma^2) * yearfractions;
diffusion = sigma*sqrt(yearfractions);
F = F0*cumprod(exp(drift + diffusion .* Z),2);
B = queryDiscount(datesDF,discounts,datesPayoff);
S=F./B';
S = [ones(Nsim,1)*F0*queryDiscount(datesDF,discounts,SetDate),S];