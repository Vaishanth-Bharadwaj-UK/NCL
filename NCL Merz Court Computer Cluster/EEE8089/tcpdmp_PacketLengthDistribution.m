files = { ...
    'tcpdmp_MyRig5.txt', ...
    'tcpdmp_MyRig6.txt', ...
    'tcpdmp_MyRig7.txt'};

allLengths = [];
group = [];

for n = 1:numel(files)

    txt = readlines(files{n});

    pktLen = [];

    for k = 1:length(txt)

        t = regexp(txt{k},'length\s+(\d+)','tokens');

        if ~isempty(t)

            pktLen(end+1) = str2double(t{1}{1});

        end

    end

    allLengths = [allLengths pktLen];
    group = [group n*ones(1,length(pktLen))];

end

figure

boxplot(allLengths,group,'Labels',{'MyRig5','MyRig6','MyRig7'});

ylabel('Packet Length (Bytes)');
title('Packet Length Distribution');
grid on;