function Connection =  eeg_connectivityCount(eegConnectivityCounting, conMatrix ,threshold)
%[Structure is returned] = eeg_connectivityCount(object of eeg connectivity counting,
% matrix to be counted ,threshold)
% This function finds number of connection within the assigned threshold
%

[~,thresSize] = size(threshold);
[~,~,maskSize] = size(eegConnectivityCounting.mask);
Connection.threshold = threshold;
Connection.location = eegConnectivityCounting.name;

for i=1:1:thresSize
    thresMatrix = conMatrix;
    thresMatrix(conMatrix < threshold(i)) = 0;  
    
    for j=1:1:maskSize
        temp = thresMatrix.*eegConnectivityCounting.mask(:,:,j);
        [~,~,v] = find(temp>0);
        Connection.numConnection(i,j) = sum(v);
    end
end

end