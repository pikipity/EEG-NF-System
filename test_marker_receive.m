clear;clc;
lib = lsl_loadlib();

disp('Searching marker stream...')
result = {};
while isempty(result)
    result = lsl_resolve_byprop(lib, 'type', 'Markers');
end

disp('Opening inlet')
inlet = lsl_inlet(result{1});

disp('Receiving markers...')
fig=figure();
tb = uicontrol(fig, 'Style', 'togglebutton', 'String', 'Stop Receiving Markers',...
               'Position',[0.1 0.1 600 300],'fontsize',20);
drawnow;
markers=[];
while true
    drawnow;
    if get(tb,'Value')==1
        break
    end
    [mrks,ts] = inlet.pull_sample();
    fprintf('Got %s at time %.5f\n', mrks{1},ts);
    markers(end+1).time=ts;
    markers(end).str=mrks{1};
end
close(fig)
disp('Stop')
delete(inlet)

[file, path] = uiputfile([datestr(datetime('now'),'yy-mm-dd_HH_MM_SS') '-markers.mat'],'Save Markers');
save(fullfile(path,file),'markers');
clear;

