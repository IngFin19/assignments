function price = Equity_KL_Vasicek(corr,p,Ku,recovery,I)
%Function tht price the Vasiceck equity tranche price as a difference
%between a hypotetical 0,100% tranche and a ku,100% tranche.
%
%INPUT
%  _ corr = correlation between morteges
%  _ p = default probability of single defaults
%  _ Ku = upper pinnging point of the equity tranche 
%  _ recovery = recovery in case of default on single name
%  _ I = number of morteges
% 
%OUTPUT
%  _ price = price of the equity tranche
%
    e_Ku = Ku;
    C1 = 1/e_Ku;
    C2 = 1-e_Ku;
    
    ExpLoss1=100-HP_Vasicek(corr,p,1,0,recovery,1);
    ExpLoss2=100-KL_Vasicek(corr,p,1,e_Ku,recovery,I);
    
    price = 100-C1*(ExpLoss1-C2*ExpLoss2);
    
end

