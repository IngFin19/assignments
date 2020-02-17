function [price,B] = forward_Bond_HW(x,a,sigma,start_date,cuponsDates,coupon,rateCurve)
    % Function that compute the sforward bond price
    % 
    %INPUT
    %  _ x = OU variable
    %  _ start_date = forward staarting date
    %  _ cuponsDates = dates for the coupons
    %  _ rateCurve = Discount curve
    %  _ sigma = model param
    %  _ a = mean reverting param
    %OUTPUT
    %  _ price = price of the bond
    %  _ B = bond used in the BPV
    
    %% yearfrac
    thirt360 = 6;
    setDate = rateCurve.dates(1);
    dt_ai = yearfrac(start_date, cuponsDates, thirt360);
    dt_i = yearfrac(setDate, cuponsDates, thirt360); 
    dt_a = yearfrac(setDate, start_date, thirt360); 
    dt_ii= yearfrac([start_date;cuponsDates(1:end-1)], cuponsDates, thirt360); 
    
    %% fwd disc
    Ba = queryDiscount(rateCurve.dates, rateCurve.discounts, start_date);
    B0i = queryDiscount(rateCurve.dates, rateCurve.discounts, cuponsDates)/Ba;
    sigma_HW = @(t1,t2) sigma/a*(1-exp(-a*(t2-t1)));
    B = B0i.*exp(-x/sigma.*sigma_HW(0,dt_ai)- ...
        0.5 * integral(@(u) (sigma_HW(u,dt_i).^2-sigma_HW(u,dt_a).^2),0,dt_a,'ArrayValued',true));
    
    %% bond price
    price = sum(coupon.*B.*dt_ii);
end

