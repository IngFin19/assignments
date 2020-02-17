function [dates, discounts]=bootstrap(datesSet, ratesSet)
% function that computes the bootstraping procedure given two struct of
% dates and rates.
% 
% twe code assumes that data given are enought to complete the procedure,
% i.e. the number of futures to use is hardcoded and shoudl not be changed
% and the last date of the funutre shoudl be in between the first swap date
% and the second one.
% 
% datesSet: struct of dates for depos, futures and swaps
% ratesSet: struct of rates for depos, futures and swaps

    
    % basis for yearfrac
    act360=2; 
    thirty360=6;
    
    % dates definitions
    settelment_Date = datesSet.settlement;
    first_Future_Date = datesSet.futures(1,1);
    howmanyfutures = 7;
    last_Future_Date = datesSet.futures(howmanyfutures,2);
    index_depo = find(datesSet.depos<=first_Future_Date);

    % vector initializaion
    dates = settelment_Date;
    discounts = 1;
    
    % Depos
    mid_Depos_Discountrate = sum(ratesSet.depos,2)/2;
    depos_Discount = 1./(1+yearfrac(settelment_Date,datesSet.depos,act360).*...
        mid_Depos_Discountrate);
    dates = [dates;datesSet.depos(index_depo)];
    discounts = [discounts;depos_Discount(index_depo)];
    
    % Futures
    mid_STIR_Discountrate=sum(ratesSet.futures,2)/2;
    STIR_fwd_Discount = 1./(1+yearfrac(datesSet.futures(:,1),datesSet.futures(:,2),act360).*...
        mid_STIR_Discountrate);
     
    for i=1:howmanyfutures
        t1=datesSet.futures(i,1);
        t2=datesSet.futures(i,2);
        B_t=queryDiscount(dates,discounts,t1);
        B_T=B_t*STIR_fwd_Discount(i);
        [dates,discounts]=insert_sorted(dates,discounts,...
            t1,B_t); % add discounts at settelment date 
        [dates,discounts]=insert_sorted(dates,discounts,...
            t2,B_T); % add discounts at expiry date
    end
    
    % Swap
    mid_swap_FL = sum(ratesSet.swaps,2)/2;
    swapDiscount = zeros(size(datesSet.swaps));
    index_first_swap = find(datesSet.swaps>=last_Future_Date,1);
    
    B01 = queryDiscount(dates,discounts,datesSet.swaps(1));
    swapDiscount(1) = B01;
    cumSumBPV = B01*yearfrac(settelment_Date,datesSet.swaps(1),thirty360);
    
    for i=index_first_swap:length(datesSet.swaps)
        d=yearfrac(datesSet.swaps(i-1),datesSet.swaps(i),thirty360);
        B_tmp=(1-mid_swap_FL(i)*cumSumBPV)/(1+mid_swap_FL(i)*d);
        cumSumBPV = cumSumBPV + B_tmp*d;
        swapDiscount(i) = B_tmp;
    end
    
    % insert the discount computed from the swpas
    [dates,discounts]=insert_sorted(dates,discounts,...
            datesSet.swaps,swapDiscount);
end

