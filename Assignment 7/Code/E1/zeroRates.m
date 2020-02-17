function zRates = zeroRates(dates, discounts)
    % zRates = zeroRates(dates, discounts)
    %
    % computes the continuosly comp. zero rate corresponding to the
    % discounts gives
    %
    % First value in zRates would be nan since the istantaneous zero rate
    % from t0 to t0 is not defined.
    % 
    %INPUT
    %  _ dates = vector of dates
    %  _ discounts = vector of discounts
    %
    %OUTPUT
    %  _ zRates = zero rates 
    

    % basis for yearfrac
    act365=3;
    
    % zero rate
    zRates = -log(discounts)./yearfrac(dates(1), dates,act365)*100;
end

