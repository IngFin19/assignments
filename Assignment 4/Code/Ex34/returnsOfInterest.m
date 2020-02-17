function [tSelected returnsSelected] = returnsOfInterest(inputFile, refDate, timeWindow, sharesList, formatDate)
% Selects set of dates and returns in a lag of interest
% [tSel returnsSel] = returnsOfInterest(inputFile, refDate, timeWindow, sharesList)
%
% INPUTS:
% - inputFile:  complete excel file name (with path) 
% - refDate:    first date of interest
% - timeWindow: in months
% - sharesList: list of the N Shares of Interest
% - formatDate: format used for dates (default 'mm/dd/yyyy')
% 
% OUTPUTS:
% - tSelected:  vector with the T dates of interest 
% - returnsSel: matrix with TxN returns values
%
% USES:
% - findSeries: given the set of data selects the asset of interest
% - dateAddMonth: adds to a month a given number of months
% - closestDate: selects the nearest (even the previous one) to a given date
% - underlyingCode: Converts share name in bbg code 

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

% Select the set of dates of interest: the ones in Eurostoxx50
[values_index t_index]=findSeries(shareData,'SX5E Index', formatDate); %Cerco i valori dell'indice

% refDate, endDate
refDate=datenum(refDate);
[refDate, idxStart] = closestDate(refDate, t_index);
endDate = dateAddMonth(refDate, timeWindow);
[~, idxEnd] = closestDate(endDate, t_index);

tSelected = t_index(idxStart:idxEnd);

% Trovo i valori delle azioni selezionate. Se il valore non è presente
% prendo il valore alla data precedente
valuesSelectedShares=zeros(idxEnd-idxStart+1,elementsBasket);

for i=1:elementsBasket
    
    bbgCode= underlyingCode(sharesList(i,:));
    %Select the shares of interest
    [values_share t_share]=findSeries(shareData,bbgCode, formatDate); 
    
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

returnsSelected=log(valuesSelectedShares(2:end,:)./valuesSelectedShares(1:end-1,:));
tSelected = tSelected(2:end);

end %returnsOfInterest