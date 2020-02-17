function Xb = certificatePricingBlackAdjusted(certificate, rateCurve,cSelect)
%certificatePricingBlackAdjusted(certificate, rateCurve,cSelect)
%function which computes the upfront using a Black adjusted 
%
%INPUT
%  _ certificate = struct containing the contract parameters
%  _ rateCurve = struct containing dates and discounts
%  _ cSelect = cSelect
%
%OUTPUT
%  _ Xb = value of the upfront 

%%
    thirty360 = 6;
    act365=3;
    
    datesFloating_1y = floatLegPaymentDates(certificate.setDate,1);
    datesFloating_2y = floatLegPaymentDates(certificate.setDate,2);
    
    B_12 = queryDiscount(rateCurve.dates,rateCurve.discounts,[datesFloating_2y(4),datesFloating_2y(end)]);
    
    BPV_1 = calcBPV(datesFloating_1y,rateCurve.dates,rateCurve.discounts);
    BPV_2 = calcBPV(datesFloating_2y,rateCurve.dates,rateCurve.discounts);
    
    P_1 = certificate.spol*BPV_1+1-B_12(1);
    P_2 = certificate.spol*BPV_2+1-B_12(2);
    
    d1 = yearfrac(certificate.setDate,datesFloating_2y(4),thirty360);
    d2 = yearfrac(datesFloating_2y(4),datesFloating_2y(end),thirty360);
      
    notional=1;
    optionPayoff=1;
    optionStrike=certificate.strike;
    optionTTM=yearfrac(certificate.setDate,datesFloating_2y(4),act365);
      
%% Payoff
    [~,priceSmile] = priceDigital(cSelect, notional, optionPayoff, optionStrike, optionTTM,B_12(1) );
    
    Expectation=priceSmile/B_12(1);
      
    
    Xb=(P_1 - B_12(1)*d1*certificate.coupons(1))*(1-Expectation)+...
              (P_2 - B_12(2)*d2*certificate.coupons(2))*(Expectation);
    

end

