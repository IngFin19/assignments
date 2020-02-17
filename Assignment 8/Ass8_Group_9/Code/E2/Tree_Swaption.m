function price = Tree_Swaption(D1,D2,rateCurve,sigma,a,M)
    % Function that compute the swaption price with Trinomial Tree
    % BEWARE! since we couldn't write the tree in matrix form this 
    % implementation is slighly uneffiecient. M sould then be less then 70
    % to have small computing times.
    %
    % 
    %INPUT
    %  _ D1 = maturity of the swaption
    %  _ D2 = maturity of the swap
    %  _ rateCurve = Discount curve
    %  _ sigma = model param
    %  _ a = mean reverting param
    %  _ M = number of time steps
    %OUTPUT
    %  _ price = price of the swaption
    %FUNCTIONS
    %  _ forward_Bond_HW to price fwd bonds


%% definitions

    datepart = 'y';
    businessdayconvention = 'MF';
    market = eurCalendar;
    
    % tree
    dt = D1/M;
    setDate = rateCurve.dates(1);
    sigma_hat = sigma*sqrt((1-exp(-2*a*dt))/(2*a));
    mu = 1-exp(-a*dt);
    dx = sqrt(3)*sigma_hat;
    l_max = floor((1-sqrt(2/3))/mu+1);
    l_min = -l_max;
    l = (l_max:-1:l_min)';
    x = l*dx;
    
    % trans probs
    pA = [1/2*(1/3-l*mu+(l*mu).^2),2/3-(l*mu).^2,1/2*(1/3+l*mu+(l*mu).^2)];
    pB = [1/2*(1/3+l_min*mu+(l_min*mu).^2),-1/3-2*l_min*mu-(l_min*mu).^2,1/2*(7/3+3*l_min*mu+(l_min*mu).^2)];
    pC = [1/2*(7/3-3*l_max*mu+(l_max*mu).^2),-1/3+2*l_max*mu-(l_max*mu).^2,1/2*(1/3-l_max*mu+(l_max*mu).^2)];

    p = pA;
    p(1,:) = pC;
    p(end,:) = pB;
    
    % dates 
    ta  = dateMoveVec(setDate, datepart, D1, businessdayconvention, market);
    tw  = dateMoveVec(setDate, datepart, D1+D2, businessdayconvention, market);
    cuponsDates = paymentDates(ta, D2);
    
    % discounts
    Ba = queryDiscount(rateCurve.dates, rateCurve.discounts, ta);
    B0w = queryDiscount(rateCurve.dates, rateCurve.discounts, tw)/Ba;
    BPV = calcBPV_fwd(ta, cuponsDates, rateCurve.dates, rateCurve.discounts);
    
%% init

    % payoff
    strike = (1-B0w)/BPV;
    
    coupon = strike*ones(length(cuponsDates),1);
    coupon(end) = coupon(end)+1;
    sigma_HW = @(t1,t2) sigma/a*(1-exp(-a*(t2-t1)));
    
    payoff = max(1-forward_Bond_HW(x',a,sigma,ta,cuponsDates,coupon,rateCurve),0)';
    
    Price = zeros(length(x),M);
    Price(:,end) = payoff;
    
    
%% tree
        
    tt = round(setDate:dt*365:ta)';
    dt_i = yearfrac(setDate,tt,3);
    
    sigma_hat_star = sigma/a*sqrt(dt-2*(1-exp(-a*dt))/a+(1-exp(-2*a*dt))/(2*a));
    sigma_hat = sigma*sqrt((1-exp(-2*a*dt))/(2*a));
    
    DX = zeros(3,length(x));
    DX(1,2:end-1) = dx;
    DX(3,2:end-1) = -dx;
    DX(:,1) = [0,-dx,-2*dx]';
    DX(:,end) = [2*dx,dx,0]';
    
    for j=M-1:-1:1
        ti_1 = tt(j+1);
        ti = tt(j);
            
        B0 = queryDiscount(rateCurve.dates, rateCurve.discounts, ti_1)/...
            queryDiscount(rateCurve.dates, rateCurve.discounts, ti);
        B =@(x) B0.*exp(-x/sigma*sigma_HW(0,dt)+ ...
            -0.5 * integral(@(u) (sigma_HW(u,dt_i(j)+dt).^2-sigma_HW(u,dt_i(j)).^2),0,dt_i(j),'ArrayValued',true));
        
        if j>l_max
            for i=1:length(x)
                if i==1
                    D = B(x(i:i+2)).*...
                        exp(-0.5*sigma_hat_star^2-sigma_hat_star/sigma_hat*((p(i,:)*DX(:,i)+mu*x(i:i+2))));
                    
                    Price(i,j) = p(i,:) * (Price(i:i+2,j+1).*D);
                elseif i==length(x)
                    D = B(x(i-2:i)).*...
                        exp(-0.5*sigma_hat_star^2-sigma_hat_star/sigma_hat*((p(i,:)*DX(:,i)+mu*x(i-2:i))));
                    
                    Price(i,j) = p(i,:) * (Price(i-2:i,j+1).*D);
                else
                    D = B(x(i-1:i+1)).*...
                        exp(-0.5*sigma_hat_star^2-sigma_hat_star/sigma_hat*((p(i,:)*DX(:,i)+mu*x(i-1:i+1))));
                    
                    Price(i,j) = p(i,:) * (Price(i-1:i+1,j+1).*D);
                end
            end
        else
            for i=(l_max-j)+2:length(x)-((l_max-j)+1)
                D = B(x(i-1:i+1)).*...
                    exp(-0.5*sigma_hat_star^2-sigma_hat_star/sigma_hat*((p(i,:)*DX(:,i)+mu*x(i-1:i+1))));
         
                Price(i,j) = p(i,:) * (Price(i-1:i+1,j+1).*D);
            end
        end
    end
    %spy(sparse(Price))
    
    price = Price(l_max+1,1);
    
end

