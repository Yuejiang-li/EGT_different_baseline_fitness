function [mean_result, generated_graph] = simulate_DB_est_control_script(uff, ufn, unn, N, k, alpha, iteration_time, p_ini, b)
    rand_graph_num = 5;
    sim_run_num = 24;    
    mean_result = zeros(1, iteration_time);
    simulation_2_result = cell(1, rand_graph_num);
    generated_graph = cell(1, rand_graph_num);
    for m = 1:rand_graph_num
        simulation_2_result{1, m} = zeros(1, iteration_time);
    end
    for i = 1:rand_graph_num
        i
%         generate regular graph
% -----------------------------------------------------------
        graph_matrix = full(createRandRegGraph(N, k));
% -----------------------------------------------------------


%       generate scale-free graph
% -----------------------------------------------------------
%         seed = seed_produce(k/2+1);
%         graph_matrix = SFNG(N, k/2, seed);
% -----------------------------------------------------------

%       generate ER graph
% -----------------------------------------------------------
%         graph_matrix = ERRandomGraphGenerate(N, k/N);
% -----------------------------------------------------------
        generated_graph{1, i} = graph_matrix;
        graph = random_graph_order(graph_change(graph_matrix));
        mean_table_2 = cell(1, sim_run_num);
        for m = 1:sim_run_num
            mean_table_2{1, m} = zeros(1, iteration_time);
        end
        parfor j = 1: sim_run_num
%             j
            mean_table_2{1, j} = simulate_DB_est(uff, ufn, unn, graph, alpha, iteration_time, N, p_ini, b);
        end
        for m = 1:sim_run_num
            simulation_2_result{1, i} = simulation_2_result{1, i} + mean_table_2{1, m};
        end
        simulation_2_result{1, i} = simulation_2_result{1, i}/sim_run_num;
    end
    for m = 1:rand_graph_num
        mean_result = mean_result + simulation_2_result{1, m};
    end
    mean_result = mean_result/rand_graph_num;
end