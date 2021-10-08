close all
clc
clear


% fixed rate
path_out_fixed_rate_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_new_outputs_fixed_rate_write.txt';
path_in_fixed_rate_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_new_inputs_fixed_rate_write.txt';

% fixed load
path_out_fixed_load_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_outputs_fixed_load_write.txt';
path_in_fixed_load_write = 'C:\Users\rune\Documents\BTH\Thesis\hyperledger\BasicNetwork-my-version\results\caliper_outputs\exp_batch_inputs_fixed_load_write.txt';

xbins = [0:50:2500];
ybins = [0:50:2500];



% fixed rate 100

% output
Y=importdata(path_out_fixed_rate_write);

% figure, plot(Y)
subplot(2,2,3)
histogram(Y, ybins)
title('Fixed Rate Output, 10 tps')
xlabel('Write Latency (ms)')
ylabel('Number of Transactions')
xlim([-10 2500])
ylim([0 3500])

mean(Y)
std(Y)

rate_out = length(Y)

% input
Y=importdata(path_in_fixed_rate_write);

% figure, plot(Y)
subplot(2,2,1)
histogram(Y, xbins)
title('Fixed Rate Input, 10 tps')
xlabel('Request Interval (ms)')
ylabel('Number of Transactions')
xlim([-10 2500])
ylim([0 11000])

mean(Y)
std(Y)

rate_in = length(Y)

% fixed load 100

% output
Y=importdata(path_out_fixed_load_write);

% figure, plot(Y)
subplot(2,2,4)
histogram(Y, ybins)
title('Fixed Load Output, 10 tps')
xlabel('Write Latency (ms)')
%ylabel('Number of Transactions')

xlim([-10 2500])
ylim([0 3500])


mean(Y)
std(Y)

load_out = length(Y)

% input
Y=importdata(path_in_fixed_load_write);

% figure, plot(Y)
subplot(2,2,2)
histogram(Y, xbins)
title('Fixed Load Input, 10 tps')
xlabel('Request Interval (ms)')
%ylabel('Number of Transactions')

xlim([-10 2500])
ylim([0 11000])


load_in = length(Y)

mean(Y)
std(Y)


