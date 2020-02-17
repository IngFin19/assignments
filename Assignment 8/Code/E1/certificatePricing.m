function Xa = certificatePricing(underlying, certificate, rateCurve, volatilityData)
%certificatePricing(underlying, certificate, rateCurve, volatilityData)
 %function which computes the upfront using a close formula 
 %
 %INPUT
 %  _ underlying = struct containing the data for the underlying
 %  _ certificate = struct containing the contract parameters
 %  _ rateCurve = struct containing dates and discounts
 %  _ volatilityData = cSelect
 %
 %OUTPUT
 %  _ Xa = value of the upfront 
 
    thirty360 = 6;
    act365=3;
    
    %% 
    sigma   = underlying.params(1);
    k       = underlying.params(2);
    eta     = underlying.params(3);
    
    %% date calc
    datepart = 'y';
    numberOfYearIncrement = 1;
    businessdayconvention = 'MF';
    market = eurCalendar;
    couponReset = dateMoveVec(certificate.setDate, datepart, numberOfYearIncrement, businessdayconvention, market);
    timeTocouponReset = yearfrac(certificate.setDate, couponReset, act365);
    
    %% 

    B = queryDiscount(rateCurve.dates,rateCurve.discounts,couponReset);
    forward = underlying.S0/B * exp(-underlying.dividends*timeTocouponReset);
    
    
    %% FFT - Call SPread
    
    M = 15;
    N = 2^M;
    x_1 = -1000;
    dx = -2*x_1/(N-1);
    dz = 2*pi/(N*dx);
    z_1 = -dz*(N-1)/2;
    x_1 = -dx*(N-1)/2;

    param_FFT = struct('M',15,'x_1',-1000,'N',N,'dx',dx,'dz',dz,...
                                     'z_1',z_1,'x_N',-x_1,'z_N',-z_1);
        
    moneyness = log(forward./volatilityData.strikes);
    calls = CallPricesNIGFFT(forward, B, moneyness, timeTocouponReset, sigma, k, eta, param_FFT);
    
    eps = 1;
    prob = (interp1(volatilityData.strikes, calls, certificate.strike-eps)-interp1(volatilityData.strikes, calls, certificate.strike+eps))/(2*eps)/B;
    
    
     
    %% Payoff
    
    datesFloating_1y = floatLegPaymentDates(certificate.setDate,1);
    datesFloating_2y = floatLegPaymentDates(certificate.setDate,2);
    
    B_12 = queryDiscount(rateCurve.dates,rateCurve.discounts,[datesFloating_2y(4),datesFloating_2y(end)]);
    
    BPV_1 = calcBPV(datesFloating_1y,rateCurve.dates,rateCurve.discounts);
    BPV_2 = calcBPV(datesFloating_2y,rateCurve.dates,rateCurve.discounts);
    
    P_1 = certificate.spol*BPV_1+1-B_12(1);
    P_2 = certificate.spol*BPV_2+1-B_12(2);
    
    d1 = yearfrac(certificate.setDate,datesFloating_2y(4),thirty360);
    d2 = yearfrac(datesFloating_2y(4),datesFloating_2y(end),thirty360);
    
    Xa     = (P_1 - B_12(1)*d1*certificate.coupons(1))*(1-prob)+...
              (P_2 - B_12(2)*d2*certificate.coupons(2))*(prob);

end

