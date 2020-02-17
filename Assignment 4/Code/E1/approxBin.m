function [sol,exact,err] = approxBin(I,m)
    z=m./I;
    sol=1/I*sqrt(I./(2*pi*(1-z).*z)).*exp(-I*(z.*log(z)+(1-z).*log(1-z)));
    exact = my_nchoosek(I,m);
    err = abs(exact-sol)./exact;
end

