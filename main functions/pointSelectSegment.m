%Sampling rate 200Hz
%Segment = 3sec
% load('spike');
patnum = 10;
Pat = Patient(patnum,'spike_repetitive10_3S.txt','BaptistLocation10-20.txt',200,1);

%------------------------------For EEG Plot ---------------------%
%Set Plot range for plotting in EEGLAB
plotRange = (Pat.numberOfSegment*Pat.segmentRange);
if plotRange > 30
    plotRange = 30;
end

%EEG plot for EEG Lab
eegplot(Pat.data,'srate',Pat.srate,'winlength',...
    plotRange,'eloc_file','BaptistLocationEEGLABPlot.locs')

%----------------------------------------------------------------%
t = 260; % Peak starting point
segment(:,:,patnum) = Pat.data(:,t-40:t+159);
%EEG plot for EEG Lab
eegplot(segment(:,:,patnum),'srate',Pat.srate,'winlength',...
    1,'eloc_file','BaptistLocationEEGLABPlot.locs')

