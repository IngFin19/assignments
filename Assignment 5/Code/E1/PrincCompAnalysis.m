function [ES, VaR] = PrincCompAnalysis(yearlyCovariance, yearlyMeanReturns, weights, H, alpha, numberOfPrincipalComponents, portfolioValue)
%Function that compute VaR and ES with the Principal Component Analysis (PCA)
%
%INPUT 
%  _ yearlyCovariance = yearly covariance
%  _ yearlyMeanReturns = yearly mean returns
%  _ weights = weights 
%  _ H = one day in year
%  _ alpha = confidence level
%  _ numberOfPrincipalComponents = number of principal components
%  _ portfolioValue = value if the portfolio
%
%OUTPUT
%  _ ES = expected shortfall computed with PCA
%  _ VaR = Value at risk computed with PCA

    [eigenVect,eigenValues] = eig(yearlyCovariance);
    [eigenValues,idx] = sort(diag(eigenValues),'descend');
    
    % reordering the eigenvectors
    selectedEig = eigenValues(1:numberOfPrincipalComponents);
    eigenVect = eigenVect(:,idx);
    yearlyMeanReturns = yearlyMeanReturns(idx);
    weights = weights(idx);
    
    % analytics
    w_hat = eigenVect'*weights;
    mu_hat = eigenVect'*yearlyMeanReturns(:);
    sigma_red = sqrt(selectedEig'*w_hat(1:numberOfPrincipalComponents).^2)*sqrt(H);
    mu_red = -mu_hat(1:numberOfPrincipalComponents)'*w_hat(1:numberOfPrincipalComponents)*H;
    
    % results
    VaR = (mu_red+sigma_red*norminv(alpha))*portfolioValue;
    ES = (mu_red+sigma_red*normpdf(norminv(alpha))/(1-alpha))*portfolioValue;
    
end

