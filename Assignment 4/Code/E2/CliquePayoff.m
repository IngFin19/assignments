function [payoffs]=CliquePayoff(S)
%function that calculate the payoffs for the cliquet option
%
%INPUT
%  _ S = matrix of the underlyng prices 
%
%OUTPUT
%  _ payoffs = matrix of payoffs for a Cliquet option 

payoffs = max(S(:,2:end)-S(:,1:end-1),0)./S(:,1:end-1);

end