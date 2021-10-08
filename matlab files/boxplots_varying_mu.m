close all
clc
clear

path_throughput_10_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_throughput_10.txt';

path_throughput_15_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_throughput_15.txt';

path_throughput_20_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_throughput_20.txt';

path_throughput_25_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_throughput_25.txt';

path_throughput_30_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_throughput_30.txt';

path_throughput_50_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_throughput_50.txt';



mean_latency_array_write_out = [];



% skip
Ym50_s0_write=importdata(path_throughput_50_write);
mean_latency_array_write_out = [mean_latency_array_write_out; mean(Ym50_s0_write)]

figure, histogram(Ym50_s0_write)
title('write execution time, N(m=100,s=100)')



% skip
Ym30_s0_write=importdata(path_throughput_30_write);
mean_latency_array_write_out = [mean_latency_array_write_out; mean(Ym30_s0_write)]

figure, histogram(Ym30_s0_write)
title('write execution time, N(m=100,s=50)')




%%

edges = [0:50:4000];

Ym25_s0_write=importdata(path_throughput_25_write);
mean_latency_array_write_out = [mean_latency_array_write_out; mean(Ym25_s0_write)]

figure
subplot(2,2,4)
histogram(Ym25_s0_write, edges)
%title('25 tps, N(m=40,s=0)')
title('25 tps, 40 ms mean interval')
xlabel('Latency (ms)')
ylim([0 1600])


Ym20_s0_write=importdata(path_throughput_20_write);
mean_latency_array_write_out = [mean_latency_array_write_out; mean(Ym20_s0_write)]

subplot(2,2,3)
histogram(Ym20_s0_write, edges)
title('20 tps, 50 ms mean interval')
xlabel('Latency (ms)')
ylabel('Number of transactions')
ylim([0 1600])


Ym15_s0_write=importdata(path_throughput_15_write);
mean_latency_array_write_out = [mean_latency_array_write_out; mean(Ym15_s0_write)]

subplot(2,2,2)
histogram(Ym15_s0_write, edges)
title('15 tps, 67 ms mean interval')
ylim([0 1600])


Ym10_s0_write=importdata(path_throughput_10_write);
mean_latency_array_write_out = [mean_latency_array_write_out; mean(Ym10_s0_write)]

subplot(2,2,1)
histogram(Ym10_s0_write, edges)
title('10 tps, 100 ms mean interval')
ylabel('Number of transactions')
ylim([0 1600])


Y_padded_with_Nan = [[Ym10_s0_write; NaN(20191,1)],[Ym15_s0_write; NaN(15191,1)],[Ym20_s0_write; NaN(10191,1)],[Ym25_s0_write; NaN(5191,1)]]


msmt_points = [10,15,20,25]
msmt_points_gaps = diff(msmt_points)/2
% gaps are a bit off...

%whsk = 1.5
%whsk = 3
whsk = 10
%whsk = 0.7193


lbls= {'10','15','20','25'}

figure
b = boxplot(Y_padded_with_Nan,'Labels',lbls,'Positions',msmt_points, 'Widths', [msmt_points_gaps(1) msmt_points_gaps], 'Whisker', whsk)

%set(gca,'XScale','log')
%xlim([0 150])

% changing blue box causes errors...
%set(b(5,1), 'YData', [q5 q95 q95 q5])

xlabel('Input Rate (tps)')
ylabel('Write Latency (ms)')



mean(Ym10_s0_write)
std(Ym10_s0_write)

mean(Ym15_s0_write)
std(Ym15_s0_write)

mean(Ym20_s0_write)
std(Ym20_s0_write)

mean(Ym25_s0_write)
std(Ym25_s0_write)


hold on
plot(10,mean(Ym10_s0_write), 'o', 'MarkerFaceColor', 'g')
plot(15,mean(Ym15_s0_write), 'o', 'MarkerFaceColor', 'g')
plot(20,mean(Ym20_s0_write), 'o', 'MarkerFaceColor', 'g')
plot(25,mean(Ym25_s0_write), 'o', 'MarkerFaceColor', 'g')




