clear;close all;
%Sampling rate 200Hz
%Segment = 3sec
% load('spike');
Pat = Patient(1,'spike_complex1.txt','BaptistLocation10-20.txt',200,1);

Range = Pat.totalRange;
numSeg = Pat.numberOfSegment;
%Filter data from 0.5 - 70 Hz
temp = eeg_filter(Pat, 0.5, 35);
Pat.data = temp.data;
%Average Montage Reference
Pat.data = eeg_reRef(Pat.data);
%Remove DC Offset
Pat.data = eeg_rmvBase(Pat.data);
%--------------Step from Filter------%
Pat.eegDataFreqBand;
Pat.eegSegmentation;
Pat.eegConnectivity;
%------------------------------------%

%------------Create Folder for plots-----------%
mkdir('alpha');
mkdir('beta');
mkdir('delta');
mkdir('theta');
%----------------------------------------------%

%--------------------Con Analysis-----------------------%
for k=1:1:4
%Select the Starting and Stoping segment
startSeg = 1;
stopSeg = 1;
Threshold =[0.5 0.7 0.8 0.9];

%Plot EEG Connectivity of all segments and frequency
for j=startSeg:1:stopSeg
    for i=1:1:4
        Pat.eegConnectivityPlot(j,i,Threshold(k),1);
    end
end
end
%Calculate EEG Connectivity AVG for Doctors

%Pat.eegConnectivityAVG([1,2,3,4,5,7,8,9],Threshold);
Pat.eegConnectivityAVG((startSeg:stopSeg),Threshold(k));
switch Threshold(k)
    case 0.5
        addName = ' fig1';
    case 0.7
        addName = ' fig2';
    case 0.8
        addName = ' fig3';
    case 0.9
        addName = ' fig4';
end      
for i=1:1:4
    Pat.eegConnectivityPlot(Pat.numberOfSegment+1,i,0.1,1,addName);
end

%Calculate EEG Connectivity AVG conventional
%Pat.eegConnectivityTotalAVG([1,2,3,4,5,7,8,9]);
Pat.eegConnectivityTotalAVG((startSeg:stopSeg));
for i=1:1:4
    Pat.eegConnectivityPlot(Pat.numberOfSegment+2,i,Threshold(k),1);
end
end
%----------------------------------------------------------------%


%------------------------------For EEG Plot ---------------------%
%Set Plot range for plotting in EEGLAB
plotRange = (Pat.numberOfSegment*Pat.segmentRange);
if plotRange > 30
    plotRange = 30;
end

%EEG plot for EEG Lab
eegplot(a,'srate',Pat.srate,'winlength',...
    plotRange,'eloc_file','BaptistLocationEEGLABPlot.locs')

%----------------------------------------------------------------%


%-------------------Optional Plot -------------------------%

eegplot(Pat.data,'srate',Pat.srate,'winlength',...
    21,'eloc_file','BaptistLocationEEGLABPlot.locs')

eegplot(Pat.dataFreqBand(:,:,4),'srate',Pat.srate,'winlength',...
    plotRange,'eloc_file','BaptistLocationEEGLABPlot.locs')

eegplot(Pat.data,'srate',Pat.samplingFrequency,'winlength',...
    plotRange);


