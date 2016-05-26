function [ connectivityMatrix ] = eeg_connectivity( data )
%Find the connectivity of data X = electrodes Y = data
%By using XCORR function, cross-correlation of the data

[sizeRow, ~] = size(data);
I = abs(eye(sizeRow)-1);

[cr,~] = xcorr(transpose(data),'coeff');
connectivityMatrix = (reshape(max(abs(cr)),sizeRow,sizeRow).*I);

end

