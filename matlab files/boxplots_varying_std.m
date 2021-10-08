close all
clc
clear

% m100 s100
path_out_m100_s100_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_new_outputs_m100_s100_write.txt';
path_in_m100_s100_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_new_inputs_m100_s100_write.txt';

% m100 s50
path_out_m100_s50_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_outputs_m100_s50_write.txt';
path_in_m100_s50_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_inputs_m100_s50_write.txt';

% m100 s10
path_out_m100_s10_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_new_outputs_m100_s10_write.txt';
path_in_m100_s10_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_new_inputs_m100_s10_write.txt';

% m100 s5
path_out_m100_s5_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_outputs_m100_s5_write.txt';
path_in_m100_s5_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_inputs_m100_s5_write.txt';

% m100 s1
path_out_m100_s1_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_new_outputs_m100_s1_write.txt';
path_in_m100_s1_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_new_inputs_m100_s1_write.txt';

% m100 s0
path_out_m100_s0_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_new_outputs_m100_s0_write.txt';
path_in_m100_s0_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_new_inputs_m100_s0_write.txt';

% fixed rate
path_out_fixed_rate_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_new_outputs_fixed_rate_write.txt';
path_in_fixed_rate_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_new_inputs_fixed_rate_write.txt';

% fixed load
path_out_fixed_load_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_outputs_fixed_load_write.txt';
path_in_fixed_load_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_inputs_fixed_load_write.txt';


mean_latency_array_write_out = [];






Ym100_s100_write=importdata(path_out_m100_s100_write);
mean_latency_array_write_out = [mean_latency_array_write_out; mean(Ym100_s100_write)]

figure
subplot(3,2,6)
histogram(Ym100_s100_write)
title('s=100, 10 tps, N(m=100,s=100)')
xlabel('Latency (ms)')
xlim([0 2500])
ylim([0 600])



Ym100_s50_write=importdata(path_out_m100_s50_write);
mean_latency_array_write_out = [mean_latency_array_write_out; mean(Ym100_s50_write)]

subplot(3,2,5)
histogram(Ym100_s50_write)
title('s=50, 10 tps, N(m=100,s=50)')
xlabel('Latency (ms)')
xlim([0 2500])
ylim([0 600])


figure

Ym100_s10_write=importdata(path_out_m100_s10_write);
mean_latency_array_write_out = [mean_latency_array_write_out; mean(Ym100_s10_write)]

subplot(2,2,4)
histogram(Ym100_s10_write)
title('s=10, 10 tps, N(m=100,s=10)')
xlim([0 2500])
ylim([0 600])



Ym100_s5_write=importdata(path_out_m100_s5_write);
mean_latency_array_write_out = [mean_latency_array_write_out; mean(Ym100_s5_write)]

subplot(2,2,3)
histogram(Ym100_s5_write)
title('s=5, 10 tps, N(m=100,s=5)')
ylabel('Number of transactions')
xlabel('Latency (ms)')
xlim([0 2500])
ylim([0 600])



Ym100_s1_write=importdata(path_out_m100_s1_write);
mean_latency_array_write_out = [mean_latency_array_write_out; mean(Ym100_s1_write)]


subplot(2,2,2)
histogram(Ym100_s1_write)
title('s=1, 10 tps, N(m=100,s=1)')
xlim([0 2500])
ylim([0 600])



Ym100_s0_write=importdata(path_out_m100_s0_write);
mean_latency_array_write_out = [mean_latency_array_write_out; mean(Ym100_s0_write)]

subplot(2,2,1)
histogram(Ym100_s0_write)
title('s=0, 10 tps, N(m=100,s=0)')
xlim([0 2500])
ylim([0 600])



Y_padded_with_Nan = [[Ym100_s0_write; NaN(67,1)],[Ym100_s1_write; NaN(66,1)],[Ym100_s5_write; NaN(63,1)],[Ym100_s10_write; NaN(72,1)]]


%msmt_points = [0.5,1,5,10,50,100]
msmt_points = [0.5,1,5,10]
msmt_points_gaps = diff(msmt_points)/2
% gaps are a bit off...

%whsk = 1.5
%whsk = 3
whsk = 10
%whsk = 0.7193

%q = quantile(Y_padded_with_Nan, [0.05, 0.95])
%q5=q(1)
%q95=q(2)

figure
%b = boxplot(Y_padded_with_Nan,'Labels',{'0','1','5','10','50','100'},'Positions',msmt_points, 'Widths', [msmt_points_gaps(1) msmt_points_gaps], 'Whisker', whsk)
b = boxplot(Y_padded_with_Nan,'Labels',{'0','1','5','10'},'Positions',msmt_points, 'Widths', [msmt_points_gaps(1) msmt_points_gaps], 'Whisker', whsk)

set(gca,'XScale','log')
xlim([0 15])

% changing blue box causes errors...
%set(b(5,1), 'YData', [q5 q95 q95 q5])

xlabel('Standard Deviation of Input Data (ms), Log Scale')
ylabel('Write Latency (ms)')




mean(Ym100_s0_write)
std(Ym100_s0_write)


mean(Ym100_s1_write)
std(Ym100_s1_write)


mean(Ym100_s5_write)
std(Ym100_s5_write)


mean(Ym100_s10_write)
std(Ym100_s10_write)



hold on
plot(0.5,mean(Ym100_s0_write), 'o', 'MarkerFaceColor', 'g')
plot(1,mean(Ym100_s1_write), 'o', 'MarkerFaceColor', 'g')
plot(5,mean(Ym100_s5_write), 'o', 'MarkerFaceColor', 'g')
plot(10,mean(Ym100_s10_write), 'o', 'MarkerFaceColor', 'g')


%%

%inputs too!

figure

bins = [0:200]

Ym100_s10_write=importdata(path_in_m100_s10_write);
mean_latency_array_write_out = [mean_latency_array_write_out; mean(Ym100_s10_write)]

subplot(2,2,4)
histogram(Ym100_s10_write, bins)
title('Configured standard deviation = 10')
xlabel('Interval size (ms)')
xlim([50 150])
ylim([0 4000])



Ym100_s5_write=importdata(path_in_m100_s5_write);
mean_latency_array_write_out = [mean_latency_array_write_out; mean(Ym100_s5_write)]

subplot(2,2,3)
histogram(Ym100_s5_write, bins)
title('Configured standard deviation = 5')
ylabel('Number of transactions')
xlabel('Interval size (ms)')
xlim([50 150])
ylim([0 4000])



Ym100_s1_write=importdata(path_in_m100_s1_write);
mean_latency_array_write_out = [mean_latency_array_write_out; mean(Ym100_s1_write)]


subplot(2,2,2)
histogram(Ym100_s1_write, bins)
title('Configured standard deviation = 1')
xlim([50 150])
ylim([0 4000])



Ym100_s0_write=importdata(path_in_m100_s0_write);
mean_latency_array_write_out = [mean_latency_array_write_out; mean(Ym100_s0_write)]

subplot(2,2,1)
histogram(Ym100_s0_write, bins)
title('Configured standard deviation = 0')
ylabel('Number of transactions')
xlim([50 150])
ylim([0 4000])

mean(Ym100_s0_write)
std(Ym100_s0_write)


mean(Ym100_s1_write)
std(Ym100_s1_write)


mean(Ym100_s5_write)
std(Ym100_s5_write)


mean(Ym100_s10_write)
std(Ym100_s10_write)









