function [portfolioValue,prices] = computePortfolioValue(inputFile, todayDate, sharesList, formatDate, numberOfShares)
%function that compute portfolio value of shares
% 
%INPUT
%  _ inputFile = input file (excel)
%  _ todayDate = date of today
%  _ sharesList = list of shares
%  _ formatDate = format of date (e.g. dd/mm/yyyy)
%  _ numberOfShares = number of shares
%
%OUTPUT
%  _ portfolioValue = value of the portfolio of shares
%  _ prices = price vector at time todayDate

    if(nargin <5)
        formatDate = 'mm/dd/yyyy';
    end

    elementsBasket = size(sharesList,1);

    % Scarico dati storici (1290 date) 
    if ismac
        shareData=load('shareData.mat');
        shareData = shareData.shareData;
    else
        [shareData.num,shareData.cell]=xlsread(inputFile,'Data','a5:cx1295');
    end
    [~, t_index]=findSeries(shareData,'SX5E Index', formatDate); %Cerco i valori dell'indice

    endDate = datenum(todayDate);
    [~, idxEnd] = closestDate(endDate, t_index);

    tSelected = t_index(idxEnd);

    % Trovo i valori delle azioni selezionate. Se il valore non è presente
    % prendo il valore alla data precedente
    valuesSelectedShares=zeros(1,elementsBasket);

    for i=1:elementsBasket
        bbgCode=underlyingCode(sharesList(i,:));
        %Select the shares of interest
        [values_share, t_share]=findSeries(shareData,bbgCode, formatDate); 

        % Per ogni sottostante nel paniere 
        %  controllo che ci sia tra le date la data di interesse altrimenti
        %  prendo previous business day
        %%%%%%%%%%%%
        tmp = NaN(size(tSelected));
        [~,ia,ib]=intersect(tSelected,t_share);
        tmp(ia)=values_share(ib);
        valuesSelectedShares(:,i) = fillmissing(tmp,'previous');
        %%%%%%%%%%%%
    end
    portfolioValue = valuesSelectedShares*numberOfShares;
    prices = valuesSelectedShares';
end

