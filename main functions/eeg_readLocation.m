function [ location, name ] = eeg_readLocation( filename )
% Read location from Text file and returns 19 montages X, Y and Z
% With names

fileID = fopen(filename);
numberData = 19;
formatSpec = ('%d %f %f %f %s');
tempData = textscan(fileID,formatSpec,numberData,'treatAsEmpty','OFF'...
    ,'EmptyValue',NaN,'Delimiter',' ','MultipleDelimsAsOne',1);

fclose(fileID);

%Return X position of montage
location(:,1) = tempData{1,2};
%Return Y position of montage
location(:,2) = tempData{1,3};
%Return Z position of montage
location(:,3) = tempData{1,4};
%Return montage names
name = tempData{1,5};

end

