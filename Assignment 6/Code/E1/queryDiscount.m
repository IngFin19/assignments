function B = queryDiscount(dates,discounts,t)
% main function to performe queries on the disc curve.
% 
% if t is in between the start date and end date the 
% function performes interpolation of the 
% discount factor on the curve defined on dates and with correpsonding 
% discounts at a query point t
% calling interpolateDiscount

% if the query point t is greater that the last given date, it performs an 
% extrapolation according to the function
% extrapolateDiscount. See the header to check for limitations in the
% extrapolation procedure,
%
%INPUT
%  _ dates = vector of dates of the already build curve
%  _ discounts = discounts of the already build curve
%
%OUTPUT
%  _ B = discount
% 
%FUNCTION
%  _ zeroRate = function that computes the log zero rates according to the
%               act365 daycount convention.


act365 = 3;
t0=dates(1);
zRates = zeroRates(dates, discounts);
y = interp1(dates(2:end),zRates(2:end),t,'linear','extrap');
B = exp(-yearfrac(t0, t, act365).*y/100);

end