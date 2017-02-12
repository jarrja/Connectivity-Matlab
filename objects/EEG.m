classdef EEG < handle
    properties 
        patientNumber
        nbchan
        electrodeName
        chanlocs
        data
        segmentRange
        segmentData
        srate
        dataFreqBandSegment
        dataSegment
        dataFreqBandConnectivity
        dataFreqBand
        frequencyBand
        trials
        event
        dataConnection
    end
    properties (Dependent)        
        pnts
        totalRange
        numberOfSegment
    end
    
    methods
        % Initializing the patient with Patient Number,
        function obj = EEG(numPat,fileName,locationName,Fs,rangeSeg)
            %Assign Patient Number
            obj.patientNumber = numPat;
            %Obtain Data of EEG by read function and filename
            obj.data = eeg_readData(fileName);
            %Assign Sampling Frequency
            obj.srate = Fs;
            %Assign Frequency Band
            obj.frequencyBand = {'Delta','Theta','Alpha','Beta'};
            %Assign location of the electrodes
            [obj.chanlocs, obj.electrodeName]=eeg_readLocation(locationName);
            [obj.nbchan, ~] = size(obj.chanlocs); 
            %Assgin range of segment in second
            obj.segmentRange = rangeSeg;
            obj.segmentData = obj.segmentRange*Fs;
            
            %Create to match EEGLAB template
            obj.trials = 1;
            obj.event = [];
        end
        %Automatically calculates number of points
        function Pnts = get.pnts(obj)
            %Calculate the total range and number of segment
            [~, Pnts] = size(obj.data);
        end
        %Automatically calculates Total Range
        function TotalRange = get.totalRange(obj)
            TotalRange = (1/obj.srate)*obj.pnts;
        end
        %Automatically calculates number of segments
        function NumberOfSegment = get.numberOfSegment(obj)
            rangeLeft = mod(obj.totalRange,obj.segmentRange);
            NumberOfSegment = (obj.totalRange-rangeLeft)/obj.segmentRange;
        end
        
        function eegDataFreqBand(obj,range)
                %Filter data into frequency bands 
                %No input = default bands
                %take input range ie. [1,4;5,8] 2 bands 
                
                obj.dataFreqBand = [];
                if nargin == 1
                    % Default the selection of frequency band 
                    temp1 = obj;
                    temp2 = obj;
                    temp3 = obj;
                    temp4 = obj;

                    %Filter by using EEGLAB Function
                    temp1 = eeg_filter(temp1,0.1,4);
                    obj.dataFreqBand{1} = temp1.data;
                    temp2 = eeg_filter(temp2,5,8);
                    obj.dataFreqBand{2} = temp2.data;
                    temp3 = eeg_filter(temp3,9,13);
                    obj.dataFreqBand{3} = temp3.data;
                    temp4 = eeg_filter(temp4,14,25);
                    obj.dataFreqBand{4} = temp4.data;
                    disp('Number of Freq band : 4 with default selection');
                else
                    %filter to the given frequency band
                    [M,~] = size(range); 
                    for i=1:1:M
                        temp = obj;
                        temp = eeg_filter(temp,range(i,1),range(i,2));
                        obj.dataFreqBand{i} = temp.data;
                        clear temp;
                    end
                    disp(['Number of Freq band : ' num2str(M)]);
                end

        end
        function eegSegmentation(obj)
            [~,numberOfFreqBand] = size(obj.dataFreqBand);
            for i=1:1:obj.numberOfSegment
                startNumber = ((i-1)*obj.segmentData+1);
                stopNumber = startNumber + obj.segmentData - 1;
                for j=1:1:numberOfFreqBand
                    obj.dataFreqBandSegment{i}(:,:,j) = obj.dataFreqBand{j}(:,startNumber:stopNumber);
                end
%**********Frequency band segmentation needs work******
      
%                  obj.dataFreqBandSegment{i}(:,:,1) = obj.dataFreqBand(:,startNumber:stopNumber,1);
%                  obj.dataFreqBandSegment{i}(:,:,2) = obj.dataFreqBand(:,startNumber:stopNumber,2);
%                  obj.dataFreqBandSegment{i}(:,:,3) = obj.dataFreqBand(:,startNumber:stopNumber,3);
%                  obj.dataFreqBandSegment{i}(:,:,4) = obj.dataFreqBand(:,startNumber:stopNumber,4); 

                 obj.dataSegment{i} = obj.data(:,startNumber:stopNumber);
            end            
        end
        
        function eegConnectivityAVG(obj,range,threshold)
            % The numberOfSegment+1 will be the AVG of the given range
            [~,rangeSize] = size(range);
            % Loop for 4 freq bands
            for freqBand=1:1:4
                tempData = zeros(obj.nbchan);
                for i=1:1:rangeSize
                    plotMatrix = obj.dataFreqBandConnectivity{range(i)}(:,:,freqBand);
                    plotMatrix(obj.dataFreqBandConnectivity{range(i)}(:,:,freqBand) < threshold) = 0;
                    tempData = tempData + plotMatrix;
                end 
                tempData = tempData./rangeSize;
                obj.dataFreqBandConnectivity{obj.numberOfSegment+1}(:,:,freqBand) = tempData;
            end
        end
        function eegConnectivityTotalAVG(obj,range)
            % The numberOfSegment+1 will be the AVG of the given range
            [~,rangeSize] = size(range);
            % Loop for 4 freq bands
            for j=1:1:4
                tempData = zeros(obj.nbchan);
                for i=1:1:rangeSize
                   tempData = tempData + obj.dataFreqBandConnectivity{range(i)}(:,:,j);
                end 
                tempData = tempData./rangeSize;
                obj.dataFreqBandConnectivity{obj.numberOfSegment+2}(:,:,j) = tempData;
            end
        end
        function eegConnectivityPlot(obj,segment,freqBand,threshold,save,addName)
            if nargin < 6
                addName = 'fig 1';
            end
            fh = figure();
            %Edit for printing into folder
            %Create name of the folder
            folder = {'delta\','theta\','alpha\','beta\'};
            plotName = [folder{freqBand},'Pat',num2str(obj.patientNumber)...
                ,' Seg',num2str(segment),' Freq',obj.frequencyBand{freqBand}...
                ,' Thres',num2str(threshold * 100)];
            if segment==obj.numberOfSegment+1
            plotName = [folder{freqBand},'Pat',num2str(obj.patientNumber)...
                ,' AVG',' Freq',obj.frequencyBand{freqBand}...
                ,' Thres',num2str(threshold * 100),addName];
            elseif segment == obj.numberOfSegment+2
             plotName = [folder{freqBand},'Pat',num2str(obj.patientNumber)...
                ,' AVG Total',' Freq',obj.frequencyBand{freqBand}...
                ,' Thres',num2str(threshold * 100)];                   
            end
            %title([plotName,'   '],'FontSize',15);
            plotMatrix = obj.dataFreqBandConnectivity{segment}(:,:,freqBand);
            plotMatrix(obj.dataFreqBandConnectivity{segment}(:,:,freqBand) < threshold) = 0;
            eeg_wgPlot(plotMatrix...
                ,obj.chanlocs,'vertexWeight',2,'edgeColorMap',jet,'edgeWidth',2);
            axis square;
            hold on;
            scatter(obj.chanlocs(:,1),obj.chanlocs(:,2),'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5)
            for i=1:1:19
                text(obj.chanlocs(i,1),obj.chanlocs(i,2),obj.electrodeName(i));
            end 
            
            %This part plot the head along with the nose to indicate
            %the front of the figure
            r = 1.2;
            x = 0;
            y = 0;
            th = 0:pi/50:2*pi;
            xunit = r * cos(th) + x;
            yunit = r * sin(th) + y;
            plot(xunit, yunit,'black');
            line([0 -0.1504],[1.3 1.191],'Color',[0 0 0]);
            line([0 0.1504],[1.3 1.191],'Color',[0 0 0]);
            hold off
            if save == 1
                set( fh,'PaperPosition', [0.01 0.01 7.0 7.0] ) ;
                print(plotName,'-dpng','-r0');
            end
        end
    end
    
end







