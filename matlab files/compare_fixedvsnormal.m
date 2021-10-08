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


standard_deviations_array_write_out = [];
standard_deviations_array_write_in = [];

mean_latency_array_write_out = [];




% m100 s0
standard_deviation=0.0


% input
Y=importdata(path_in_m100_s0_write);
S=std(Y);
standard_deviations_array_write_in = [standard_deviations_array_write_in; S]

% figure, plot(Y)
subplot(2,1,1)
histogram(Y)
title('Normal Distribtion N(m=100,s=0), 10 tps')
xlim([0 110])
ylim([0 4200])

ylabel('Number of transactions')

mean(Y)
std(Y)

% fixed rate 100
    
% input
Y=importdata(path_in_fixed_rate_write);
S=std(Y);
standard_deviations_array_write_in = [standard_deviations_array_write_in; S]

% figure, plot(Y)
subplot(2,1,2)
histogram(Y)
title('Fixed Rate Algorithm D(m=100), 10 tps')
xlim([0 110])
ylim([0 4200])

xlabel('Input interval size (ms)')
ylabel('Number of transactions')


mean(Y)
std(Y)


