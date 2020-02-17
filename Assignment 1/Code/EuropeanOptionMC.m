function  OptionPrice = EuropeanOptionMC(F0,K,B,T,sigma,N,flag)
%European option price with Monte Carlo Method
%
%INPUT
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% flag:  1 call, -1 put
% N:     number of MC steps

Z = randn(N,1); 
drift = (-0.5*sigma^2) * T;
diffusion = sigma*sqrt(T);
F= F0.* exp(drift + diffusion .* Z); 
Call_Value = max(F - K, 0);
Put_Value = max(K - F, 0);
if flag == 1 
   OptionPrice= B*mean(Call_Value);
else
   OptionPrice= B*mean(Put_Value);
end
end

