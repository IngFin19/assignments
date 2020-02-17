function price = LHP_Vasicek(corr,p,Ku,Kd,recovery)
%Compute Vasicek Mezzanine price with Large Portfolio Hypotesis
%
%INPUT
%  _ corr = correlation between morteges
%  _ p = default probability of single defaults
%  _ Ku = upper pinnging point of the mezzanine 
%  _ Kd = lower pinnging point of the mezzanine 
%  _ recovery = recovery in case of default on single name
%
%OUTPUT
%  _ price = price for the mezzanine tranche
%
    u = Ku/(1-recovery);
    d = Kd/(1-recovery);
    pdf_Loss = @(x) normpdf((sqrt(1-corr).*norminv(x)-norminv(p))/(sqrt(corr)))*...
        sqrt((1-corr)/corr)./normpdf(norminv(x));
    tranche_loss = @(x) min(u-d,max(x-d,0))/(u-d);
    integrand = @(x) tranche_loss(x).*pdf_Loss(x);
    expected_payoff = quadgk(integrand,0,1);
    price = (1-expected_payoff)*100;
end
