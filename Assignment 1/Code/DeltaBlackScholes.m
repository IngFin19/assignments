function delta = DeltaBlackScholes(F0,K,B,T,sigma,flag)
%Delta computation
%
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
%flag : 1 call, -1 put 

d1=log(F0/K)/(sigma*sqrt(T))+0.5*sigma*sqrt(T);
calldelta=normcdf(d1); %in B&S discounting and derivative of fwd wrt Spot cancel themselfs

if flag == 1 
   delta=calldelta;
else
   delta=calldelta-1;
end

end

