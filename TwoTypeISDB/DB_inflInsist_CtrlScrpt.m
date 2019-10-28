function mean_result = DB_inflInsist_CtrlScrpt(uff, ufn, unn, N, k, alpha, iteration_time, percentage, p_ini_1, p_ini_2, B, b, g_type, varargin)
%   This control script code is modified for higher performance
%   2019.08.15
%   liyuejiang
%     tic
    rand_graph_num = 5;
    sim_run_num = 48;
    mean_result = zeros(3, iteration_time);
    result_1_all = zeros(sim_run_num, iteration_time, rand_graph_num, 'single');
    result_2_all = zeros(sim_run_num, iteration_time, rand_graph_num, 'single');
    result_all = zeros(sim_run_num, iteration_time, rand_graph_num, 'single');  % 3-d matrices to record every simulation results
    graph_all = zeros(N, N, rand_graph_num, 'single');
    
    switch g_type  % choose graph type
        case 'regular'  % random regular network
            parfor i = 1:rand_graph_num
                graph_sample = full(createRandRegGraph(N, k));
                graph_all(:, :, i) = random_graph_order(graph_change(graph_sample));
            end
        case 'scale-free'  % scale-free network
            seed = seed_produce(k+1);
            parfor i = 1:rand_graph_num
                graph_sample = sf_gen(N, k/2, seed);
                graph_all(:, :, i) = random_graph_order(graph_change(graph_sample));
            end
        otherwise  % a customized network input is an adjacency matrix
            net = varargin{1, 1};
            for i = 1:rand_graph_num
                graph_all(:, :, i) = random_graph_order(graph_change(net));
            end
    end
    
    for i = 1:rand_graph_num
%         i
        graph = graph_all(:, :, i);
        parfor j = 1: sim_run_num
            [result_1_all(j,:,i), result_2_all(j,:,i), result_all(j,:,i)] = DB_inflInsist(uff, ufn, unn, graph, alpha, iteration_time, N, percentage, p_ini_1, p_ini_2, B, b);
%             [result_1_all(j,:,i), result_2_all(j,:,i), result_all(j,:,i)] = simulate_DB_with_influential_user_mod(uff, ufn, unn, graph, alpha, iteration_time, N, percentage, p_ini_1, p_ini_2, B, b);
        end
    end
    mean_graph_result_1 = mean(result_1_all, 3);
    mean_graph_result_2 = mean(result_2_all, 3);
    mean__graph_result = mean(result_all, 3);  % Expectation calculation w.r.t graph
    mean_result(1, :) = mean(mean_graph_result_1);
    mean_result(2, :) = mean(mean_graph_result_2);
    mean_result(3, :) = mean(mean__graph_result);  % Expectation calcaulation w.r.t simulation run
%     toc
end