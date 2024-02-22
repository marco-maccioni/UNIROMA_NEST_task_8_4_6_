function [KPIs] = calculate_KPIs(V_meas,V_calc,N_iter,E_load_meas,E_load_for,E_res_meas,E_res_for,E_grid,E_ess,cost_E,CEC,time_interval,fill_value)
KPI_Name = {'State estimation performance evaluation - MAE';'State estimation performance evaluation - RMSE'; ...
    'State estimation performance evaluation - ME';'Load forecasting accuracy';'RES generation forecasting accuracy'; ...
    'State estimation convergence';'Data validation ratio';'Technical losses';'RES data collection reliability'; ...
    'RES average communication failure duration';'RES average communication failure frequency';'Peak load'; ...
    'Peak to average ratio';'Net-metering';'Self-consumption ratio';'Self-sufficiency';'Energy cost';'Greenhouse Gas emissions'};
[N_time,N_Nodi] = size(V_meas);
V1 = V_meas;
V2 = V_calc;
a = (V1==fill_value);
b = (V2==fill_value);
V1(a) = 0;
V2(b) = 0;
V1(b) = 0;
V2(a) = 0;
KPI_Value(1) = sum(sum(abs(V1 - V2)))/N_Nodi/N_time;
KPI_Value(2) = sqrt(sum(sum((V1 - V2).*(V1 - V2)))/N_Nodi/N_time);
KPI_Value(3) = max(max(abs(V1 - V2)));
E_L_M = E_load_meas;
E_L_M(E_L_M==fill_value) = 0;
E_L_F = E_load_for;
E_L_F(E_L_F==fill_value) = 0;
total_load_meas = sum(E_L_M,2);
total_load_for = sum(E_L_F,2);
KPI_Value(4) = 100*sum(fillmissing(abs(total_load_meas-total_load_for)./total_load_meas,'constant',0))/length(total_load_meas);
E_R_M = E_res_meas;
E_R_M(E_R_M==fill_value) = 0;
E_R_F = E_res_for;
E_R_F(E_R_F==fill_value) = 0;
total_res_meas = sum(E_R_M,2);
total_res_for = sum(E_R_F,2);
KPI_Value(5) = 100*sum(fillmissing(abs(total_res_meas-total_res_for)./total_res_meas,'constant',0))/length(total_res_meas);
c = sum(N_iter~=fill_value);
iter = N_iter;
iter(iter==fill_value) = 0;
KPI_Value(6) = sum(iter)/c;
validated_data = sum(sum(V_meas>fill_value)) + sum(sum(V_calc>fill_value)) + sum(sum(N_iter>fill_value)) + ...
    sum(sum(E_load_meas>fill_value)) + sum(sum(E_load_for>fill_value)) + sum(sum(E_res_meas>fill_value)) + ...
    sum(sum(E_res_for>fill_value)) + sum(sum(E_grid>fill_value)) + sum(sum(E_ess>fill_value)) + ...
    sum(sum(cost_E>fill_value)) + sum(sum(CEC>fill_value));
received_data = sum(sum(V_meas>=fill_value)) + sum(sum(V_calc>=fill_value)) + sum(sum(N_iter>=fill_value)) + ...
    sum(sum(E_load_meas>=fill_value)) + sum(sum(E_load_for>=fill_value)) + sum(sum(E_res_meas>=fill_value)) + ...
    sum(sum(E_res_for>=fill_value)) + sum(sum(E_grid>=fill_value)) + sum(sum(E_ess>=fill_value)) + ...
    sum(sum(cost_E>=fill_value)) + sum(sum(CEC>=fill_value));
KPI_Value(7) = 100*validated_data/received_data;
Egrid = E_grid;
d = (Egrid==fill_value);
Eloadmeas = E_load_meas;
e = (Eloadmeas==fill_value);
Egrid(d) = 0;
Eloadmeas(e) = 0;
Eloadmeas(d,:) = 0;
KPI_Value(8) = sum(Egrid)-sum(sum(Eloadmeas));
[~,N_res] = size(E_res_meas);
KPI_Value(9) = 100*sum(sum(E_res_meas>fill_value))/sum(sum(E_res_meas>=fill_value));
KPI_Value(10) = time_interval*sum(sum(E_res_meas==fill_value))/N_res;
KPI_Value(11) = sum(sum(E_res_meas==fill_value))/N_res;
KPI_Value(12) = max(sum(Eloadmeas,2))/(time_interval/60);
KPI_Value(13) = KPI_Value(12)/(sum(sum(Eloadmeas))/(time_interval/60)/numel(Eloadmeas));
Eloadmeas = E_load_meas;
Eloadmeas(Eloadmeas==fill_value) = 0;
Eess = E_ess;
Eess(Eess==fill_value) = 0;
Eess(Eess>0) = 0;
KPI_Value(14) = sum(sum(Eloadmeas)) - sum(sum(abs(Eess))) - sum(sum(E_R_M));
SCR = [sum(Eloadmeas,2) sum(abs(Eess),2)+sum(E_R_M,2)]; 
SCRmin = min(SCR,[],2);
KPI_Value(15) = 100*sum(SCRmin)/(sum(sum(abs(Eess))) + sum(sum(E_R_M)));
KPI_Value(16) = 100*sum(SCRmin)/(sum(sum(Eloadmeas)));
costE = cost_E;
costE(costE==fill_value) = 0;
KPI_Value(17) = sum(costE.*sum(Eloadmeas,2));
CEC_GHG = CEC;
CEC_GHG(CEC_GHG==fill_value) = 0;
KPI_Value(18) = sum(CEC_GHG.*sum(Eloadmeas,2));
KPI_Value = KPI_Value';
KPIs = table(KPI_Name,KPI_Value);
