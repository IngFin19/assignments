function plotDiscountCurve(dates,discounts)
    % plots dates, discount in right axis
    % plots dates, zRates in left axis
    
    zRates = zeroRates(dates, discounts);

    figure
    %discount curve
    plot(dates,discounts,'*:')
    datetick('x','mmm-yy','keepticks')
    ylim([0,1])

    %zero-rates
    hold on
    yyaxis right
    plot(dates,zRates,'s--')
    ylim([1,5])
    datetick('x','mmm-yy','keepticks')
    legend('initial discount','zero rate curve')
    grid on
end