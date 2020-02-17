function [datesCliquet]= calcdates(datesSet)
%this function calculate a vector of dates for the payment dates 
%INPUT
%  _ datesSet = struct of dates for depos, futures and swaps
%
%OUTPUT
%  _ datesCliquet = vector containing dates of payment for the Cliquet
%                   option
%FUNCTION
%  _ dateMoveVec = Moves a given date forward or backward by a given number of time units
%                  according to a given business days convention on a given market
startdate = datesSet.settlement;
datepart = 'y';
years = 5;
num=1;
businessdayconvention = 'MF';
market = eurCalendar;
datesCliquet = zeros(1,years);

T=startdate;
for i=1:years
    T=dateMoveVec(T, datepart, num, businessdayconvention, market);
    datesCliquet(i) = T;
end 

datesCliquet= datesCliquet';
end


