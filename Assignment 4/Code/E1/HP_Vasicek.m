function price = HP_Vasicek(corr,p,Ku,Kd,recovery,I)
%Function tht price the Vasiceck mazzanine price, up to 1000 mortages.
%
%INPUT
%  _ corr = correlation between morteges
%  _ p = default probability of single defaults
%  _ Ku = upper pinnging point of the mezzanine 
%  _ Kd = lower pinnging point of the mezzanine 
%  _ recovery = recovery in case of default on single name
%  _ I = number of morteges
% 
%OUTPUT
%  _ price = price of the mezzanine tranche
%
    if I>1000
        price = nan;
        return
    end
    u = Ku/(1-recovery);
    d = Kd/(1-recovery);
    prob_1_default = @(y) normcdf((norminv(p)-sqrt(corr)*y)/sqrt(1-corr));
    integrand_prob = @(y,m) prob_1_default(y).^m.*...
        (1-prob_1_default(y)).^(I-m).*...
        my_nchoosek(I,m).*...
        normpdf(y);
    prob_m_default = @(m) quadgk(@(y) integrand_prob(y,m),-6,6);
    tranche_loss = @(x) min(u-d,max(x-d,0))/(u-d);
    expected_payoff = 0;
    
    id = 'MATLAB:nchoosek:LargeCoefficient';
    warning('off',id)
    
    for m=0:I
        expected_payoff = expected_payoff + tranche_loss(m/I)*prob_m_default(m);
    end
    price = (1-expected_payoff)*100;
end

