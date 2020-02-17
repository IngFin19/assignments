function A = my_nchoosek(n,ks)
%helper function that compute the matlab nchoosek for vector inputs
%
%INPUT
%  _ n = n as in nchoosek
%  _ ks = k as in nchoosek. Can be vectorial
%
%OUTPUT
%  _ A = vactor of otuputs as in nchoosek
%

A=zeros(1,length(ks));
for i=1:length(ks)
    A(i)=nchoosek(n,ks(i));
end
end

