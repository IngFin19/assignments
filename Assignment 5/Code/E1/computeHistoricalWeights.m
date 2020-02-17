function w = computeHistoricalWeights(lambda,numberOfDays)
%Function that compute the weights for the historical simulation
%
%INPUT 
%  _lambda = lambda parameter
%  _ numberOfDays = number of days in which there is a return
%
%OUTPUT
%  _w = weights

    C=(1-lambda)/(1-lambda^numberOfDays);
    w=C*lambda.^(numberOfDays-1:-1:0);
end

