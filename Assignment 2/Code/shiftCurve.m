function [dates,discounts] = shiftCurve(datesSet,ratesSet,dr)
% recomputes the curve with bootstraping after all the rates have being 
% shifted up by a quantity dr

% datesSet: struct of dates
% ratesSet: struct of rates corresponding to datesSet
% dr: quantity to add to rates beforse bootstraping the discount curve

shiftedRatesSet = struct('depos',ratesSet.depos + dr,...
                        'futures',ratesSet.futures + dr,...
                        'swaps',ratesSet.swaps + dr);

[dates, discounts]=bootstrap(datesSet, shiftedRatesSet);            

end

