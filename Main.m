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