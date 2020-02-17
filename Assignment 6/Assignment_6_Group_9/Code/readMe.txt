EX1
Run : >>runExercise1_Group9.m
Functions:
_ basketSimulation: function which simulate the basket 
_ bootstrap: function that computes the bootstraping procedure given two struct of dates and rates
_ calcBPV:  computes the BPV on the corrisponding dates of paymentdate given the curve dates, discounts.
_ certificatePricing: function which compute the upfront X
_ dateAdd: function which add d, w, m, y to a given data
_ dateMoveVec: function which move a given date forward or backward by a given number of time units
_ floatLegPaymentDates: function which compute Payments  dates of the floating leg Over Euribor3m on business days
_ insert_sorted: function which perform the insertion of point xq in vector x, and the corresponding yq in y s.t. the vectors are then ordered by x values.
_ queryDiscount: main function to performe queries on the disc curve
_ readExcelData: Reads data from excel
_ zeroRates: computes the continuosly comp. zero rate corresponding to the discounts gives 
_ zeroRatesToDiscount: computes the discounts corresponding to the zero rates gives

Ex2
Run : >>runExercise2_Group9.m
Functions:
_ bootstrap: function that computes the bootstraping procedure given two struct of dates and rates
_ insert_sorted: function which perform the insertion of point xq in vector x, and the corresponding yq in y s.t. the vectors are then ordered by x values.
_ priceDigital: function which compute the price of the digital option via black formula and smile 
_ queryDiscount: main function to performe queries on the disc curve
_ readExcelData: Reads data from excel
_ zeroRates: computes the continuosly comp. zero rate corresponding to the discounts gives 

Ex3
Run : >>runExercise3_Group9.m
Functions:
_ computeIntegral: function which compute integral with fast fourier transform and quadrature