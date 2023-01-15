function f = ObjFunLinearMR_20220921(data,coef,t,dt,beta0)
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
MeanBeta = MeanBeta + kappa*(theta-MeanBeta)*dt;
MeanBetaSqr = (1-2*kappa*dt + xi2*dt)*MeanBetaSqr + 2*kappa*theta*dt*MeanBeta;
f(jj) = sqrt(abs(MeanBetaSqr -2*data(1)*MeanBeta + data2(jj)));
g(jj) = MeanBetaSqr-MeanBeta^2;
end
% g(2:end) = g - 
f = [f,g,sqrt(1E-5)*coef];