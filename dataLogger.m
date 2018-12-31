%       __  ___      __  ____         ________   ___     
%      / / / / | /| / / / __/______  / ___/ _ | / _ \    
%     / /_/ /| |/ |/ / / _// __/ _ \/ /__/ __ |/ , _/    
%     \____/ |__/|__/ /___/\__/\___/\___/_/ |_/_/|_|  
%     System Modeling and Simulations 
%
% Data Logging
% Written by: Carlos Sama, 12-30-18
% Version: 1.0
% Release: r1.3

% Notes: This script is to be used to log data going into referenced models
% To log signals select the input layer block that feeds into the reference

%% Gathering info
model = bdroot;
blockPath = gcb;
blockName = get_param(blockPath, 'Name');
signalNames = get_param(blockPath,'OutputSignalNames');
ph = get_param(blockPath,'PortHandles');
signals = struct();

%% Run the model to collect data
for i = 1:length(ph.Outport)
    set_param(ph.Outport(i),'DataLogging','on');
end
sim(model);

%% Organize the data
t = logsout{1}.Values.Time;
u = [];
j = 0;
for i = 1:logsout.numElements
    bpobj = logsout{i}.BlockPath;
    bpath = bpobj.getBlock(1);
    if strcmpi(blockPath, bpath)
        j = j+1;       
        %signals.(signalNames{j}) = logsout{i}.Values.Data;
        u = [u double(logsout{i}.Values.Data)]; % gotta cast bc it data types as 'logicals' when all zero
    end
end
for i = 1:length(ph.Outport)
    set_param(ph.Outport(i),'DataLogging','off');
end

%% Saving the signal structure
% this is useful if you don't want to rerun the model later on

% dirStart = strfind(mfilename('fullpath'), 'GM_Blazer_prj') - 1;
% saveDir = mfilename('fullpath');
% saveDir = strcat(saveDir(1:dirStart),'GM_Blazer_prj\simulation_data\signalLogs\');
% config = get_param('EcoCAR_GM_Blazer/Powertrain Type', 'PowertrainMode');
% savename = strcat(saveDir,blockName, '_', config);
% save(savename, 'signals', '-mat');





