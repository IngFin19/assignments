function tau = Simulate_tau(Nsim,intensity)
%function that simulate credit events times
%
%INPUT
%  _ Nsim = number of simulations
%  _ intensity = intensity parameter of the exponential
%
%OUTPUT
%  _ tau = credit events times

    rng(100)
    tau = expinv(rand(1,Nsim),1/intensity);
end

