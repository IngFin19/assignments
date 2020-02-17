function discounts = zeroRatesToDiscount(dates, zrates)
    % computes the continuosly comp. zero rate corresponding to the
    % discounts gives
    % 
    % dates: vector of dates
    % discounts: vector of discounts
    
    % basis for yearfrac
    act365=3; 
    discounts = exp(-yearfrac(dates(1), dates,act365).*zrates/100);
    discounts(1) = 1;
end


