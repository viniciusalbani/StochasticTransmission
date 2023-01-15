close all; clc;
n=50;

sigma = 1/5.1;
gamma = 1/12;
delta = 1/14;
mu = zeros;
x = sigma/((gamma+delta+mu)*(sigma+mu));

Aux1 = [0.01,0.05,0.1,0.2,0.3,0.4];
Aux2 = [0.01,0.1,0.2,0.4,0.6,0.8,1];
for ll = 1:length(Aux2)
F=zeros(n,length(Aux1));
for ii = 1:length(Aux1)
aux = zeros(n,3);
aux(:,1) = linspace(0.01,2,n);
aux(:,2) = Aux1(ii)*ones(n,1);
aux(:,3) = Aux2(ll)*ones(n,1);

for jj=1:n
kappa=aux(jj,1);
theta=aux(jj,2);
xi=aux(jj,3);
A = 2*kappa/xi^2+1;
B = xi^2/(2*kappa*theta);
F(jj,ii) = gamcdf(x,A,B);
end
end

figure
hold on
box on
grid on
title(['\xi = ',num2str(xi)])
plot(aux(:,1),F(:,1),'k','LineWidth',2)
plot(aux(:,1),F(:,2),'r','LineWidth',2)
plot(aux(:,1),F(:,3),'b','LineWidth',2)
plot(aux(:,1),F(:,4),'m','LineWidth',2)
plot(aux(:,1),F(:,5),'--k','LineWidth',2)
plot(aux(:,1),F(:,6),'--r','LineWidth',2)
plot([xi^2/2,xi^2/2],[0,1.1],'k','LineWidth',1)
ylim([0,1.0])
xlim([-0.2,aux(end,1)])
xlabel('\kappa')
ylabel('P(R_\infty\geq 1)')
if ll==length(Aux2)
legend(['\theta = ',num2str(Aux1(1))],['\theta = ',num2str(Aux1(2))],...
    ['\theta = ',num2str(Aux1(3))],['\theta = ',num2str(Aux1(4))],['\theta = ',num2str(Aux1(5))],...
    ['\theta = ',num2str(Aux1(6))],'Location','SouthEast')
end
hold off
set(gca,'FontSize',16,'FontName','Arial')
hold off
saveas(gcf,['Example1_',num2str(ll),'.fig']);
print('-dpng',['Example1_',num2str(ll)]);
end