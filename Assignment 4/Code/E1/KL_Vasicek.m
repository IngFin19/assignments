function price = KL_Vasicek(corr,p,Ku,Kd,recovery,I,flag)
%KL price for the Vasicek model
%
%INPUT
%  _ corr = correlation between morteges
%  _ p = default probability of single defaults
%  _ Ku = upper pinnging point of the mezzanine 
%  _ Kd = lower pinnging point of the mezzanine 
%  _ recovery = recovery in case of default on single name
%  _ I = number of morteges
%  _ flag = 1 for numerical renomalization, 2 for exact renormalizatin
%
%OUTPUT
%  _ price = price for the mezzanine tranche

    if nargin==6
        flag = 1;
    end
    
    u = Ku/(1-recovery);
    d = Kd/(1-recovery);
    tranche_loss = @(x) min(u-d,max(x-d,0))/(u-d);
    KL = @(z,p) z.*log(z./p)+(1-z).*log((1-z)./(1-p));
    C1 = @(z) sqrt(I./(2*pi*(1-z).*z));
    cond_prob = @(y) normcdf((norminv(p)-sqrt(corr)*y)/sqrt(1-corr));
    
    if flag==1
        C = @(z,y) C1(z); % no exact normalization
    else
        D = @(y) integral(@(z) C1(z).*exp(-I.*KL(z,cond_prob(y))),0,1,'ArrayValued',true);
        C = @(z,y) C1(z)./D(y); % exact normalization
    end
    
    id = 'MATLAB:nchoosek:LargeCoefficient';
    warning('off',id)
    
    integrand = @(z,y) tranche_loss(z).*C(z,y).*exp(-I*KL(z,cond_prob(y))).*normpdf(y);
    expected_payoff = my_integral2(integrand,0,1,-6,6);
    price = (1-expected_payoff)*100;
end