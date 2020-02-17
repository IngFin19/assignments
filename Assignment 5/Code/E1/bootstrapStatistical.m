function samples = bootstrapStatistical(numberOfSamplesToBootstrap, returns)
%function that select the sample
%
%INPUT
%  _ numberOfSamplesToBootstrap = number of samples to bootstrap
%  _ returns = logarithmic returns
%
%OUTPUT
%  _ samples = random samples from a given dataset (of returns)
    
    rng(10)
    samples = datasample(returns,numberOfSamplesToBootstrap);
end

