close all; clc;
H = [100,100,700,400];
datas = [t_span(len0-len-s-2),datetime(2020,10:12,01),t_span(len0-s+extend-2)];
yt = 0:0.05:0.4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
grid off
box on
title(['Period ',datestr(datas(1),formatOut),' to ',datestr(datas(end),formatOut)])
h1=area(t_span(len0-len-s-2:len0-s+extend-2),B_MR(:,end),'linestyle',':','FaceColor','b','FaceAlpha',0.4);
h2=area(t_span(len0-len-s-2:len0-s+extend-2),B_MR(:,2),'linestyle',':','FaceColor',[1,1,1]);
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
plot(t_span(len0-len-s-2:len0-s+extend-2),BETA(len0-len-s-1:len0-s+extend-1,1),'k','LineWidth',2)
plot(t_span(len0-len-s-2:len0-s+extend-2),B_MR(:,1),'--b','LineWidth',1)
for jj = 1:length(datas)
plot([datas(jj),datas(jj)],[yt(1),yt(end)],':k')
end
for jj = 1:length(yt)
plot([t_span(len0-len-s-2),t_span(len0-s+extend-2)],yt(jj)*ones(1,2),':k')
end
plot([t_span(len0),t_span(len0)],[yt(1),yt(end)],'k')
txt = {'Out-of-Sample Predictions'};
tt = text(t_span(len0)+2,yt(end)-0.02,txt,'FontSize',14,'FontName','Arial');
legend('Observed','MR','Location','NorthWest')
ylabel('\beta(t)')
xlabel('time (days)')
ylim([yt(1),yt(end)])
xlim([t_span(len0-len-s-2),t_span(len0-s+extend-2)])
xticks(datas(1:end-1))
% xtickformat('MMM')
set(gcf,'Position',H)
set(gca,'FontSize',16,'FontName','Arial')
hold off
print('-dpng','beta_PerMR')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
grid off
box on
title(['Period ',datestr(datas(1),formatOut),' to ',datestr(datas(end),formatOut)])
h1=area(t_span(len0-len-s-2:len0-s+extend-2),B_LMR(:,end),'linestyle',':','FaceColor','b','FaceAlpha',0.4);
h2=area(t_span(len0-len-s-2:len0-s+extend-2),B_LMR(:,2),'linestyle',':','FaceColor',[1,1,1]);
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
plot(t_span(len0-len-s-2:len0-s+extend-2),BETA(len0-len-s-1:len0-s+extend-1,1),'k','LineWidth',2)
plot(t_span(len0-len-s-2:len0-s+extend-2),B_LMR(:,1),'--b','LineWidth',1)
for jj = 1:length(datas)
plot([datas(jj),datas(jj)],[yt(1),yt(end)],':k')
end
for jj = 1:length(yt)
plot([t_span(len0-len-s-2),t_span(len0-s+extend-2)],yt(jj)*ones(1,2),':k')
end
plot([t_span(len0),t_span(len0)],[yt(1),yt(end)],'k')
txt = {'Out-of-Sample Predictions'};
tt = text(t_span(len0)+2,yt(end)-0.02,txt,'FontSize',14,'FontName','Arial');
legend('Observed','LMR','Location','NorthWest')
ylabel('\beta(t)')
xlabel('time (days)')
ylim([yt(1),yt(end)])
xlim([t_span(len0-len-s-2),t_span(len0-s+extend-2)])
xticks(datas(1:end-1))
% xtickformat('MMM')
set(gcf,'Position',H)
set(gca,'FontSize',16,'FontName','Arial')
hold off
print('-dpng','beta_PerLMR')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
grid off
box on
title(['Period ',datestr(datas(1),formatOut),' to ',datestr(datas(end),formatOut)])
h1=area(t_span(len0-len-s-2:len0-s+extend-2),B_MRJ(:,end),'linestyle',':','FaceColor','b','FaceAlpha',0.4);
h2=area(t_span(len0-len-s-2:len0-s+extend-2),B_MRJ(:,2),'linestyle',':','FaceColor',[1,1,1]);
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
plot(t_span(len0-len-s-2:len0-s+extend-2),BETA(len0-len-s-1:len0-s+extend-1,1),'k','LineWidth',2)
plot(t_span(len0-len-s-2:len0-s+extend-2),B_MRJ(:,1),'--b','LineWidth',1)
for jj = 1:length(datas)
plot([datas(jj),datas(jj)],[yt(1),yt(end)],':k')
end
for jj = 1:length(yt)
plot([t_span(len0-len-s-2),t_span(len0-s+extend-2)],yt(jj)*ones(1,2),':k')
end
plot([t_span(len0),t_span(len0)],[yt(1),yt(end)],'k')
txt = {'Out-of-Sample Predictions'};
tt = text(t_span(len0)+2,yt(end)-0.02,txt,'FontSize',14,'FontName','Arial');
legend('Observed','MRJ','Location','NorthWest')
ylabel('\beta(t)')
xlabel('time (days)')
ylim([yt(1),yt(end)])
xlim([t_span(len0-len-s-2),t_span(len0-s+extend-2)])
xticks(datas(1:end-1))
% xtickformat('MMM')
set(gcf,'Position',H)
set(gca,'FontSize',16,'FontName','Arial')
hold off
print('-dpng','beta_PerMRJ')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
grid off
box on
title(['Period ',datestr(datas(1),formatOut),' to ',datestr(datas(end),formatOut)])
h1=area(t_span(len0-len-s-2:len0-s+extend-2),B_LMRJ(:,end),'linestyle',':','FaceColor','b','FaceAlpha',0.4);
h2=area(t_span(len0-len-s-2:len0-s+extend-2),B_LMRJ(:,2),'linestyle',':','FaceColor',[1,1,1]);
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
plot(t_span(len0-len-s-2:len0-s+extend-2),BETA(len0-len-s-1:len0-s+extend-1,1),'k','LineWidth',2)
plot(t_span(len0-len-s-2:len0-s+extend-2),B_LMRJ(:,1),'--b','LineWidth',1)
for jj = 1:length(datas)
plot([datas(jj),datas(jj)],[yt(1),yt(end)],':k')
end
for jj = 1:length(yt)
plot([t_span(len0-len-s-2),t_span(len0-s+extend-2)],yt(jj)*ones(1,2),':k')
end
plot([t_span(len0),t_span(len0)],[yt(1),yt(end)],'k')
txt = {'Out-of-Sample Predictions'};
tt = text(t_span(len0)+2,yt(end)-0.02,txt,'FontSize',14,'FontName','Arial');
legend('Observed','LMRJ','Location','NorthWest')
ylabel('\beta(t)')
xlabel('time (days)')
ylim([yt(1),yt(end)])
xlim([t_span(len0-len-s-2),t_span(len0-s+extend-2)])
xticks(datas(1:end-1))
% xtickformat('MMM')
set(gcf,'Position',H)
set(gca,'FontSize',16,'FontName','Arial')
hold off
print('-dpng','beta_PerLMRJ')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
datas = [t_span(len0),datetime(2020,11,[1,15,30]),datetime(2020,12,14),t_span(len0+extend)];
yt = (0:2:10)*1E4;
figure
hold on
grid off
box on
title(['Period ',datestr(datas(1),formatOut),' to ',datestr(datas(end),formatOut)])
h1=area(t_span(len0:len0+extend),P5(:,end),'linestyle',':','FaceColor','b','FaceAlpha',0.4);
h2=area(t_span(len0:len0+extend),P5(:,2),'linestyle',':','FaceColor',[1,1,1]);
plot(t_span(len0:len0+extend),D,'k','LineWidth',2)
plot(t_span(len0:len0+extend),P5(:,1),'--b','LineWidth',2)
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
legend('Observed','MR','Location','NorthWest')
ylabel('Accumulated Infections')
% xlabel('Number of Days Ahead')
xlim([t_span(len0),t_span(len0+extend)])
for jj = 1:length(datas)
h=plot([datas(jj),datas(jj)],[0,1E5],':k');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
end
for jj = 1:length(yt)
h=plot([t_span(len0),t_span(len0+extend)],yt(jj)*ones(1,2),':k');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
end
ylim([yt(1),yt(end)])
xticks(datas(1:end-1))
% xtickformat('MMM')
set(gcf,'Position',H)
set(gca,'FontSize',16,'FontName','Arial')
hold off
print('-dpng',['Infections_PerMR',num2str(vv)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
hold on
grid off
box on
title(['Period ',datestr(datas(1),formatOut),' to ',datestr(datas(end),formatOut)])
h1=area(t_span(len0:len0+extend),P6(:,end),'linestyle',':','FaceColor','b','FaceAlpha',0.4);
h2=area(t_span(len0:len0+extend),P6(:,2),'linestyle',':','FaceColor',[1,1,1]);
plot(t_span(len0:len0+extend),D,'k','LineWidth',2)
plot(t_span(len0:len0+extend),P6(:,1),'--b','LineWidth',2)
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
legend('Observed','LMR','Location','NorthWest')
ylabel('Accumulated Infections')
% xlabel('Number of Days Ahead')
xlim([t_span(len0),t_span(len0+extend)])
for jj = 1:length(datas)
h=plot([datas(jj),datas(jj)],[0,1E5],':k');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
end
for jj = 1:length(yt)
h=plot([t_span(len0),t_span(len0+extend)],yt(jj)*ones(1,2),':k');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
end
ylim([yt(1),yt(end)])
xticks(datas(1:end-1))
% xtickformat('MMM')
set(gcf,'Position',H)
set(gca,'FontSize',16,'FontName','Arial')
hold off
print('-dpng',['Infections_PerLMR',num2str(vv)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
hold on
grid off
box on
title(['Period ',datestr(datas(1),formatOut),' to ',datestr(datas(end),formatOut)])
h1=area(t_span(len0:len0+extend),P5B(:,end),'linestyle',':','FaceColor','b','FaceAlpha',0.4);
h2=area(t_span(len0:len0+extend),P5B(:,2),'linestyle',':','FaceColor',[1,1,1]);
plot(t_span(len0:len0+extend),D,'k','LineWidth',2)
plot(t_span(len0:len0+extend),P5B(:,1),'--b','LineWidth',2)
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
legend('Observed','MRJ','Location','NorthWest')
ylabel('Accumulated Infections')
% xlabel('Number of Days Ahead')
xlim([t_span(len0),t_span(len0+extend)])
for jj = 1:length(datas)
h=plot([datas(jj),datas(jj)],[0,1E5],':k');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
end
for jj = 1:length(yt)
h=plot([t_span(len0),t_span(len0+extend)],yt(jj)*ones(1,2),':k');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
end
ylim([yt(1),yt(end)])
xticks(datas(1:end-1))
% xtickformat('MMM')
set(gcf,'Position',H)
set(gca,'FontSize',16,'FontName','Arial')
hold off
print('-dpng',['Infections_PerMRJ',num2str(vv)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
hold on
grid off
box on
title(['Period ',datestr(datas(1),formatOut),' to ',datestr(datas(end),formatOut)])
h1=area(t_span(len0:len0+extend),P6B(:,end),'linestyle',':','FaceColor','b','FaceAlpha',0.4);
h2=area(t_span(len0:len0+extend),P6B(:,2),'linestyle',':','FaceColor',[1,1,1]);
plot(t_span(len0:len0+extend),D,'k','LineWidth',2)
plot(t_span(len0:len0+extend),P6B(:,1),'--b','LineWidth',2)
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
legend('Observed','LMRJ','Location','NorthWest')
ylabel('Accumulated Infections')
% xlabel('Number of Days Ahead')
xlim([t_span(len0),t_span(len0+extend)])
for jj = 1:length(datas)
h=plot([datas(jj),datas(jj)],[0,1E5],':k');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
end
for jj = 1:length(yt)
h=plot([t_span(len0),t_span(len0+extend)],yt(jj)*ones(1,2),':k');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
end
ylim([yt(1),yt(end)])
xticks(datas(1:end-1))
% xtickformat('MMM')
set(gcf,'Position',H)
set(gca,'FontSize',16,'FontName','Arial')
hold off
print('-dpng',['Infections_PerLMRJ',num2str(vv)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

aux = sort(BETABoot);
MBETA = median(BETABoot);
aux2 = round(0.05*size(BETABoot,1));
aux = aux(aux2+1:end-aux2,:);
CIBETA = [min(aux);max(aux)]';

datas = [t_span(len0-len-s-2),datetime(2020,10:12,01),t_span(len0-s+extend-2)];
yt = 0:0.05:0.25;

figure
hold on
grid off
box on
title(['Period ',datestr(datas(1),formatOut),' to ',datestr(datas(end),formatOut)])
h1=area(t_span(len0-len-s-2:len0-s+extend-2),CIBETA(len0-len-s-2:len0-s+extend-2,2),'linestyle',':','FaceColor','b','FaceAlpha',0.4);
h2=area(t_span(len0-len-s-2:len0-s+extend-2),CIBETA(len0-len-s-2:len0-s+extend-2,1),'linestyle',':','FaceColor',[1,1,1]);
% h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
plot(t_span(len0-len-s-2:len0-s+extend-2),MBETA(len0-len-s-2:len0-s+extend-2),'k','LineWidth',2)
for jj = 1:length(datas)
plot([datas(jj),datas(jj)],[yt(1),yt(end)],':k')
end
for jj = 1:length(yt)
plot([t_span(len0-len-s-2),t_span(len0-s+extend-2)],yt(jj)*ones(1,2),':k')
end
legend('90% CI','Median','Location','NorthWest')
ylabel('\beta(t)')
xlabel('time (days)')
ylim([yt(1),yt(end)])
xlim([t_span(len0-len-s-2),t_span(len0-s+extend-2)])
xticks(datas(1:end-1))
% xtickformat('MMM')
set(gcf,'Position',H)
set(gca,'FontSize',16,'FontName','Arial')
hold off
print('-dpng','beta')