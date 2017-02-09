function [conAVG] = eeg_avgCoherence(range,coh)

[M,N] = size(range);

for i=1:1:M
conAVG(i) =   sum(coh(range(i,1)+1:range(i,2)+1))/...
    (abs(range(i,1)-range(i,2))+1); 
end

end

