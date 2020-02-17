function [floatLegPaymentDates] = calcfloatLegPaymentDates(datesSet)
%Compute Payments  dates of the floating leg of a Asset Swap Spread Over Euribor3m on business days 
%INPUT
%   - dateSet = struct of dates for depos, futures and swaps
%OUTPUT
%   _ floatLegPaymentDates = Vector of Payment Dates for the floating leg 
%FUNCTION
%   _ dateMoveVec = Moves a given date forward or backward by a given number of time units
%                   according to a given business days convention on a given market

startdate = datesSet.settlement;
datepart = 'm';
years = 3;
quartes = 4;
businessdayconvention = 'MF';
market = eurCalendar;
floatLegPaymentDates = zeros(1,years*quartes);

T=startdate;
for i=1:years*quartes
    T=dateMoveVec(T, datepart, years, businessdayconvention, market);
    floatLegPaymentDates(i) = T;
end 

floatLegPaymentDates= floatLegPaymentDates';
end

