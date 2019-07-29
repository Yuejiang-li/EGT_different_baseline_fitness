function result = simulate_DB_est(uff, ufn, unn, graph, alpha, iterate_time, N, p_ini, b)
%   Date: 2019.07.22
%   This code is modifed based on "simulated_DB.m"
%   Update rule is changed into each user will estimate his/her neighbors'
%   neighborhood situation with his/her own current situation. i.e. the
%   proprotion of Sf adopted neighbors.

% ------------------fitness calculation in a estimated mannar------
%     function fit_result = fitness_calculate(index)
%         %calculate fitness
%         fit = 0;
%         %forward
%         if action_table(index)==1
%             l = 1;
%             while con_matrix(index, l)~= 0
%                 if action_table(con_matrix(index, l)) == 1
%                     fit = fit + uff;
%                 else
%                     fit = fit + ufn;
%                 end
%                 l = l + 1;
%             end
%         %not forward    
%         else
%             l = 1;
%             while con_matrix(index, l)~= 0
%                 if action_table(con_matrix(index, l)) == 1
%                     fit = fit + ufn;
%                 else
%                     fit = fit + unn;
%                 end
%                 l = l + 1;
%             end
%         end
%         %need to change b
%         fit_result = (1 - alpha)*b + alpha*fit;
%     end

    function fit_result = fitness_calculate_est(index, sf_ratio)
        %calculate fitness
        neigh = degree_table(index);
        if action_table(index)==1
            fit = neigh * sf_ratio * uff + neigh * (1 - sf_ratio) * ufn; 
        else
            fit = neigh * sf_ratio * ufn + neigh * (1 - sf_ratio) * unn;
        end
        %need to change b
        fit_result = (1 - alpha)*b + alpha*fit;        
    end
% --------------------------------------------------------------

% --------------------find friend and their strategy------------
%     function list = find_friend(ind)
%         l = 1;
%         list = [];
%         while con_matrix(ind, l)~=0
%             list = [list, con_matrix(ind, l)];
%             l = l +1;
%         end
%     end
    
%     function [list, sf_num] = find_friend_strategy(ind)
%         l = 1;
%         sf_num = 0;
%         list = [];
%         while con_matrix(ind, l)~=0
%             list = [list, con_matrix(ind, l)];
%             if action_table(con_matrix(ind, l)) == 1
%                 sf_num = sf_num + 1;
%             end
%             l = l + 1;
%         end
%     end
% --------------------------------------------------------------

    con_matrix = graph;
    action_table = zeros(1, N);
    result = zeros(1, iterate_time);
%   degree table is used to record users' degree.
    degree_table = zeros(1, N);
%   The network's order is decided with 'random_graph_order.m'
    
%   we have to assign the initial sf adopters 
    for i = 1: N
        j = 1;
        while con_matrix(i, j) ~= 0
            j = j + 1;
        end
        degree_table(i) = j - 1;
    end
    
    ini_user =  randperm(N, p_ini*N);
    action_table(ini_user) = 1;
    count = 1;
    result(count) = sum(action_table)/N;
    count = count + 1;
%     begin the DB update rule
    while count <= iterate_time
        for p = 1:N
            %pick a central user
            i = randi(N);
            %find friend
            friend_number = degree_table(i);
            friend_list = con_matrix(i, 1:friend_number);
            str_sub_table = action_table(friend_list);
            sf_neigh = sum(str_sub_table);
            sf_ratio = sf_neigh/friend_number;
            %calculate self-fitness
%             fit_self = fitness_calculate(i);
            fit_f = 0;
            fit_n = 0;
            for j = 1:friend_number
                if action_table(friend_list(j)) == 1
                    fit_f = fit_f + fitness_calculate_est(friend_list(j), sf_ratio);
                else
                    fit_n = fit_n + fitness_calculate_est(friend_list(j), sf_ratio);
                end
            end
            if action_table(i) == 1
                judge = fit_n/(fit_f + fit_n);
                if rand <= judge
                    action_table(i) = 0;
                end
            else
                judge = fit_f/(fit_f + fit_n);
                rand_num = rand;
                if rand_num <= judge
                    action_table(i) = 1;
                end
            end       
        end
        result(count) = sum(action_table)/N;
        count = count +1;
    end
    
end