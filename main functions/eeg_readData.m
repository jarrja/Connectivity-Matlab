function [ dataOutputMatrix ] = eeg_readData( file )
% [ output of the data ] = eeg_readData( filename or MAT )
% This function reads the data from txt File or MAT
% into 19 electrodes
% matrix where row = electrodes, column = data in time domain

%Determining the class type of the input
classType = class(file);

switch classType
    %File type is from text file
    case 'char'
        disp('The file type is Text file, Reading data from file');
        fileID = fopen(file);
        numberData = 500000;
        formatSpec = ['%d/%d/%d %d:%d:%d ',repmat('%f',1,24),'%s'];
        tempData = textscan(fileID,formatSpec,numberData,'treatAsEmpty','OFF'...
            ,'EmptyValue',NaN,'Delimiter',' ','MultipleDelimsAsOne',1);

        fclose(fileID);

        %If Data is from Baptist Hospital
        %columnRemove = [4,10,17];
        %disp('Data from Baptist Hospital, removing :4, 10, 17 column')
        %If Data is from Miami Children's Hospital
        
        columnRemove = [5,6,15];
        disp('Data from Miami Childrens Hospital, removing :5, 6, 15 column')

        count = 1;
        for i=8:1:29
            % Removing column assigned in array [1][2][3]
            if (i==(7+columnRemove(1))) || (i==(7+columnRemove(2))) || (i==(7+columnRemove(3)))
            else
               dataOutputMatrix(count,:) = transpose(tempData{i});
               count = count+1;
            end
        end
    case 'double'
        %File type is from mat file
        disp('The file type is MAT file, Assign Value directly to data');
        dataOutputMatrix = file;
    otherwise
        error('Data type is not correct');
end

end
