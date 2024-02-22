clearvars;
addpath(fullfile(cd,'lib'));
FName ='KPI_input_file.xlsx';
S_names = sheetnames(FName);
for i=1:numel(S_names)
    input_data{i}=readtable(FName, 'Sheet', S_names(i)); 
end
fill_value = -99999;
[V_meas,V_calc,N_iter,E_load_meas,E_load_for,E_res_meas,E_res_for,E_grid,E_ess,cost_E,CEC,time_interval] = calculate_parameters(input_data,fill_value);
KPIs = calculate_KPIs(V_meas,V_calc,N_iter,E_load_meas,E_load_for,E_res_meas,E_res_for,E_grid,E_ess,cost_E,CEC,time_interval,fill_value);
FName_out = strcat('output_',FName);
writetable(KPIs,FName_out);

% ntimestamps = 96*30;
% Vm = normrnd(1,0.01,[ntimestamps,13]);
% Vm(Vm>1.05) = 1.05;
% Vm(Vm<0.95) = 0.95;
% Vc = Vm + normrnd(0.001,0.00001,[ntimestamps,13]);
% Niter = randi(7,[ntimestamps,1]);
% ELm = 1.25*rand(ntimestamps,10);
% ELc = ELm + normrnd(0.02,0.001,[ntimestamps,10]);
% 
% RES=readtable('RES.xlsx');
% PV=RES.PV;
% W=RES.WIND;
% j=0;
% for i=1:length(PV)
%     j=j+1;
%     RESPV(j)=PV(i)/4;
%     RESW(j)=W(i)/4;
%     j=j+1;
%     RESPV(j)=PV(i)/4;
%     RESW(j)=W(i)/4;
%     j=j+1;
%     RESPV(j)=PV(i)/4;
%     RESW(j)=W(i)/4;
%     j=j+1;
%     RESPV(j)=PV(i)/4;
%     RESW(j)=W(i)/4;
% end
% RESPV=15*RESPV';
% RESW=20*RESW';
% a = -0.1;
% b = 0.1;
% r = (b-a).*rand(ntimestamps,1) + a;
% r2 = (b-a).*rand(ntimestamps,1) + a;
% RESPVc=RESPV+r.*RESPV;
% RESWc=RESW+r.*RESW;
% Egrid=1.05*(sum(ELm,2)-RESPV-RESW) + normrnd(0.1,0.001,[ntimestamps,1]);
% Egrid=1.05*(sum(ELm,2)) + normrnd(0.1,0.001,[ntimestamps,1]);
% EBm = zeros(ntimestamps,1);
% CostE = ones(ntimestamps,1)*0.28;
% Cec = rand(ntimestamps,1);