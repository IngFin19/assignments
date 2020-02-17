function optionPrice=EuropeanOptionClosed(F0,K,B,T,sigma,flag)
%European option price with Closed formula
%
%INPUT
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% flag:  1 call, -1 put
% N:     number of MC steps
d=-0.04;
[call, put] = blkprice(F0, K, B, T, sigma);

if flag == 1 
   optionPrice= B*call;
else
   optionPrice= B*put;
end

end % function EuropeanOptionClosed