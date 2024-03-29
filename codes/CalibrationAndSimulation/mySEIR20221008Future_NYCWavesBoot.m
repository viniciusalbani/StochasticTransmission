clear all; clc; close all; format long e;
%%% This code estimates the parameters of the models for beta from the
%%% estimations obtained in mySEIR20221011StochasticBoot.m, considering the
%%% scenarios generated by bootstraping.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% We estimate the parameters of a SEIR-type epidemiological model with a
%%%% stochastic infection rate beta
%%%% using a maximum a posteriori estimator. All the estimation procedures
%%%% are carried out by LSQNONLIN, although the likelihood function (or
%%%% data misfit) is log-Poisson. The model parameters are estimated from
%%%% the daily records of infections and deaths.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Setup for the ODE solver and the least-square function
tol = 1.e-6;  % ode solver tolerance
% set 'Stats','on' to get more info
% options = odeset('AbsTol', tol,'RelTol',tol,'MaxOrder',5,'Stats','on');

% note: set Refine switch to avoid interpolation
options = odeset('AbsTol', tol,'RelTol',tol,'MaxOrder',5,'Stats',...
                                                         'off','Refine',1);
options2 = [];%optimset('MaxFunEvals',10000,'MaxIter',7000,'TolFun',...
               %                                       1e-30,'TolX',1e-30);
options3 = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('data_NYC_20221015Boot.mat')
formatOut = 'dd-mmm-yy';
DeathOld = Death;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

extend = 365; %%% Number of days in the forecast
dates = [datetime(2020,04,05),datetime(2020,10,18),datetime(2021,07,10),...
    datetime(2021,10,10),datetime(2021,11,05)];
Err1 = zeros(length(dates)-1,5);
Err2 = Err1;
H = [100,100,700,500];
NSamples0 = NSamples;

for vv = length(dates)-1
    if length(dates(end):t_span(end))<extend
        extend = length(dates(end):t_span(end))-1;
    end
     len0 = length(t_span(1):dates(vv))+1;
t_actualB = t_actual(1:len0);
 t_extend = [t_actualB,t_actualB(end)+1:t_actualB(end)+extend];
  t_spanA = t_span(1):dates(vv);
  t_spanB = [t_spanA(1:end),t_spanA(end)+1:t_spanA(end)+extend];
     len1 = length(t_spanB);
    
  NewInfections_MR = zeros(len1+1,NSamples0);
 NewInfections_LMR = zeros(len1+1,NSamples0);
 NewInfections_MRJ = zeros(len1+1,NSamples0);
NewInfections_LMRJ = zeros(len1+1,NSamples0);

  BETA_MR2 = zeros(len1+1,NSamples0);
 BETA_LMR2 = zeros(len1+1,NSamples0);
 BETA_MRJ2 = zeros(len1+1,NSamples0);
BETA_LMRJ2 = zeros(len1+1,NSamples0);
  CI901BMR = zeros(len1+1,NSamples0);
  CI902BMR = zeros(len1+1,NSamples0);
 CI901BLMR = zeros(len1+1,NSamples0);
 CI902BLMR = zeros(len1+1,NSamples0);
 CI901BMRJ = zeros(len1+1,NSamples0);
 CI902BMRJ = zeros(len1+1,NSamples0);
CI901BLMRJ = zeros(len1+1,NSamples0);
CI902BLMRJ = zeros(len1+1,NSamples0);

  CI901MR = zeros(len1+1,NSamples0);
  CI902MR = zeros(len1+1,NSamples0);
 CI901LMR = zeros(len1+1,NSamples0);
 CI902LMR = zeros(len1+1,NSamples0);
 CI901MRJ = zeros(len1+1,NSamples0);
 CI902MRJ = zeros(len1+1,NSamples0);
CI901LMRJ = zeros(len1+1,NSamples0);
CI902LMRJ = zeros(len1+1,NSamples0);

coefMR = zeros(NSamples0,3);
coefLMR = zeros(NSamples0,3);
coefMRJ = zeros(NSamples0,6);
coefLMRJ = zeros(NSamples0,6);

parfor zz = 1:NSamples0
params = paramsOld;
 yinit = yinitOld;
    NP = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Extension of time-dependent rates of infection and death.
len = 5; s = 0;
Death = DeathOld;
Death = [Death(1:len0-s),ones(1,extend+s)*mean(Death(len0-len-s:len0-s))];
params.factorDeath = @(t)interp1(t_extend,Death,t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CIR MEAN REVERTING Beta
% len = 30; s = 0;
len=45;
dt =1/365;
ObjFun = @(coef)ObjFunHeston_20220921(BETABoot(zz,len0-len-s:len0-s)',...
    coef,t_actual(len0-len-s:len0-s),dt,BETABoot(zz,len0-len-s));
coef0 = [0.1,BETABoot(zz,len0-len-s),0.01];
LB = [0,0,0.1];
UB = [10,10,10];
coef = lsqnonlin(ObjFun,coef0,LB,UB);

coefMR(zz,:) = coef;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CIR MEAN REVERTING Beta with Jumps
% len = 30; s = 0;
len=90;
ObjFun = @(coef)ObjFunCIRJumps_20220921(BETABoot(zz,len0-len-s:len0-s)',...
    coef,t_actual(len0-len-s:len0-s),dt,BETABoot(zz,len0-len-s));
coef0 = [0.1,BETA(len0-s),0.5,0.5,0,1];
LB=[0,0,0.1,0,-10,0];
UB = [100,10,10,10,10,10];
coefB = lsqnonlin(ObjFun,coef0,LB,UB);

coefMRJ(zz,:) = coefB;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LINEAR MEAN REVERTING Beta
% len = 30; s = 0;
len=45;
ObjFun = @(coef)ObjFunLinearMR_20220921(BETABoot(zz,len0-len-s:len0-s)',...
    coef,t_actual(len0-len-s:len0-s),dt,BETABoot(zz,len0-len-s));
coef0 = [0.1,BETABoot(zz,len0-len-s),0.01];
LB = [0,0,0.1];
UB = [10,10,10];
coef2 = lsqnonlin(ObjFun,coef0,LB,UB);
coefLMR(zz,:) = coef2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LINEAR MEAN REVERTING Beta with Jumps
% len = 30; s = 0;
len=90;
ObjFun = @(coef)ObjFunMRLJumps_20220921(BETABoot(zz,len0-len-s:len0-s)',...
    coef,t_actual(len0-len-s:len0-s),dt,BETABoot(zz,len0-len-s));
coef0 = [0.1,BETA(len0-s),0.5,0.5,0,1];
LB=[0,0,0.1,0,-10,0];
UB = [100,10,10,10,10,10];
coef2B = lsqnonlin(ObjFun,coef0,LB,UB);
coefLMRJ(zz,:) = coef2B;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Evaluating the predictions

%%% CIR MEAN REVERTING
beta0 = BETABoot(zz,len-s+1);
kappa = coef(1);
theta = coef(2);
xi = coef(3);

NSamplesB = 5000;
BETA_MR = zeros(len1+1,NSamplesB);
BETA_MR(1:len0-s+1,:) = BETABoot(zz,1:len0-s+1)'*ones(1,NSamplesB);
beta0 = max(0,beta0)*ones(NSamplesB,1);

yinit2 = zeros(1,5*NSamplesB);
yinit2(1:NSamplesB) = yinit(1)*ones(1,NSamplesB);
yinit2(NSamplesB+1:2*NSamplesB) = yinit(2)*ones(1,NSamplesB);
yinit2(2*NSamplesB+1:3*NSamplesB) = yinit(3)*ones(1,NSamplesB);
yinit2(3*NSamplesB+1:4*NSamplesB) = yinit(4)*ones(1,NSamplesB);
yinit2(4*NSamplesB+1:5*NSamplesB) = yinit(5)*ones(1,NSamplesB);

yb = zeros(len1+1,length(yinit2));
yb(1,:) = yinit2;

for jj = 1:len1
tspan = t_extend(jj:jj+1);
if jj>=len0-s+1
beta = max(0,beta0 + kappa*(theta-beta0)*dt +...
    xi*sqrt(beta0*dt).*randn(NSamplesB,1));
BETA_MR(jj+1,:) = beta;
else
beta = BETA_MR(jj+1,:)';    
end
[~,y]=ode45(@(t,y)seir_death_age_beta_b20221011Heston(t,y,params,beta,...
    NSamplesB),tspan,yinit2,options);
beta0 = beta;
yinit2 = y(end,:);
yb(jj+1,:) = yinit2;
end 
NewInfections = sigma*yb(:,NSamplesB+1:2*NSamplesB)*N;

aux = sort(NewInfections');
aux2 = round(0.05*NSamplesB);
aux = aux(aux2+1:end-aux2,:);
CI90MR = [min(aux);max(aux)];
NewInfections_MR(:,zz)= median(NewInfections');
CI901MR(:,zz) = CI90MR(1,:)';
CI902MR(:,zz) = CI90MR(2,:)';

aux = sort(BETA_MR');
aux2 = round(0.05*NSamplesB);
aux = aux(aux2+1:end-aux2,:);
CI90BMR = [min(aux);max(aux)];
BETA_MR2(:,zz)= median(BETA_MR');
CI901BMR(:,zz) = CI90BMR(1,:)';
CI902BMR(:,zz) = CI90BMR(2,:)';

%%% CIR MEAN REVERTING with JUMPS
beta0 = BETABoot(zz,len-s+1);
kappa = coefB(1);
theta = coefB(2);
xi = coefB(3);
lambda=coefB(4);
mu = coefB(5);
sigmaB=coefB(6);

Lambda=0.1;

NSamplesB = 5000;
BETA_MRJ = zeros(len1+1,NSamplesB);
BETA_MRJ(1:len0-s+1,:) = BETABoot(zz,1:len0-s+1)'*ones(1,NSamplesB);
beta0 = max(0,beta0)*ones(NSamplesB,1);

NN = randn(len1+1-len0-s+1,NSamplesB);
EE = exprnd(len1+1-len0-s+1,NSamplesB);
A = zeros(len1+1-len0-s+1,NSamplesB);
t = zeros(len1+1-len0-s+1,NSamplesB);
E2 = EE(:,NSamplesB);
ss = zeros(1,NSamplesB);
for jj = 2:len1+1-len0-s+1
    for ii = 1:NSamplesB
    Atemp = A(jj-1,ii) + Lambda*(jj*dt-ss(ii));
    if Atemp >= E2(ii)
        ttemp = (E2(ii) - A(jj-1,ii))/Lambda;
        t(jj-1,ii) = ss(ii)+ttemp;
        beta0 = BETA_MRJ(len0-s+jj-2,ii) + ...
            kappa*(theta-BETA_MRJ(len0-s+jj-2,ii))*ttemp + xi*sqrt(BETA_MRJ(len0-s+jj-2,ii))*sqrt(ttemp)*NN(jj-1,ii);
        Z = mvnrnd(mu,sigmaB^2);
        beta0 = beta0 + beta0*lambda*(exp(Z)-1);
        A(jj,ii) = E2(ii);
        E2(ii) = E2(ii) + EE(jj,ii);
        ss(ii) = t(jj-1,ii);
    else
        beta0 = BETA_MRJ(len0-s+jj-2,ii) + ...
            kappa*(theta-BETA_MRJ(len0-s+jj-2,ii))*(jj*dt-ss(ii)) + xi*sqrt(BETA_MRJ(len0-s+jj-2,ii))*sqrt(jj*dt-ss(ii))*NN(jj-1,ii);
        A(jj,ii) = Atemp;
        ss(ii) = jj*dt;
    end
    BETA_MRJ(len0-s+jj-1,ii) = max(0,beta0);
    end
end

yinit = yinitOld;
yinit2 = zeros(1,5*NSamplesB);
yinit2(1:NSamplesB) = yinit(1)*ones(1,NSamplesB);
yinit2(NSamplesB+1:2*NSamplesB) = yinit(2)*ones(1,NSamplesB);
yinit2(2*NSamplesB+1:3*NSamplesB) = yinit(3)*ones(1,NSamplesB);
yinit2(3*NSamplesB+1:4*NSamplesB) = yinit(4)*ones(1,NSamplesB);
yinit2(4*NSamplesB+1:5*NSamplesB) = yinit(5)*ones(1,NSamplesB);

yb = zeros(len1+1,length(yinit2));
yb(1,:) = yinit2;
for jj = 1:len1
tspan = t_extend(jj:jj+1);
beta = BETA_MRJ(jj+1,:)';     
[~,y]=ode45(@(t,y)seir_death_age_beta_b20221011Heston(t,y,params,beta,NSamplesB),tspan,yinit2,options);
yinit2 = y(end,:);
yb(jj+1,:) = yinit2;
end 
NewInfections = sigma*yb(:,NSamplesB+1:2*NSamplesB)*N;

aux = sort(NewInfections');
aux2 = round(0.05*NSamplesB);
aux = aux(aux2+1:end-aux2,:);
CI90MRJ = [min(aux);max(aux)];
NewInfections_MRJ(:,zz)= median(NewInfections')';
CI901MRJ(:,zz) = CI90MRJ(1,:)';
CI902MRJ(:,zz) = CI90MRJ(2,:)';

aux = sort(BETA_MRJ');
aux2 = round(0.05*NSamplesB);
aux = aux(aux2+1:end-aux2,:);
CI90BMRJ = [min(aux);max(aux)];
BETA_MRJ2(:,zz)= median(BETA_MRJ');
CI901BMRJ(:,zz) = CI90BMRJ(1,:)';
CI902BMRJ(:,zz) = CI90BMRJ(2,:)';

%%% LINEAR MEAN REVERTING
beta0 = BETABoot(zz,len-s+1);
kappa = coef2(1);
theta = coef2(2);
xi = coef2(3);

NSamplesB = 5000;
BETA_LMR = zeros(len1+1,NSamplesB);
BETA_LMR(1:len0-s+1,:) = BETABoot(zz,1:len0-s+1)'*ones(1,NSamplesB);
beta0 = max(0,beta0)*ones(NSamplesB,1);

yinit2 = zeros(1,5*NSamplesB);
yinit2(1:NSamplesB) = yinit(1)*ones(1,NSamplesB);
yinit2(NSamplesB+1:2*NSamplesB) = yinit(2)*ones(1,NSamplesB);
yinit2(2*NSamplesB+1:3*NSamplesB) = yinit(3)*ones(1,NSamplesB);
yinit2(3*NSamplesB+1:4*NSamplesB) = yinit(4)*ones(1,NSamplesB);
yinit2(4*NSamplesB+1:5*NSamplesB) = yinit(5)*ones(1,NSamplesB);

yb = zeros(len1+1,length(yinit2));
yb(1,:) = yinit2;

for jj = 1:len1
tspan = t_extend(jj:jj+1);
if jj>=len0-s+1
beta = max(0,beta0 + kappa*(theta-beta0)*dt + xi*beta0*sqrt(dt).*randn(NSamplesB,1));
BETA_LMR(jj+1,:) = beta;
else
beta = BETA_LMR(jj+1,:)';    
end
[~,y]=ode45(@(t,y)seir_death_age_beta_b20221011Heston(t,y,params,beta,NSamplesB),tspan,yinit2,options);
beta0 = beta;
yinit2 = y(end,:);
yb(jj+1,:) = yinit2;
end 
NewInfections = sigma*yb(:,NSamplesB+1:2*NSamplesB)*N;

aux = sort(NewInfections');
aux2 = round(0.05*NSamplesB);
aux = aux(aux2+1:end-aux2,:);
CI90LMR = [min(aux);max(aux)];
NewInfections_LMR(:,zz)= median(NewInfections');
CI901LMR(:,zz) = CI90LMR(1,:)';
CI902LMR(:,zz) = CI90LMR(2,:)';

aux = sort(BETA_LMR');
aux2 = round(0.05*NSamplesB);
aux = aux(aux2+1:end-aux2,:);
CI90BLMR = [min(aux);max(aux)];
BETA_LMR2(:,zz)= median(BETA_LMR');
CI901BLMR(:,zz) = CI90BLMR(1,:)';
CI902BLMR(:,zz) = CI90BLMR(2,:)';

%%% LINEAR MEAN REVERTING with JUMPS
beta0 = BETABoot(zz,len-s+1);
kappa = coef2B(1);
theta = coef2B(2);
xi = coef2B(3);
lambda=coefB(4);
mu = coef2B(5);
sigmaB=coef2B(6);

Lambda=0.1;

NSamplesB = 5000;
BETA_LMRJ = zeros(len1+1,NSamplesB);
BETA_LMRJ(1:len0-s+1,:) = BETABoot(zz,1:len0-s+1)'*ones(1,NSamplesB);
beta0 = max(0,beta0)*ones(NSamplesB,1);

NN = randn(len1+1-len0-s+1,NSamplesB);
EE = exprnd(len1+1-len0-s+1,NSamplesB);
A = zeros(len1+1-len0-s+1,NSamplesB);
t = zeros(len1+1-len0-s+1,NSamplesB);
E2 = EE(:,NSamplesB);
ss = zeros(1,NSamplesB);
for jj = 2:len1+1-len0-s+1
    for ii = 1:NSamplesB
    Atemp = A(jj-1,ii) + Lambda*(jj*dt-ss(ii));
    if Atemp >= E2(ii)
        ttemp = (E2(ii) - A(jj-1,ii))/Lambda;
        t(jj-1,ii) = ss(ii)+ttemp;
        beta0 = BETA_LMRJ(len0-s+jj-2,ii) + kappa*(theta-BETA_LMRJ(len0-s+jj-2,ii))*ttemp + xi*BETA_LMRJ(len0-s+jj-2,ii)*sqrt(ttemp)*NN(jj-1,ii);
        Z = mvnrnd(mu,sigmaB^2);
        beta0 = beta0 + beta0*lambda*(exp(Z)-1);
        A(jj,ii) = E2(ii);
        E2(ii) = E2(ii) + EE(jj,ii);
        ss(ii) = t(jj-1,ii);
    else
        beta0 = BETA_LMRJ(len0-s+jj-2,ii) + kappa*(theta-BETA_LMRJ(len0-s+jj-2,ii))*(jj*dt-ss(ii)) + xi*BETA_LMRJ(len0-s+jj-2,ii)*sqrt(jj*dt-ss(ii))*NN(jj-1,ii);
        A(jj,ii) = Atemp;
        ss(ii) = jj*dt;
    end
    BETA_LMRJ(len0-s+jj-1,ii) = max(0,beta0);
    end
end

yinit = yinitOld;
yinit2 = zeros(1,5*NSamplesB);
yinit2(1:NSamplesB) = yinit(1)*ones(1,NSamplesB);
yinit2(NSamplesB+1:2*NSamplesB) = yinit(2)*ones(1,NSamplesB);
yinit2(2*NSamplesB+1:3*NSamplesB) = yinit(3)*ones(1,NSamplesB);
yinit2(3*NSamplesB+1:4*NSamplesB) = yinit(4)*ones(1,NSamplesB);
yinit2(4*NSamplesB+1:5*NSamplesB) = yinit(5)*ones(1,NSamplesB);

yb = zeros(len1+1,length(yinit2));
yb(1,:) = yinit2;
for jj = 1:len1
tspan = t_extend(jj:jj+1);
beta = BETA_LMRJ(jj+1,:)';     
[~,y]=ode45(@(t,y)seir_death_age_beta_b20221011Heston(t,y,params,beta,NSamplesB),tspan,yinit2,options);
yinit2 = y(end,:);
yb(jj+1,:) = yinit2;
end 
NewInfections = sigma*yb(:,NSamplesB+1:2*NSamplesB)*N;

aux = sort(NewInfections');
aux2 = round(0.05*NSamplesB);
aux = aux(aux2+1:end-aux2,:);
CI90LMRJ = [min(aux);max(aux)];
NewInfections_LMRJ(:,zz)= median(NewInfections');
CI901LMRJ(:,zz) = CI90LMRJ(1,:)';
CI902LMRJ(:,zz) = CI90LMRJ(2,:)';

aux = sort(BETA_LMRJ');
aux2 = round(0.05*NSamplesB);
aux = aux(aux2+1:end-aux2,:);
CI90BLMRJ = [min(aux);max(aux)];
BETA_LMRJ2(:,zz)= median(BETA_LMRJ');
CI901BLMRJ(:,zz) = CI90BLMRJ(1,:)';
CI902BLMRJ(:,zz) = CI90BLMRJ(2,:)';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = 1;
tt = [10,15,30,45,60];
ts = t_span(len0-s:len0-s+extend);

%%% Evaluating Errors:
D = cumsum(data2(len0-s-1:len0-s+extend-1,1));

[~,l] = sort(NewInfections_MR(len0-s:len0-s+extend,:)');
Aux1 = CI901MR(len0-s:len0-s+extend,l)';
Aux2 = CI902MR(len0-s:len0-s+extend,l)';
aux2 = round(0.05*NSamples0);
Aux1 = Aux1(aux2+1:end-aux2,:);
Aux2 = Aux2(aux2+1:end-aux2,:);
CI90MR = [min(Aux1);max(Aux2)];
P5 = cumsum([median(NewInfections_MR(len0-s:len0-s+extend,:)');CI90MR]');


[~,l] = sort(NewInfections_MRJ(len0-s:len0-s+extend,:)');
Aux1 = CI901MRJ(len0-s:len0-s+extend,l)';
Aux2 = CI902MRJ(len0-s:len0-s+extend,l)';
aux2 = round(0.05*NSamples0);
Aux1 = Aux1(aux2+1:end-aux2,:);
Aux2 = Aux2(aux2+1:end-aux2,:);
CI90MRJ = [min(Aux1);max(Aux2)];
P5B = cumsum([median(NewInfections_MRJ(len0-s:len0-s+extend,:)');CI90MRJ]');


[~,l] = sort(NewInfections_LMR(len0-s:len0-s+extend,:)');
Aux1 = CI901LMR(len0-s:len0-s+extend,l)';
Aux2 = CI902LMR(len0-s:len0-s+extend,l)';
aux2 = round(0.05*NSamples0);
Aux1 = Aux1(aux2+1:end-aux2,:);
Aux2 = Aux2(aux2+1:end-aux2,:);
CI90LMR = [min(Aux1);max(Aux2)];
P6 = cumsum([median(NewInfections_LMR(len0-s:len0-s+extend,:)');CI90LMR]');

[~,l] = sort(NewInfections_LMRJ(len0-s:len0-s+extend,:)');
Aux1 = CI901LMRJ(len0-s:len0-s+extend,l)';
Aux2 = CI902LMRJ(len0-s:len0-s+extend,l)';
aux2 = round(0.05*NSamples0);
Aux1 = Aux1(aux2+1:end-aux2,:);
Aux2 = Aux2(aux2+1:end-aux2,:);
CI90LMRJ = [min(Aux1);max(Aux2)];
P6B = cumsum([median(NewInfections_LMRJ(len0-s:len0-s+extend,:)');CI90LMRJ]');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
len=45;
[~,l] = sort(BETA_MR2(len0-len-s-1:len0-s+extend-1,:)');
Aux1 = CI901BMR(len0-len-s-1:len0-s+extend-1,l)';
Aux2 = CI902BMR(len0-len-s-1:len0-s+extend-1,l)';
aux2 = round(0.05*NSamples0);
Aux1 = Aux1(aux2+1:end-aux2,:);
Aux2 = Aux2(aux2+1:end-aux2,:);
CI90BMR = [min(Aux1);max(Aux2)];
B_MR= [median(BETA_MR2(len0-len-s-1:len0-s+extend-1,:)');CI90BMR]';

[~,l] = sort(BETA_MRJ2(len0-len-s-1:len0-s+extend-1,:)');
Aux1 = CI901BMRJ(len0-len-s-1:len0-s+extend-1,l)';
Aux2 = CI902BMRJ(len0-len-s-1:len0-s+extend-1,l)';
aux2 = round(0.05*NSamples0);
Aux1 = Aux1(aux2+1:end-aux2,:);
Aux2 = Aux2(aux2+1:end-aux2,:);
CI90BMRJ = [min(Aux1);max(Aux2)];
B_MRJ= [median(BETA_MRJ2(len0-len-s-1:len0-s+extend-1,:)');CI90BMRJ]';

[~,l] = sort(BETA_LMR2(len0-len-s-1:len0-s+extend-1,:)');
Aux1 = CI901BLMR(len0-len-s-1:len0-s+extend-1,l)';
Aux2 = CI902BLMR(len0-len-s-1:len0-s+extend-1,l)';
aux2 = round(0.05*NSamples0);
Aux1 = Aux1(aux2+1:end-aux2,:);
Aux2 = Aux2(aux2+1:end-aux2,:);
CI90BLMR = [min(Aux1);max(Aux2)];
B_LMR= [median(BETA_LMR2(len0-len-s-1:len0-s+extend-1,:)');CI90BLMR]';

[~,l] = sort(BETA_LMRJ2(len0-len-s-1:len0-s+extend-1,:)');
Aux1 = CI901BLMRJ(len0-len-s-1:len0-s+extend-1,l)';
Aux2 = CI902BLMRJ(len0-len-s-1:len0-s+extend-1,l)';
aux2 = round(0.05*NSamples0);
Aux1 = Aux1(aux2+1:end-aux2,:);
Aux2 = Aux2(aux2+1:end-aux2,:);
CI90BLMRJ = [min(Aux1);max(Aux2)];
B_LMRJ= [median(BETA_LMRJ2(len0-len-s-1:len0-s+extend-1,:)');CI90BLMRJ]';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

aux = sort(coefMR);
aux2 = round(0.05*NSamples0);
aux = aux(aux2+1:end-aux2,:);
CI90coefMR = [min(aux);max(aux)];
coefMR2 = [median(coefMR);CI90coefMR]';

aux = sort(coefMRJ);
aux2 = round(0.05*NSamples0);
aux = aux(aux2+1:end-aux2,:);
CI90coefMRJ = [min(aux);max(aux)];
coefMRJ2 = [median(coefMRJ);CI90coefMRJ]';

aux = sort(coefLMR);
aux2 = round(0.05*NSamples0);
aux = aux(aux2+1:end-aux2,:);
CI90coefLMR = [min(aux);max(aux)];
coefLMR2 = [median(coefLMR);CI90coefLMR]';

aux = sort(coefLMRJ);
aux2 = round(0.05*NSamples0);
aux = aux(aux2+1:end-aux2,:);
CI90coefLMRJ = [min(aux);max(aux)];
coefLMRJ2 = [median(coefLMRJ);CI90coefLMRJ]';

disp('MR')
disp(['kappa: ',num2str(coefMR2(1,:))])
disp(['theta: ',num2str(coefMR2(2,:))])
disp(['xi:    ',num2str(coefMR2(3,:))])

disp('LMR')
disp(['kappa: ',num2str(coefLMR2(1,:))])
disp(['theta: ',num2str(coefLMR2(2,:))])
disp(['xi:    ',num2str(coefLMR2(3,:))])

disp('MRJ')
disp(['kappa:  ',num2str(coefMRJ2(1,:))])
disp(['theta:  ',num2str(coefMRJ2(2,:))])
disp(['xi:     ',num2str(coefMRJ2(3,:))])
disp(['lambda: ',num2str(coefMRJ2(4,:))])
disp(['sigma:  ',num2str(coefMRJ2(5,:))])
disp(['mu:     ',num2str(coefMRJ2(6,:))])

disp('LMRJ')
disp(['kappa:  ',num2str(coefLMRJ2(1,:))])
disp(['theta:  ',num2str(coefLMRJ2(2,:))])
disp(['xi:     ',num2str(coefLMRJ2(3,:))])
disp(['lambda: ',num2str(coefLMRJ2(4,:))])
disp(['sigma:  ',num2str(coefLMRJ2(5,:))])
disp(['mu:     ',num2str(coefLMRJ2(6,:))])
end
