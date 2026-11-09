data = readmatrix('encoder_samples.dat.txt');

time  = data(:,1);
freq  = data(:,2);
valid = data(:,3);
valid_shift = [valid(2:end);0];
valid = valid .* valid_shift;

time = time - time(1);
idx = (valid == 1);

figure;
plot(time(idx), freq(idx), 'b-');
xlabel('Time');
ylabel('Frequency');
title("CLEAN");
grid on;
figure;
plot(time, freq, 'b-');
xlabel('Time');
ylabel('Frequency');
title("RAW");
grid on;