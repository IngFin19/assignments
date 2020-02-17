EX1
Run : >>runExercise1_Group9.m
Functions:
_ bootstrap: function that computes the bootstraping procedure given two struct of dates and rates
_ CapFlatVol: function which compute the price of the cap using the flat volatility
_ CapletFromCapVolatilities:function which compute the value of the caplet starting from the cap volatilities
_ CapletPrice: function which compute the price of every caplet using the black formula
_ certificatePricing: function which compute the vaue of the upfront 
_ insert_sorted: function which perform the insertion of point xq in vector x, and the corresponding yq in y s.t. the vectors are then ordered by x values.
_ interpSurface: function which compute the volatility through interpolation if the strike that we need does not exist
_ plotDiscountCurve: plot discount curve
_ readExcelCap: reads data from excel
_ readExcelDis: reads data from excel
_ zeroRates: computes the continuosly comp. zero rate corresponding to the discounts gives

EX2
Run : >>runExercise2_Group9.m
Functions:
_ bootstrap: function that computes the bootstraping procedure given two struct of dates and rates
_ CallPricesNIGFFT: function that compute the price of the european call with FFT in the NIG framework
_ CallPricesNIGMC: function that compute the price of the european call with Monte Carlo method in the NIG framework
_ CallPricesNIGQuadrature: function that compute the price of the european call with Quadrature in the NIG framework
_ computeIntegral: function which compute integral with fast fourier transform and quadrature
_ insert_sorted: function which perform the insertion of point xq in vector x, and the corresponding yq in y s.t. the vectors are then ordered by x values.
_ queryDiscount: function to performe queries on the disc curve
_ readExcelData: function that reads data from excel
_ zeroRates: computes the continuosly comp. zero rate corresponding to the discounts gives


EX3
Run : >>runExercise3_Group9.m
Functions:
_ bootstrap: function that computes the bootstraping procedure given two struct of dates and rates
_ CalibrateNIGToVolatilitySurface: function that Calibrate the NIG model, with constant weights starting from
_ CallPricesNIGFFT: function that compute the price of the european call with FFT in the NIG framework
_ computeIntegral: function which compute integral with fast fourier transform and quadrature
_ insert_sorted: function which perform the insertion of point xq in vector x, and the corresponding yq in y s.t. the vectors are then ordered by x values.
_ queryDiscount: function to performe queries on the disc curve
_ readExcelData: function that reads data from excel
_ zeroRates: computes the continuosly comp. zero rate corresponding to the discounts gives

