clear;clc;
lib = lsl_loadlib();

markerID=char(java.util.UUID.randomUUID);
info = lsl_streaminfo(lib,'NFInterfaceMarker','Markers',1,0,'cf_string',markerID);
MarkerOutlet=lsl_outlet(info);

while true
    MarkerOutlet.push_sample({'test'})
    disp('Send test')
    pause(1)
end
