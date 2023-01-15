function  yprime = seir_death_age_beta_b20221011(t,y, params)

factorD = params.factorDeath;
reinf = params.reinf;

Number = params.NumberOfAgeClasses;
beta = params.beta;
mu = factorD(t);%.*params.Death;
nu = 1/14*ones(size(mu));%ones-mu;
sigma = params.sigma;

S = y(1);
E = y(2);
I = y(3);
R = y(4);
%      D = y(5);

yprime = zeros(length(y),1);
for jj = 1:Number
yprime(1) = -S*(beta*I)+reinf*R;
yprime(2) = S*(beta*I) - sigma*E;
yprime(3) = sigma*E-nu*I-min(mu,0.5*I);              
yprime(4) = nu*I-reinf*R;
yprime(5) = min(mu,0.5*I);
end