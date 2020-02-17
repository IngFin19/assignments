function Ki=Strikes(a,sigma,ta,cuponsDates,coupon,rateCurve)
    % Function that compute the strikes of the calls on the ZCB
    %
    %INPUT
    %  _ dt_i = yearfrac (SetDate,TenorDates) 
    %  _ dt_a = yearfrac (SetDate,Maturity of the swaption)
    %  _ dt_ii = yearfrac (TenorDates_i, TenorDates_i+1) 
    %  _ dt_ai = yearfrac (Maturity of the swaption, TenorDates) 
    %  _ cuopons = coupon
    %  _ a = model param
    %  _ sigma = model param
    %  _ B0i = Forward discounts
    %OUTPUT
    %  _ Ki = Strikes 

P = @(x) forward_Bond_HW(x,a,sigma,ta,cuponsDates,coupon,rateCurve);
x_star = fzero(@(x) P(x)-1,0);
[~,Ki] = forward_Bond_HW(x_star,a,sigma,ta,cuponsDates,coupon,rateCurve);

end

