function [swaption] = Swaption_HW_ATM(D1,D2,rateCurve,sigma,a)
    % Function that compute the swaption price with Jamshidian Formula
    % 
    %INPUT
    %  _ D1 = maturity of the swaption
    %  _ D2 = maturity of the swap
    %  _ rateCurve = Discount curve
    %  _ sigma = model param
    %  _ a = mean reverting param
    %OUTPUT
    %  _ swaptions = price of the swaption 
    
    act365 = 3;
    thirty360 = 3;
    
    %% dates
    datepart = 'y';
    businessdayconvention = 'MF';
    market = eurCalendar;
    setDate = rateCurve.dates(1);
    ta  = dateMoveVec(setDate, datepart, D1, businessdayconvention, market);
    tw  = dateMoveVec(setDate, datepart, D1+D2, businessdayconvention, market);
    couponsPaymentDates = paymentDates(ta,D2);
    
    %% yearfrac
    dt_a = yearfrac(setDate, ta, thirty360);
    dt_0i= yearfrac(setDate, couponsPaymentDates, thirty360); 
    
    % discounts
    Ba = queryDiscount(rateCurve.dates, rateCurve.discounts, ta);
    B0i = queryDiscount(rateCurve.dates, rateCurve.discounts, couponsPaymentDates)/Ba;
    
    % strike ATM
    BPV = calcBPV_fwd(ta, couponsPaymentDates, rateCurve.dates, rateCurve.discounts);
    strike = (1-B0i(end))/BPV;
    
    %% ZCB puts
    coupons = strike*ones(length(couponsPaymentDates),1);
    coupons(end)=coupons(end)+1;
    
    Ki = Strikes(a,sigma,ta,couponsPaymentDates,coupons,rateCurve);
    
    sigma_HW = @(t1,t2) sigma/a*(1-exp(-a*(t2-t1)));
    sigma_call = integral(@(u) 1/dt_a*(sigma_HW(u,dt_0i)-sigma_HW(u,dt_a)).^2,0,dt_a,'ArrayValued',true);
    ra = -log(Ba)./dt_a;    
    [~,puts] = blkprice(B0i,Ki,ra,dt_a,sqrt(sigma_call));
    
    swaption = (puts)'*coupons;
    
end

