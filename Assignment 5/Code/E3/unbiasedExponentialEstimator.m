function [lambda_fit,CI] = unbiasedExponentialEstimator(tau,alpha)
%function which compute an unbiased estimator for the exponential
%
%INPUT
%  _ tau = credit events times
%  _ alpha = confidence level
% 
%OUTPUT
%  _ lambda_fit = unbiased estimator of lambda parameter
%  _ CI = confidence interval 

    n = length(tau);
    lambda_fit = 1/mean(tau)/n*(n-1);
    CI = lambda_fit*n/(n-1)*[gaminv(alpha/2,n,1/n),gaminv(1-alpha/2,n,1/n)];
end

