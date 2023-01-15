%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Reading Daily Cases and Deaths in Texas

aux = importdata('NYC_Data_20221010.txt');
dailyCasesDeaths = aux.data;
datesCD = string(aux.textdata(2:end,1));
datesCD = datetime(datesCD,'InputFormat','dd/MM/yyyy');

t_span = datesCD;

dataA = dailyCasesDeaths(1:end,:);
for jj=7:size(dataA,1)
for ii = 1:size(dataA,2)
dataA(jj,ii) = mean(dailyCasesDeaths(jj-6:jj,ii));
end
end

Population = 8336817;      


dailyData = [dataA(:,1),dataA(:,3)];
data2 = dailyData(1:end,:);
t_span = t_span(1:size(data2,1));
t_actual = 0:length(t_span);
