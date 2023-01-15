function f = ObjFunLinearMR_20220921B(data,coef,t,dt,beta0)
kappa = coef(1);
theta = coef(2);
xi = coef(3);
xi2 = xi^2;

data2 = data.^2;

MeanBeta = beta0;
MeanBetaSqr = beta0^2;
f = zeros(size(t));
f(1) = sqrt(MeanBetaSqr -2*data(1)*MeanBeta + data2(1));
g = zeros(size(t));
for jj = 1:length(t)-1
MeanBeta = MeanBeta*exp(-kappa*dt)+theta*(1-exp(-kappa*dt));
MeanBetaSqr = MeanBetaSqr*exp(-(2*kappa-xi2)*dt)+(2*kappa*theta*MeanBeta-2*kappa*theta^2)/(kappa-xi2)*(exp(-kappa*dt)-exp(-(2*kappa-xi2)*dt)) + (2*kappa*theta^2)/(2*kappa-xi^2)*(1-exp(-(2*kappa-xi2)*dt));
f(jj) = sqrt(abs(MeanBetaSqr -2*data(1)*MeanBeta + data2(jj)));
g(jj) = MeanBetaSqr-MeanBeta^2;
end
% g(2:end) = g - 
f = [f,g,sqrt(1E-5)*coef];