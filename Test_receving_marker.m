clear;
lib=lsl_loadlib();
result = lsl_resolve_byprop(lib,'type','Markers');
MarkerInletStreamInfo=result{1};
MarkerInlet=lsl_inlet(MarkerInletStreamInfo);
MarkerInlet.open_stream(2);
[marker_chunk,marker_time]=MarkerInlet.pull_sample(0 );