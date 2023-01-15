function f = jumpCDF20220930(kappa,theta,xi,lambda,mu,sigma,p)

dz = 0.01;
xmax = 10;
dx = xmax/3000;
zmax = 5;
zmin=-zmax;
x = 0:dx:xmax;
z = zmin:dz:zmax;

K1 = 1;
K2 = lambda*(exp(0.5*sigma^2+mu)-1);

A = kappa*theta-(kappa+2*xi^2+K2)*x;
B = (kappa -K1+K2+xi^2);
C = 0.5*xi^2*x.^2;

AA = 0.5*A/dx - C/dx^2;
BB = 2*C/dx^2-B;
CC = -0.5*A/dx-C/dx^2;

H = diag(BB);
aux = zeros(size(H));
aux(1:end-1,2:end) = diag(AA(1:end-1));
H = H+aux;
aux = zeros(size(H));
aux(2:end,1:end-1) = diag(CC(2:end));
H = H+aux;
phi = sin(x/x(end)*pi);
phi(1)=zeros;
phi(end)=zeros;
phi = phi/(0.5*dx*sum(phi(1:end-1)+phi(2:end)));
intPhi = zeros(size(x));
density = exp(-0.5*(z-mu).^2/sigma^2);
density = density/(0.5*dz*sum(density(1:end-1)+density(2:end)));

 
for ii = 1:100
phi0=phi;
PHI = zeros(length(x),length(z));
for jj = 2:length(x)-1
aux = x(jj)./(1+lambda*(exp(z)-1));
PHI(jj,:) = interp1([x,max(x(end)./(1+lambda*(exp(z)-1)))],[phi0,0],aux);
PHI(jj,:) = PHI(jj,:).*1./(1+lambda*(exp(z)-1));
PHI(jj,:) = PHI(jj,:).*density;
intPhi(jj)=0.5*dz*sum(PHI(jj,1:end-1)+PHI(jj,2:end));
end
phi(2:end-1) = max(0,(H(2:end-1,2:end-1)\intPhi(2:end-1)')');
phi = phi/(0.5*dx*sum(phi(1:end-1)+phi(2:end)));
if norm(phi-phi0)/norm(phi0)<=1E-6
    break
end
end
disp(['Residual: ',num2str(norm(phi-phi0))])
aux = interp1([x,1000],[phi,0],x(1):dx:p);
f = 1-0.5*dx*sum(aux(1:end-1)+aux(2:end));
