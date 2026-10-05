temperature = [14   16   15   18   21   20   17];
%disp(temperature(4))
%disp(temperature(2:5))
temperature(7) = 19;
%disp(temperature)
evening = [9   11   10   12   14   13   12];
%difference = temperature - evening;
%disp(difference)
temperatures = [temperature;evening];
%disp(temperatures(:,3))
%disp(temperatures(1,:))
%disp(size(temperatures))
disp(temperatures(1,temperatures(1,:)>18))
squared_evening = evening.^2;
disp(squared_evening)