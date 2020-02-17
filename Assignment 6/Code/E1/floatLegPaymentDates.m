function [floatLegPaymentsDates] = floatLegPaymentDates(startdate,years)
%Compute Payments  dates of the floating leg Over Euribor3m on business days 
%INPUT
%   - dateSet = struct of dates for depos, futures and swaps
%OUTPUT
%   _ floatLegPaymentDates = Vector of Payment Dates for the floating leg 
%FUNCTION
%   _ dateMoveVec = Moves a given date forward or backward by a given number of time units
%                   according to a given business days convention on a given market

datepart = 'm';
quartes = 4;
numberOfMonthsIncrement = 3;
businessdayconvention = 'MF';
market = eurCalendar;
floatLegPaymentsDates = zeros(1,years*quartes);

T=startdate;
for i=1:years*quartes
    T = dateMoveVec(startdate, datepart, numberOfMonthsIncrement*i, businessdayconvention, market);
    floatLegPaymentsDates(i) = T;
end 

floatLegPaymentsDates= floatLegPaymentsDates';
end

