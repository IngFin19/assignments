function Xe = certificatePricingNIG(underlying, certificate, rateCurve, numberOfSamples)
 %certificatePricingNIG(underlying, certificate, rateCurve, numberOfSamples)
 %function which computes the upfront using the NIG model 
 %
 %INPUT
 %  _ underlying = struct containing the data for the underlying
 %  _ certificate = struct containing the contract parameters
 %  _ rateCurve = struct containing dates and discounts
 %  _ numberOfSamples = number of samples 
 %
 %OUTPUT
 %  _ Xe = value of the upfront 
 
    thirty360 = 6;
    act365=3;
    %% 
    sigma   = underlying.params(1);
    k       = underlying.params(2);
    eta     = underlying.params(3);
    %% date calc first year and second year 
    datepart = 'y';
    numberOfYearIncrement =1 ;
    businessdayconvention = 'MF';
    market = eurCalendar;
    couponReset1 = dateMoveVec(certificate.setDate, datepart, numberOfYearIncrement, businessdayconvention, market);
    timeTocouponReset1 = yearfrac(certificate.setDate, couponReset1, act365);
    
    datepart = 'y';
    numberOfYearIncrement =2 ;
    businessdayconvention = 'MF';
    market = eurCalendar;
    couponReset2 = dateMoveVec(certificate.setDate, datepart, numberOfYearIncrement, businessdayconvention, market);
    timeTocouponReset2 = yearfrac(certificate.setDate, couponReset2, act365);
    
    %% Simulation
    B1 = queryDiscount(rateCurve.dates,rateCurve.discounts,couponReset1);
 
    forward1 = underlying.S0/B1*exp(-timeTocouponReset1*underlying.dividends);
    
    dt=yearfrac(couponReset1, couponReset2, act365);
    timeTocouponReset=[dt,timeTocouponReset2-timeTocouponReset1];
    
    S_T = SimulateNIG(forward1, timeTocouponReset, sigma, k, eta, numberOfSamples);
    
    S_T2=S_T(:,2);
    
    B2=queryDiscount(rateCurve.dates,rateCurve.discounts,couponReset2);
    S_T1=S_T(:,1)*B2/(exp(-underlying.dividends*dt)*B1);
    
    
    %% Payoff
    datesFloating_1y = floatLegPaymentDates(certificate.setDate,1);
    datesFloating_2y = floatLegPaymentDates(certificate.setDate,2);
    datesFloating_3y = floatLegPaymentDates(certificate.setDate,3);
    
    B_123 = queryDiscount(rateCurve.dates,rateCurve.discounts,[datesFloating_3y(4),datesFloating_3y(8),datesFloating_3y(end)]);
    
    BPV_1 = calcBPV(datesFloating_1y,rateCurve.dates,rateCurve.discounts);
    BPV_2 = calcBPV(datesFloating_2y,rateCurve.dates,rateCurve.discounts);
    BPV_3=calcBPV(datesFloating_3y,rateCurve.dates,rateCurve.discounts);
    
    P_1 = certificate.spol*BPV_1+1-B_123(1);
    P_2 = certificate.spol*BPV_2+1-B_123(2);
    P_3=certificate.spol*BPV_3+1-B_123(3);
    
    d1 = yearfrac(certificate.setDate,datesFloating_2y(4),thirty360);
    d2 = yearfrac(datesFloating_2y(4),datesFloating_2y(end),thirty360);
    d3 = yearfrac(datesFloating_3y(8),datesFloating_3y(end),thirty360);
    
    NPV     = (P_1 - B_123(1)*d1*certificate.coupons(1))*(S_T1 < certificate.strike)+...
            (P_2 - B_123(2)*d2*certificate.coupons(1))*(S_T1 > certificate.strike).*(S_T2 < certificate.strike)+...
            (P_3 - B_123(3)*d3*certificate.coupons(2))*(S_T1 > certificate.strike).*(S_T2 > certificate.strike);
    
    Xe= mean(NPV);
end

