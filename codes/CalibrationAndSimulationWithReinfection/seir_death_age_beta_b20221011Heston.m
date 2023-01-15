function  yprime = seir_death_age_beta_b20221011Heston(t,y, params,beta,NSamples)

factorD = params.factorDeath;
reinf=params.reinf;
Number = params.NumberOfAgeClasses;
mu = factorD(t);%.*params.Death;
nu = 1/14*ones(size(mu));%ones-mu;
sigma = params.sigma;

S = y(1:NSamples);
E = y(NSamples+1:2*NSamples);
I = y(2*NSamples+1:3*NSamples);
R = y(4);
%      D = y(5);

yprime = zeros(size(y));
for jj = 1:Number
yprime(1:NSamples) = -S.*(beta.*I)+reinf*R;
yprime(NSamples+1:2*NSamples) = S.*(beta.*I) - sigma*E;
yprime(2*NSamples+1:3*NSamples) = sigma*E-nu*I-min(mu,0.5*I);              
yprime(3*NSamples+1:4*NSamples) = nu*I-reinf*R;
yprime(4*NSamples+1:5*NSamples) = min(mu,0.5*I);
end