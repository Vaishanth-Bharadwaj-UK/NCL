files = {
    'tcpdmp_MyRig5.txt'
    'tcpdmp_MyRig6.txt'
    'tcpdmp_MyRig7.txt'
    };

Protocols = zeros(3,4);

for i = 1:3

    txt = readlines(files{i});

    Protocols(i,1) = sum(contains(txt,'Flags'));
    Protocols(i,2) = sum(contains(txt,'ICMP'));
    Protocols(i,3) = sum(contains(txt,'ARP'));
    Protocols(i,4) = sum(contains(txt,'.53:'));

end

figure;
bar(Protocols,'stacked');
grid on;

legend({'TCP','ICMP','ARP','DNS'});
xlabel('MyRigx');
ylabel('Packet Count');

xticklabels({'MyRig5','MyRig6','MyRig7'});

title('Protocol Distribution');