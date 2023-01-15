%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Bootstrap Sampling
NSamples = 200;
trajectories = zeros(length(t_actual),NSamples);
for jj = 1:NSamples
trajectories(:,jj) = poissrnd(NewInfections);
end

%% Estimating Bootstrap Parameters
BETABoot = zeros(NSamples,length(BETA));
R0Boot = zeros(NSamples,length(t_actual)-1);
AUX = zeros(size(BETABoot));
t_actualB = t_actual;

N = params.N;

NewCasesBoot = zeros(length(t_actual),NSamples);
NewDeathsBoot = zeros(length(t_actual),NSamples);


parfor ll = 1:NSamples
params2=params;
auxA = zeros(1,length(t_actual)-1);

% %%% Estimating the transmission constant parameters (M,H,I), the initial
% %%% infecve population (I_M0) and the transmission matrix:
yinitB = yinitOld;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Estimating a time-dependent transmission parameter (beta) from day 1
%%%% until 19:

Beta = zeros(length(t_actual),1);
Beta(1) = beta; 
unknowns0 = beta;
priors = unknowns0;
yinit2 = yinitB;
yb2 = zeros(length(t_actual),length(yinit));
yb2(1,:) = yinitB;
params2.beta= unknowns0;
for jj = 1:length(t_actual)-1
t_actual2 = t_actual(jj:jj+1);
OF2 = @(unknowns)ObjFun_BetaWithoutAge20221011(t_actual2,params2,trajectories(jj+1,ll),options,priors,yinit2,unknowns);
unknowns = lsqnonlin(OF2,unknowns0,1E-3,10,options2);
priors = unknowns;
params2.beta= unknowns;
unknowns0 = unknowns;
Beta(jj+1) = unknowns;
[~,y2B] = ode45(@(t,y)seir_death_age_beta_b20221011(t,y,params2),t_actual(jj:jj+1),yinit2,options);
yinit2 = y2B(end,:);
yb2(jj+1,:) = yinit2;
% auxA(jj)=basic_reproduction_rate_beta(Proportion,params2,Beta(jj+1),t_actual(jj+1));
end

NewCasesBoot(:,ll) = sigma*yb2(:,2)'*N;
% NewDeathsBoot(:,ll) = params.Death*factorD.*yb2(:,3)*N;
BETABoot(ll,:) = Beta';
% R0Boot(ll,:) = auxA;
end