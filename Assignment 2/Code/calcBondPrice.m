function [bondPrice,coupons,original_discount] = calcBondPrice(setDate,couponPaymentDates,fixedRate,dates,discounts)
    % computes the bond price of a fixed coupon bond given the discount curve,
    % settlement date, coupon payment date and the rate
    %
    % setDate: current date
    % fixedLegPaymentDates: coupon payment dates
    % fixedRate: fixed coupon rate of the swap
    % dates: dates of the discount curve
    % discounts: discounts factors defined on dates
    
    thirty360 = 6;
    coupons = fixedRate * ones(size(couponPaymentDates));
    original_discount = zeros(size(couponPaymentDates));
    intradate_yearfrac = yearfrac([setDate;couponPaymentDates(1:end-1)],...
        couponPaymentDates,thirty360);

    coupons = coupons.*intradate_yearfrac;
    coupons(end) = coupons(end) + 1;

    for i=1:length(couponPaymentDates)
        original_discount(i) = queryDiscount(dates,discounts,couponPaymentDates(i));
    end

    bondPrice = original_discount'*coupons;

end

