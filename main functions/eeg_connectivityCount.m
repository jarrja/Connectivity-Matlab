function Connection =  eeg_connectivityCount(eegConnectivityCounting, conMatrix ,threshold)
%[Structure is returned] = eeg_connectivityCount(object of eeg connectivity counting,
% matrix to be counted ,threshold)
% This function finds number of connection within the assigned threshold
%

[numThres,thresSize] = size(threshold);
[~,~,maskSize] = size(eegConnectivityCounting.mask);

Connection.threshold = threshold;
Connection.location = eegConnectivityCounting.name;

if thresSize > 1
    Connection.type = 'Inhibition and Excitation';
    inhibitMatrix = conMatrix;
    exciteMatrix = conMatrix;
    
    
    for i=1:1:numThres
        exciteMatrix(exciteMatrix < threshold(i,2)) = 0;
        inhibitMatrix(inhibitMatrix > threshold(i,1)) = 0;
        for j=1:1:maskSize
                tempInhibit = inhibitMatrix.*eegConnectivityCounting.mask(:,:,j);
                tempExcite = exciteMatrix.*eegConnectivityCounting.mask(:,:,j);
                [~,~,v1] = find(tempInhibit>0);
                [~,~,v2] = find(tempExcite>0);
                Connection.numConnectionInhibit(i,j) = sum(v1);
                Connection.numConnectionExcite(i,j) = sum(v2);
        end
    end
    
else
    Connection.type = 'Excitation';
    for i=1:1:numThres
        thresMatrix = conMatrix;
        thresMatrix(conMatrix < threshold(i)) = 0;  

        for j=1:1:maskSize
            temp = thresMatrix.*eegConnectivityCounting.mask(:,:,j);
            [~,~,v] = find(temp>0);
            Connection.numConnection(i,j) = sum(v);
        end
    end

end
end