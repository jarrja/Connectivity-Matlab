function eeg_connectivityPlot(object,plotMatrix,threshold,save,plotName)
    %Revised version of eegConnectivityPlot function which take too strict
    %argument. Requires object (will be updated for easy implementation)
    %plot matrix treshold and save option
    
    [~,n] = size(threshold);
    
    fh = figure();
    %Edit for printing into folder
    %Create name of the folder
    if nargin < 5
        plotName = ['Pat',num2str(object.patientNumber),' Thres',num2str(threshold * 100)];
    end
    if n>1
        % Fixe this inhibition and excitation
        tempPlotMatrix = plotMatrix;
        tempPlotMatrix(tempPlotMatrix > threshold(1)) = 0;
        plotMatrix(plotMatrix < threshold(2)) = 0;
        plotMatrix = plotMatrix+tempPlotMatrix;
    else
        plotMatrix(plotMatrix < threshold) = 0;
    end
    eeg_wgPlot(plotMatrix,object.chanlocs,'vertexWeight',2,'edgeColorMap',jet,'edgeWidth',2);
    axis square;
    hold on;
    scatter(object.chanlocs(:,1),object.chanlocs(:,2),'MarkerEdgeColor',[0 .5 .5],...
      'MarkerFaceColor',[0 .7 .7],...
      'LineWidth',1.5)
    for i=1:1:19
        text(object.chanlocs(i,1),object.chanlocs(i,2),object.electrodeName(i));
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
    
    %To save the figure in the designated folder
    if nargin >3 && save == 1
        % Test for rotating the image when saving
%         set( fh,'PaperPosition', [0.01 0.01 7.0 7.0] );
        set( fh,'PaperSize',fliplr(get(hf,'PaperSize')),'PaperPosition', [0.01 0.01 7.0 7.0] ) ;
        print(plotName,'-dpng','-r0');
    end
    
    
end