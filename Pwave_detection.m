close all
clear
clc

%%

Fs = 250; % [Hz]

sig = load('sel33.dat','-ascii');

ECG = sig(:,1); % First channel

[qrs, pN] = textread('sel33.q1c','%d %c'); % Annotations

N = find ( pN == 'N');

figure
plot(ECG)
hold on
plot(qrs(N),ECG(qrs(N)),'*')
title 'Annotated peaks in the entire signal'


figure
plot(ECG)
hold on
plot(qrs(N),ECG(qrs(N)),'*')
title 'Zoom on the zone of interest'
xlim([qrs(1)-Fs, qrs(end)+Fs])
%%
% Sobstitute QRS complexs with isoelectric line:

start = N-1;   % Indexes of the beginning of QRS complexs
stop = N+1;    % Indexes of the end of QRS complexs
ECGnew = ECG;
for i = 1:length(N)
ECGnew(qrs(start(i)):qrs(stop(i))) = linspace(ECG(qrs(start(i))),ECG(qrs(stop(i))),length(qrs(start(i)):qrs(stop(i))));
end

figure
plot(ECG,'--r')
hold on
plot (ECGnew,'b')
title 'Removed peaks'
xlim([qrs(1)-Fs, qrs(end)+Fs])

BP = load('BP_3_11.mat');

y = filter (BP.Num,1,ECGnew);   % Signal filtered with bandpass (3 - 11 Hz)
delay = floor(length(BP.Num)/2);

y(1:delay) = [];   % To align the filtered signal to the original one

% figure
% plot(y)
% xlim([qrs(1)-Fs, qrs(end)+Fs])
% title 'Filtered Signal'

%%
% Identify the period of research of P wave, computed as:
%  (2/9)*RR +250ms
% where RR is the mean RR computed in the present annotations.
 
RR = mean(qrs(N(2:end)) - qrs(N(1:end-1)));

period = floor((2/9)*RR + (250e-3)*Fs);

% Create an array that contains, in each line, a tract long "period" before QRS (P waves):
P_waves = zeros(length(N), period);
y = y'; 
ECGnew=ECGnew';

for i = 1:length(N)
    P_waves(i,:) = y(qrs(N(i)) - period : qrs(N(i)) -1);
end
    
synchronized_mean = mean(P_waves);


figure
plot(synchronized_mean,'r','linewidth',2)
hold on
plot(P_waves')
hold on
plot(synchronized_mean,'r','linewidth',2)
title 'P waves'
legend('Synchronized mean')

figure
plot(synchronized_mean)
title 'Synchronized Mean'
    
