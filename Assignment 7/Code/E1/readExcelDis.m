function [dates, rates] = readExcelDis( filename, formatData)
% Reads data from excel
%  It reads bid/ask prices and relevant dates
%  All input rates are in % units
%
% INPUTS:
%  filename: excel file name where data are stored
%  formatData: data format in Excel
% 
% OUTPUTS:
%  dates: struct with settlementDate, deposDates, futuresDates, swapDates
%  rates: struct with deposRates, futuresRates, swapRates

%% Dates from Excel

if ispc
    %Settlement date
    [~, settlement] = xlsread(filename, 1, 'C4');
    %Date conversion
    dates.settlement = datenum(settlement, formatData);

    %Dates relative to depos
    [~, date_depositi] = xlsread(filename, 1, 'E7:E14');
    dates.depos = datenum(date_depositi, formatData);

    %Dates relative to futures: calc start & end
    [~, date_futures_read] = xlsread(filename, 1, 'F18:G19');
    numberFutures = size(date_futures_read,1);

    dates.futures=ones(numberFutures,2);
    dates.futures(:,1) = datenum(date_futures_read(:,1), formatData);
    dates.futures(:,2) = datenum(date_futures_read(:,2), formatData);

    %Date relative to swaps: expiry dates
    [~, date_swaps] = xlsread(filename, 1, 'E23:E36');
    dates.swaps = datenum(date_swaps, formatData);

    %% Rates from Excel (Bids & Asks)

    %Depos
    tassi_depositi = xlsread(filename, 1, 'F7:G14');
    rates.depos = tassi_depositi / 100;

    %Futures
    tassi_futures = xlsread(filename, 1, 'H18:I19');
    %Rates from futures
    rates.futures = tassi_futures / 100;

    %Swaps
    tassi_swaps = xlsread(filename, 1, 'F23:G36');
    rates.swaps = tassi_swaps / 100;

elseif ismac

    datesSet = load("Data/Date_new.mat");
    dates = datesSet.Data;

    ratesSet = load("Data/Tassi_new.mat");
    rates = ratesSet.Tassi;
end

end % readExcelData