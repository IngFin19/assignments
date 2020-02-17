function [nMC,errMC]=PlotErrorMC(F0,K,B,T,sigma)
%Plot error of Monte Carlo method
%
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility

    m=1:20;
    Ms=2.^m;
    N=100;
    P=zeros(length(Ms),N);
    err=[];
    flag=1;%call
    for i=1:length(Ms)
        for j=1:N
            P(i,j)=EuropeanOptionMC(F0,K,B,T,sigma,Ms(i),flag);
        end
        err(i)=std(P(i,:));
    end
    nMC=Ms;
    errMC=err;
    
    figure
    loglog(Ms,err)
    hold on
    loglog(nMC,nMC.^-(1/2))
    title('MC error')
    legend('err','O(n^{-1/2})')
    xlabel('steps')
    ylabel('err')

end
