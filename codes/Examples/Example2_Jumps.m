close all; clc;
n=25;

sigmaB = 1/5.1;
gamma = 1/12;
delta = 1/14;
muB = zeros;
x = sigmaB/((gamma+delta+muB)*(sigmaB+muB));

theta=0.2;
xi=0.4;

Aux1 = [0.01,0.1,0.5,1];
Aux2 = [-1,0,1]; 
Aux3 = [0.01,0.1,0.5,1,1.5];
for ss=3:length(Aux3)
for ll = length(Aux2)
F=zeros(n,length(Aux1));
for ii = 1:length(Aux1)
aux = zeros(n,4);
aux(:,1) = linspace(0.01,2,n);
aux(:,2) = Aux1(ii)*ones(n,1);
aux(:,3) = Aux2(ll)*ones(n,1);
aux(:,4) = Aux3(ss)*ones(n,1);
for jj=1:n
kappa=aux(jj,1);
lambda = aux(jj,2);
mu = aux(jj,3);
sigma = aux(jj,4);
F(jj,ii) = jumpCDF20220930(kappa,theta,xi,lambda,mu,sigma,1/x);
end
end
k = 0.5*(xi^2+Aux1.^2*(exp(2*(sigma^2+mu))-2*exp(0.5*sigma^2+mu)+1));
k2=zeros(size(k));
for jj=1:length(Aux1)
k2(jj) = interp1(aux(:,1),F(:,jj),k(jj));
end

figure
hold on
box on
grid on
title(['Mean = ',num2str(mu),', Std. Dev.= ',num2str(sigma)])
plot(aux(:,1),F(:,1),'k','LineWidth',2)
plot(aux(:,1),F(:,2),'r','LineWidth',2)
plot(aux(:,1),F(:,3),'b','LineWidth',2)
plot(aux(:,1),F(:,4),'m','LineWidth',2)
plot(k(1),k2(1),'sk','MarkerFaceColor','k','MarkerSize',8)
plot(k(2),k2(2),'sr','MarkerFaceColor','r','MarkerSize',8)
plot(k(3),k2(3),'sb','MarkerFaceColor','b','MarkerSize',8)
plot(k(4),k2(4),'sm','MarkerFaceColor','m','MarkerSize',8)
ylim([0,1.0])
xlim([-0.2,aux(end,1)])
xlabel('\kappa')
ylabel('P(R_\infty\geq 1)')
if ll==length(Aux2)
legend(['\lambda = ',num2str(Aux1(1))],['\lambda = ',num2str(Aux1(2))],...
    ['\lambda = ',num2str(Aux1(3))],['\lambda = ',num2str(Aux1(4))],'Location','NorthWest')
end
hold off
set(gca,'FontSize',16,'FontName','Arial')
hold off
saveas(gcf,['Example2_',num2str(ll),'_',num2str(ss),'.fig']);
print('-dpng',['Example2_',num2str(ll),'_',num2str(ss)]);
end
end