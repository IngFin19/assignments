function optionPrice=EuropeanOptionCRR(F0,K,B,T,sigma,N,flag)
%European option price with CRR scheme
%
%INPUT
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% flag:  1 call, -1 put
% N:     number of MC steps

payoffVector=zeros(N+1,1);

dt = T/N;
dx = sigma*sqrt(dt);
u=exp(dx);
d=exp(-dx);
q = (1-d)/(u-d);

for i=0:N
    payoffVector(i+1)=max(flag*(F0*d^i*u^(N-i)-K),0);
end

for j=N+1:-1:2
    for i=1:j-1
        payoffVector(i)=(q*payoffVector(i)+(1-q)*payoffVector(i+1));
    end
end

optionPrice=B*payoffVector(1);

end % function EuropeanOptionClosed