function NPV = swap_npv(fixedRate,paymentdates,dates,discounts)
% NPV of a payer swap (pays fixed leg)
% 
% fixedRate: rate of the fixed leg
% paymentdates: payment dates of the fixed leg
% dates: dates of the discount curve
% discounts: discounts factors defined on dates

BPV = calcBPV(paymentdates,dates,discounts);
NPV_fixed = fixedRate * BPV;
NPV_floating = 1-queryDiscount(dates,discounts,paymentdates(end));
NPV = NPV_floating-NPV_fixed;
end

