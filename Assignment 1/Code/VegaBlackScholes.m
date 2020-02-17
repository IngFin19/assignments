function vega = VegaBlackScholes(F0,K,B,T,sigma,flag)
%Vega computation
%
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
%flag : 1 call, -1 put (but for vega bs is the same)

d1=log(F0/K)/(sigma*sqrt(T))+0.5*sigma*sqrt(T);
dsigma = 0.1;
vega=B*F0*sqrt(T)*dsigma*normpdf(d1); 
%by P/C parity we can easly show that the vega is the same for Puts or Calls

end