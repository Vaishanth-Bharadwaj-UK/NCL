data = readmatrix('encoder_samples.dat.txt');

time  = data(:,1);
freq  = data(:,2);
valid = data(:,3);
valid_shift = [valid(2:end);0];
valid = valid .* valid_shift;

time = time - time(1);
idx = (valid == 1);

figure;
subplot(2,1,1);
plot(time(idx), freq(idx), 'b-');
xlabel('Time');
ylabel('Frequency');
title("Open Loop");
grid on;

data = readmatrix('closed_loop_encoder_samples.dat.txt');

time  = data(:,1);
freq  = data(:,2);
valid = data(:,3);
valid_shift = [valid(2:end);0];
valid = valid .* valid_shift;

time = time - time(1);
idx = (valid == 1);

subplot(2,1,2);
plot(time(idx), freq(idx), 'b-');
xlabel('Time');
ylabel('Frequency');
title("Closed Loop");
grid on;