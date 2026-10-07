temperature = [18 21 24 27 29 23];
%disp(temperature)
%disp(temperature(temperature>25))
currentTemperature = 27;
%disp(currentTemperature)
for n = 1:length(temperature)
    if temperature(n)>25
        %disp("Measurement " + string(n) + ": HIGH")
        fprintf("Measurement %d: HIGH\n",n)
    else
        %disp("Measurement " + string(n) + ": NORMAL")
        fprintf("Measurement %d: NORMAL\n",n)
    end
end