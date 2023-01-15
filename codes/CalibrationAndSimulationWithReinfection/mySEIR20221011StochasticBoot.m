clear all; clc; close all; format long e;
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
%%%% Experimental Data
% DATA_SP2;
% DATA_BC;
DATA_NYC;
% DATA_Chicago;
ReinfectionParam = 1./[30,60,180,360]; %days^-1

for zz = 1:length(ReinfectionParam)

CASES=zeros(length(t_actual),1);
DEATHS = zeros(length(t_actual),1);
R = zeros(length(t_actual),1);


params = [];

%%%% Total Population:
N = Population;      

%%%% Population proportion on each age range:
Proportion = ones;
PropInfections = sum(data2(:,1))/N;
PropDeath = sum(data2(:,2))/(0.4*sum(data2(:,1)));

%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Model Parameters
sigma = 1./5.1;
params.sigma = sigma;   % inverse of mean incubation time
params.reinf = ReinfectionParam(zz);

NumberOfAgeClasses = 1;  % total age ranges
params.NumberOfAgeClasses = NumberOfAgeClasses;


nu = 1./14; % Mean time until recovery
gamma = PropDeath; % Mean time until death
p  = (1-gamma); % Proportion of individuals that will recover
params.p = p; % In Mild conditions

%--------------------------------------------------------------------------
%%% RATES

Recovery = (nu+gamma)*p; % Recovery Rate
params.Recovery = Recovery;

%%% Death Rate
Death = gamma;
params.Death = Death; % in ICU individuals

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Correcting Hospitalization and Death Rates
Death = ones(size(t_actual));
Death(3:end) = min(0.5*data2(2:end,1),data2(2:end,2))./N;
params.factorDeath = @(t)interp1(t_actual,Death,t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------------------------------------------------
% A priori value for the transmission parameter
R_zero = 1.4*2.8/0.1782;
gamma = 1/18;

%--------------------------------------------------------------------------
beta = 2.2911*R_zero*gamma;
dt = 1/365;
params.dt = dt; % Time
NSamples = 1;
params.NSamples = NSamples;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initial parameters

I_0 = data2(1,1);      % Potential initial infected and mild at t=0
E_0 = data2(1,1);       % initial exposed
R_0 = 0;       % initial recovered 
D_0 = 0;       % initial dead

%--------------------------------------------------------------------------

%  params is a structure used to pass parameters to the
%   ODE solver

S_0 = N-(I_0+E_0+R_0+D_0);    % Suceptible pop.,  excluding initial infected 
params.N = N;  % N = total population


yinit = zeros(1,5*NSamples);
yinit(1:NSamples) = S_0*Proportion*ones(1,NSamples);
yinit(NSamples+1:2*NSamples) = E_0*Proportion*ones(1,NSamples);
yinit(2*NSamples+1:3*NSamples) = I_0*Proportion*ones(1,NSamples);
yinit(3*NSamples+1:4*NSamples) = R_0*Proportion*ones(1,NSamples);
yinit(4*NSamples+1:5*NSamples) = D_0*Proportion*ones(1,NSamples);
yinit = yinit/N;

paramsOld = params;
yinitOld = yinit;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Estimating basic parameters from day 1 until 20:


ext = length(t_span);

BETA = zeros(length(t_actual),1);
BETA(1) = beta; 
unknowns0 = beta;
priors = unknowns0;
yinit2 = yinit;
yb = zeros(length(t_actual),length(yinit));
yb(1,:) = yinit;

LB = 1E-3;
UB = 10;
for jj = 1:ext
OF = @(unknowns)ObjFun_BetaWithoutAge20221011(t_actual(jj:jj+1),params,data2(jj,:),options,priors,yinit2,unknowns);
unknowns = lsqnonlin(OF,unknowns0,LB,UB,options2);
params.beta= unknowns(1);
priors = unknowns;
unknowns0 = unknowns;
BETA(jj+1,:) = unknowns;
[~,y2] = ode45(@(t,y)seir_death_age_beta_b20221011(t,y, params),t_actual(jj:jj+1),yinit2,options);
yinit2 = y2(end,:);
yb(jj+1,:) = yinit2;
disp(num2str(unknowns))
end 

NewInfections = sigma*yb(:,2)*N;

Bootstrapping_20221011;


% save data_NYC_20221011Boot
save(['dataReinf_NYC_20221015Boot_',num2str(zz),'.mat'])
end