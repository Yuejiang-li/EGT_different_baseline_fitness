% this script is used for compare the theoretic results and the simulation
% result w.r.t 'xxxx_est2' methods and results.

% network basic parameters
N = 2000; k = 80;
% payoff matrix
uff = 0.6; ufn = 0.8; unn = 0.4;
% graph_structure
% ------------------------------------------
% graph = full(createRandRegGraph(N, k));
% ------------------------------------------
% ------------------------------------------
seed = seed_produce(k + 1);
graph = sf_gen(N, k/2, seed);
% ------------------------------------------ 

% other parameters
alpha = 0.1;
b = 20;
p_ini = 0.1;
iterate_time = 400;
theo_result = theo_dnmc_est_2(uff, ufn, unn, graph, alpha, iterate_time, p_ini, 20);
% load the corresponding simulation result
load('./result/pm2_sf_N2000_k80_100_b1_20_est2');
sim_result = result{5, 1};
plot(sim_result, 'b-', 'LineWidth', 2);
hold on
plot(theo_result, 'b--', 'LineWidth', 2);
legend('simulation result', 'theoretic result')
xlabel('time')
ylabel('P_f')
