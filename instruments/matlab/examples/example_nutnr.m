% Mooring:
    %CE01ISSM, CE01ISSP, CE02SHSM, CE02SHBP, CE02SHSP, CE04OSSM, CE04OSBP, CE06ISSM, CE06ISSP, CE07SHSM, CE07SHSP, CE09OSSM, CE09OSPM
%Node:
    %BUOY, NSIF, MFN, BEP, PROFILER
%Instrument Class:
    %ADCP, CTD, DOSTA, FDCHP, FLORT, METBK, MOPAK, NUTNR, OPTAA, PARAD, PCO2A, PCO2W, PHSEN, PRESF, SPKIR, VEL3D, VELPT, WAVSS, ZPLSC
%Method:
    %Telemetered, RecoveredHost, RecoveredInst, RecoveredCSPP, RecoveredWFP, Streamed
 
%%
close all
clearvars

%.. set login and URL details
api_key = 'OOIAPI-853A3LA6QI3L62';
api_token = 'WYAN89W5X4Z0QZ';
options = weboptions('CertificateFilename', '', 'HeaderFields', {'Authorization', ...
    ['Basic ' matlab.net.base64encode([api_key ':' api_token])]}, 'Timeout', 120);

%.. set time period of interest
start_date='2015-04-01T00:00:00.000Z';
end_date='2019-09-30T23:59:59.000Z';
% start_date = '2016-05-16T00:00:00.000Z';
% end_date   = '2019-06-22T23:59:59.000Z';

%%
%Specify metadata
mooring_name = 'CE02SHSM';
node = 'NSIF';
instrument_class = 'NUTNR';
method = 'Telemetered';
%method = 'RecoveredHost';
%method = 'RecoveredInst';

%Get M2M URL
[uframe_dataset_name,variables]=M2M_URLs(mooring_name,node,instrument_class,method);

%Make M2M Call
[nclist] = M2M_Call(uframe_dataset_name,start_date,end_date,options);

%Get Data
%[variables, mtime, netcdfFilenames] = M2M_Data(variables, nclist, false);   %This will download .nc file(s) and read in the data from the local files
[variables, mtime, netcdfFilenames] = M2M_Data(variables, nclist);  %This will use the opendap to read in the data from remote files

%%
%Example plot
if strcmpi(method, 'Telemetered')
    figure(101)
elseif strcmpi(method, 'RecoveredHost')
    figure(102)
elseif strcmpi(method, 'RecoveredInst')
    figure(103)
end

subplot(211)
plot(mtime,variables(2).data, 'x-')
datetick('x',1)
title(['L1: ' strrep(variables(2).name,'_',' ')])
subplot(212)
plot(mtime,variables(3).data, 'x-')
datetick('x',1)
title(['L2: ' strrep(variables(3).name,'_',' ')])
linkaxes([subplot(211) subplot(212)], 'x')