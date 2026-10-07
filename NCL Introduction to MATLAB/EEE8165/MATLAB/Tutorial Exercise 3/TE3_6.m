time = [0 1 2 3 4 5 6];
%disp(time)
temperature1 = [82 71 63 56 51 47 44];
temperature2 = [78 69 61 55 50 46 43];
%disp(temperature)
plot(time,temperature1,time,temperature2,"Marker","o")
xlabel("Time (min)")
ylabel("Temperature (degrees C)")
title("Cooling of a drink")
grid on
legend("Drink1","Drink2");