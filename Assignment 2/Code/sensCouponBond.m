function MacD = sensCouponBond(setDate, couponPaymentDates, fixedRate, dates, discounts)
    % computes Macaulay duration for a fixed coupon bond 

    % setDate: current date
    % fixedLegPaymentDates: coupon payment dates
    % fixedRate: fixed coupon rate of the swap
    % dates: dates of the discount curve
    % discounts: discounts factors defined on dates
        
    % bond price and Macaulay
    act365 = 3;
    [bondPrice,coupons,disc] = calcBondPrice(setDate,couponPaymentDates,fixedRate,dates,discounts);
    year_fraction_payment_dates = yearfrac(setDate,couponPaymentDates,act365);
    MacD = year_fraction_payment_dates'*(disc.*coupons)/bondPrice;
    
end

