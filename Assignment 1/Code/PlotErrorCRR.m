function [nCRR,errCRR]=PlotErrorCRR(F0,K,B,T,sigma)
   %Plot error of CRR method
%
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility


    m=1:9;
    Ms=2.^m;
    P=[]; %prices
    flag=1; %call
    priceBlk=EuropeanOptionClosed(F0,K,B,T,sigma,flag); %exact blak model price
    for M=Ms
        P=[P,EuropeanOptionCRR(F0,K,B,T,sigma,M,flag)];
    end
    errCRR=abs(P-priceBlk);
    nCRR=Ms;
    
    figure
    loglog(nCRR,errCRR)
    hold on
    loglog(nCRR,nCRR.^-1)
    loglog(nCRR,nCRR.^-2)
    legend('err','O(n^{-1})','O(n^{-2})')
    xlabel('steps')
    ylabel('err')
    title('CRR error')


end

