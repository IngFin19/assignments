function [dates,discounts] = shiftCurve(datesSet,ratesSet,dr)
% recomputes the curve with bootstraping after all the rates have being 
% shifted up by a quantity dr
%
%INPUT
%  _ datesSet = struct of dates
%  _ ratesSet =  struct of rates corresponding to datesSet
%  _ dr = quantity to add to rates beforse bootstraping the discount curve
%
%OUTPUT
%  _ dates = dates on which the discount curve is defined
%  _ discounts = discounts of the curve  
% 
%FUNCTION
%  _ bootstrap = function that computes the bootstraping procedure given two struct of
%                dates and rates

shiftedRatesSet = struct('depos',ratesSet.depos + dr,...
                        'futures',ratesSet.futures + dr,...
                        'swaps',ratesSet.swaps + dr);

[dates, discounts]=bootstrap(datesSet, shiftedRatesSet);            

end

