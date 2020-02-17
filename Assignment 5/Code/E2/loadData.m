function [stockPrice,logReturns] = loadData(initial_date,today_date,numberOfDaysInYear,formatDate,riskMeasureTime)
%function that loads data from an excel spreadsheet
%
%INPUT 
%  _ intial_date = first date of interest
%  _ today_date = today date
%  _ numberOfDaysInYear = number of days in year
%  _ formatDate = format of the date (e.g. dd/mm/yyyy)
%
%OUTPUT 
%  _ stockPrice = vector with all prices of the stock during the period
%  _ logReturns = ten day log returns of the stock during the period

    if ismac
        date = load('date.mat');
        date = date.date;
        values = load('values_vivanti.mat');
        values = values.values;
    else
        [shareData.num,shareData.cell]=xlsread('sx5e_historical_data.xls','cu5:cv1292'); 
        [values, date, ~]=findSeries(shareData,'VIV',formatDate);        
    end
    
    DT = riskMeasureTime*numberOfDaysInYear;
    idx_old=find(date==initial_date);
    idx=find(date==today_date);
    stockPrice=values(idx);
    logReturns=log(values(idx_old+DT:DT:idx)./values(idx_old:DT:idx-DT))';
end

