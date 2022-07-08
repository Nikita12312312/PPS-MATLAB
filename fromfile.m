clc;
clear;
fpga_freq = 769996956; % частота генератора ПЛИС
N = 7246; % количество отсчётов

folder_with_log_files = '\Users\nf010\Documents\Log_files\';
addpath(folder_with_log_files);
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++
F1 = fopen( [folder_with_log_files 'log_file1.bin']);
status11 = fseek(F1,16,'bof');
f1_num = fread(F1,N,'uint64',8);
status12 = fseek(F1,24,'bof');
f1_dat = fread(F1,N,'uint64',8);
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++
F2 = fopen('log_file2.bin');
status21 = fseek(F2,16,'bof');
f2_num = fread(F2,2000,'uint64',8);
status22 = fseek(F2,24,'bof');
f2_dat = fread(F2,2000,'uint64',8);
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++
F3 = fopen('log_file3.bin');
status31 = fseek(F3,16,'bof');
f3_num = fread(F3,N,'uint64',8);
status32 = fseek(F3,24,'bof');
f3_dat = fread(F3,N,'uint64',8);
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++
F4 = fopen( [folder_with_log_files 'log_file4.bin']);
status41 = fseek(F4,16,'bof');
f4_num = fread(F4,N,'uint64',8);
status42 = fseek(F4,24,'bof');
f4_dat = fread(F4,N,'uint64',8);
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++

q1_dat = diff(f1_dat) / fpga_freq;
q2_dat = diff(f2_dat) / fpga_freq;
q3_dat = diff(f3_dat) / fpga_freq;
q4_dat = diff(f4_dat) / fpga_freq;

% q1_dat = diff(f1_dat);
% q2_dat = diff(f2_dat);
% q3_dat = diff(f3_dat);
% q4_dat = diff(f4_dat);

window = 5;

q1_filt = smoothdata(q1_dat, 'movmean', window);
q2_filt = smoothdata(q2_dat, 'movmean', window);
q3_filt = smoothdata(q3_dat, 'movmean', window);
q4_filt = smoothdata(q4_dat,'movmean', window);

q1_dif = q1_dat - q1_filt;
q2_dif = q2_dat - q2_filt;
q3_dif = q3_dat - q3_filt;
q4_dif = q4_dat - q4_filt;

SKO_FILT_1 = std(q1_dif);
SKO_FILT_2 = std(q2_dif);
SKO_FILT_3 = std(q3_dif);
SKO_FILT_4 = std(q4_dif);

figure()
subplot(2,2,1);
plot(q1_dif);
xlabel('Номер импульса');
ylabel('Разность времени, c');
grid on;
subplot(2,2,2);
plot(q2_dif);
xlabel('Номер импульса');
ylabel('Разность времени, c');
grid on;
subplot(2,2,3);
plot(q3_dif);
xlabel('Номер импульса');
ylabel('Разность времени, c');
grid on;
subplot(2,2,4);
plot(q4_dif);
xlabel('Номер импульса');
ylabel('Разность времени, c');
grid on;
sgtitle('Разность полученных значений периодов с усреднёнными');

figure()
subplot(2,2,1)
plot(q1_dat);
hold on;
plot(q1_filt, 'k:');
xlabel('Номер импульса');
ylabel('Период, с');
grid on;
subplot(2,2,2)
plot(q2_dat);
hold on;
plot(q2_filt, 'k:');
xlabel('Номер импульса');
ylabel('Период, с');
grid on;
grid on;
subplot(2,2,3)
plot(q3_dat);
hold on;
plot(q3_filt, 'k:');
xlabel('Номер импульса');
ylabel('Период, с');
grid on;
subplot(2,2,4)
plot(q4_dat);
hold on;
plot(q4_filt, 'k:');
xlabel('Номер импульса');
ylabel('Период, с');
grid on;
legend('Полученные','Усреднённые');
sgtitle('Полученные экспериментальные и усреднённые значения периодов');

% Оценка математического ожидания, дисперсии и СКО
M1 = mean(q1_dat);
D1 = var(q1_dat);
M2 = mean(q2_dat);
D2 = var(q2_dat);
M3 = mean(q3_dat);
D3 = var(q3_dat);
M4 = mean(q4_dat);
D4 = var(q4_dat);
sigma1 = std(q1_dat);
sigma2 = std(q2_dat);
sigma3 = std(q3_dat);
sigma4 = std(q4_dat);
Str1 = sprintf('Мат. ожидание: %d;\nДисперсия: %d;\n СКО: %d; \n', M1, D1, sigma1);
Str2 = sprintf('Мат. ожидание: %d;\nДисперсия: %d;\n СКО: %d; \n', M2, D2, sigma2);
Str3 = sprintf('Мат. ожидание: %d;\nДисперсия: %d;\n СКО: %d; \n', M3, D3, sigma3);
Str4 = sprintf('Мат. ожидание: %d;\nДисперсия: %d;\n СКО: %d; \n', M4, D4, sigma4);
disp(Str1);
disp(Str2);
disp(Str3);
disp(Str4);
fclose(F1);
fclose(F2);
fclose(F3);
fclose(F4);

% Check_period1 = zeros(1,length(q1_dat));
% Check_period2 = zeros(1,length(q2_dat));
% Check_period3 = zeros(1,length(q3_dat));
% Check_period4 = zeros(1,length(q4_dat));
% 
% for i = 1:length(q1_dat)
% Check_period1(i) = 1 - q1_dat(i);
% % Check_period2(i) = 1 - q2_dat(i);
% Check_period3(i) = 1 - q3_dat(i);
% Check_period4(i) = 1 - q4_dat(i);
% end
% 
% M1check = mean(Check_period1);
% D1check = var(Check_period1);
% % M2check = mean(Check_period2);
% % D2check = var(Check_period2);
% M3check = mean(Check_period3);
% D3check = var(Check_period3);
% M4check = mean(Check_period4);
% D4check = var(Check_period4);
% sigma1check = std(Check_period1);
% % sigma2check = std(Check_period2);
% sigma3check = std(Check_period3);
% sigma4check = std(Check_period4);
% Str1check = sprintf('Мат. ожидание: %d;\nДисперсия: %d;\n СКО: %d; \n', M1check, D1check, sigma1check);
% % Str2check = sprintf('Мат. ожидание: %d;\nДисперсия: %d;\n СКО: %d; \n', M2check, D2check, sigma2check);
% Str3check = sprintf('Мат. ожидание: %d;\nДисперсия: %d;\n СКО: %d; \n', M3check, D3check, sigma3check);
% Str4check = sprintf('Мат. ожидание: %d;\nДисперсия: %d;\n СКО: %d; \n', M4check, D4check, sigma4check);
% disp(Str1check);
% % disp(Str2check);
% disp(Str3check);
% disp(Str4check);

%% Фиксация времени прихода

for i = 1:300
 Time41(i) = q4_dat(i) - q1_dat(i);
 Time42(i) = q4_dat(i) - q2_dat(i);
 Time43(i) = q4_dat(i) - q3_dat(i);
end
 
figure()
plot(Time41);
figure()
plot(Time42);
figure()
plot(Time43);

r41 = max(Time41) - min(Time41);
r42 = max(Time42) - min(Time42);
r43 = max(Time43) - min(Time43);

disp(r41);
disp(r42);
disp(r43);
 

 