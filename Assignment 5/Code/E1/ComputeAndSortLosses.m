function [Losses,idx] = ComputeAndSortLosses(returns,weights)
%Function that computes past losses and sort them
%
%INPUT
%  _ returns = returns in the considered period
%  _ weights = weights of the HS method
%
%OUTPUT 
%  _ Losses = sorted losses
%  _ idx = index of the losses

[Losses,idx] = sort(-returns*weights,'descend');
end

