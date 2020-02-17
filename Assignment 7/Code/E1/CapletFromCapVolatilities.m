function capletVolatilities = CapletFromCapVolatilities(capVolatilityData, discountCurve)
%capletVolatilities = CapletFromCapVolatilities(capVolatilityData, discountCurve)
%function which compute the value of the caplet starting from the cap
%volatilities
%
%INPUT
%  _ capVolatilityData = matrix with strikes, maturities and flat
%                        volatilities
%  _  discountCurve = struct containing dates and discounts
%
%OUTPUT
%  _ capletVolatilities = spot volatilities for the caplet
%
%FUNCTION
%  _ CapFlatVol = function which compute the price of the cap using the flat volatility
%  _ CapletPrice = function which compute the price of every caplet using the black formula 
%

    capletVolatilities = zeros(length(capVolatilityData.strikes),...
        length(capVolatilityData.payment_dates)-1);
    
    payment_dates = capVolatilityData.payment_dates(2:end);

    f = waitbar(0,'bootstraping caplet spot vol...');
    
    for idx_K=1:length(capVolatilityData.strikes)
        
        K = capVolatilityData.strikes(idx_K);

        capletVolatilities(idx_K,1) = capVolatilityData.surface(idx_K,1);
        C_old = CapFlatVol(1,idx_K,capVolatilityData,discountCurve);
        
        for t=2:2:length(capVolatilityData.payment_dates)-1
            
            waitbar((t+(idx_K-1)*(length(capVolatilityData.payment_dates)-1))/(length(capVolatilityData.strikes)*(length(capVolatilityData.payment_dates)-1)))
            
            vol_A = capletVolatilities(idx_K,t-1);
            C = CapFlatVol(t/2+1,idx_K,capVolatilityData,discountCurve);
            DC = C - C_old;

            TA = payment_dates(t-1);
            TB = payment_dates(t);
            TC = payment_dates(t+1);
            
            c = (TB-TA)/(TC-TA);
            
            %% system 
            
            f = @(vol_C) (DC - CapletPrice(K,vol_A+c*(vol_C-vol_A),TA,TB,discountCurve) - CapletPrice(K,vol_C,TB,TC,discountCurve));
            
            vol_C = fzero(f,[0; 2*vol_A]);
            
            capletVolatilities(idx_K,t+1) = vol_C;
            capletVolatilities(idx_K,t) = vol_A+c*(vol_C-vol_A);
            
            C_old = C;
            
            %% optimization 
            
%             f = @(z) (DC - CapletPrice(K,z(1,:),TA,TB,discountCurve) - CapletPrice(K,z(2,:),TB,TC,discountCurve)).^2;
%             
%             k=-0.05:0.001:0.05;
%   
%             x0_tmp = [vol_A+c*(k); vol_A+k];
%             [~,index_min] = min(f(x0_tmp));
%             x0 = x0_tmp(:,index_min);
%             
%             Aeq = [1, -c];
%             beq = vol_A*(1-c);
%             
%             [z,err] = fmincon(f,x0,[],[],Aeq,beq,[0,0],[2,2],[],optimset('display','off','TolX', 1e-10,'MaxIter',1000));
%             
%             if err>10-8
%                 error("Error in the minimization")
%             end
%             
%             capletVolatilities(idx_K,t+1) = z(2);
%             capletVolatilities(idx_K,t) = z(1);
%             C_old = C;            
        
        end
    end
    F = findall(0,'type','figure','tag','TMWWaitbar');
    delete(F)
end

