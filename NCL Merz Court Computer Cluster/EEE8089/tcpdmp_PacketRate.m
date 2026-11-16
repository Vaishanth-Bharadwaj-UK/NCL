files = {
    'tcpdmp_MyRig5.txt'
    'tcpdmp_MyRig6.txt'
    'tcpdmp_MyRig7.txt'
    };

figure;
hold on;

for n = 1:length(files)

    txt = readlines(files{n});

    times = [];

    for k = 1:length(txt)

        token = regexp(txt{k},'^(\d+):(\d+):([\d\.]+)','tokens');

        if ~isempty(token)

            h = str2double(token{1}{1});
            m = str2double(token{1}{2});
            s = str2double(token{1}{3});

            times(end+1) = h*3600 + m*60 + s;

        end

    end

    times = times - times(1);

    edges = 0:0.1:ceil(max(times));

    counts = histcounts(times,edges);

    plot(edges(1:end-1),counts,...
        'LineWidth',2)

end

xlabel('Time (s)');
ylabel('Packets per 0.1 s');

title('Rate of Packet Activity');

legend('MyRig5','MyRig6','MyRig7');

grid on;