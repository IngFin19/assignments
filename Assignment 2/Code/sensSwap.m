function [DV01, BPV_orig, DV01_z] = sensSwap(setDate, fixedLegPaymentDates, fixedRate, dates, discounts)
    % computes DV01, DV01_z sensitivities for a just issued IRS.
    % Also computes the BPV of the swap. 

    % setDate: current date
    % fixedLegPaymentDates: coupon payment dates
    % fixedRate: fixed coupon rate of the swap
    % dates: dates of the discount curve
    % discounts: discounts factors defined on dates
    
    % definitions 
    onebp = 1e-4;
    formatData='dd/mm/yyyy';
    thirty360=6;
    
    % read dates and rates again to bootstrap the parallel shift curve
    [datesSet, ratesSet] = readExcelData('Data/MktData_CurveBootstrap.xls', formatData);
    [~,shiftedDiscounts] = shiftCurve(datesSet,ratesSet,onebp);
    
    % compute the parallel shift zero rate curve
    zRates = zeroRates(dates, discounts);
    zRates_shifted = zRates+onebp*100;
    zShiftedDiscount = zeroRatesToDiscount(dates, zRates_shifted);

    % computes bpv relevant to the given curves
    BPV_orig = calcBPV(fixedLegPaymentDates,dates,discounts);
    BPV_shifted = calcBPV(fixedLegPaymentDates,dates,shiftedDiscounts);
    % BPV_z_shifted = calcBPV(fixedLegPaymentDates,dates,zShiftedDiscount);

    % computes npv of payer swaps
    NPV_payer_orig = swap_npv(fixedRate,fixedLegPaymentDates,dates,discounts);
    NPV_payer_shifted = swap_npv(fixedRate,fixedLegPaymentDates,dates,shiftedDiscounts);
    NPV_payer_z_shifted = swap_npv(fixedRate,fixedLegPaymentDates,dates,zShiftedDiscount);
    DV01 = abs(NPV_payer_shifted-NPV_payer_orig);
    DV01_z = abs(NPV_payer_z_shifted-NPV_payer_orig);
    % approximations
    % DV01 = abs(BPV_shifted*onebp);
    % DV01_z = abs(BPV_z_shifted*onebp);

end

