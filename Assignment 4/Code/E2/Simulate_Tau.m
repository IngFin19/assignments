function [t] = Simulate_Tau(Nsim,dates,spreadsCDS,datesCDS,discounts,datesPayoff,SetDate,recovery)
%function that simulate credit events times with intensities bootstrapped
%from CDS spreads
% 
%INPUT 
%  _ Nsim = number of simulations 
%  _ dates = dates on which the discount curve is defined
%  _ spreadsCDS = CDS market spreads
%  _ datesCDS = CDS payment dates 
%  _ discounts = discounts of the curve
%  _ datesPayoff = vector of payment dates for the option
%  _ SetDate = settlement date 
%  _ recovery = recovery rate of the underlying contract
%
%OUTPUT
%  _ t = credit events times
%
%FUNCTION
%  _ bootstrapCDS = Infers survival probabilities and intensity from term structure

rng(1);
[~, survProbs] = bootstrapCDS(dates, discounts, datesCDS, spreadsCDS, 1, recovery);
u = rand(Nsim,1);
u = [u;1-u]; %AV
t = round(interp1(survProbs,datesCDS,u,'linear','extrap'));
end