function result = simulate_DB(uff, ufn, unn, graph, alpha, iterate_time, N, p_ini, b)
%   Date: 2019.07.22
%   This code is modifed for advanced perfomance.

% ------------------fitness calculation-------------------------
    function fit_result = fitness_calculate(index)
        %calculate fitness
        fit = 0;
        neigh = degree_table(index);
        neigh_tab = con_matrix(index, 1:neigh);
        str_tab = action_table(neigh_tab);
        f_num = sum(str_tab);
        n_num = neigh - f_num;
        if action_table(index)==1
            fit = fit + f_num * uff + n_num * ufn;  
        else
            fit = fit + f_num * ufn + n_num * unn;
        end
        %need to change b
        fit_result = (1 - alpha) * b + alpha*fit;
    end
% --------------------------------------------------------------

% --------------------find friend-------------------------------
%     function list = find_friend(ind)
%         l = 1;
%         list = [];
%         while con_matrix(ind, l)~=0
%             list = [list, con_matrix(ind, l)];
%             l = l +1;
%         end
%     end
% --------------------------------------------------------------

    con_matrix = graph;
    action_table = zeros(1, N);
    result = zeros(1, iterate_time);
    %   degree table is used to record users' degree.
    degree_table = zeros(1, N);
    for i = 1: N
        j = 1;
        while con_matrix(i, j) ~= 0
            j = j + 1;
        end
        degree_table(i) = j - 1;
    end
    
%   The network's order is decided with 'random_graph_order.m'
    
%   we have to assign the initial sf adopters 
    ini_user =  randperm(N, p_ini*N);
    action_table(ini_user) = 1;
    count = 1;
    result(count) = sum(action_table)/N;
    count = count + 1;
%     begin the DB update rule
    while count <= iterate_time
        for p = 1:N
            % pick a central user
            i = randi(N);
            %find friend
            friend_number = degree_table(i);
            friend_list = con_matrix(i, 1:friend_number);
            %calculate self-fitness
%             fit_self = fitness_calculate(i);
            fit_f = 0;
            fit_n = 0;
            for j =1:friend_number
                if action_table(friend_list(j))==1
                    fit_f = fit_f + fitness_calculate(friend_list(j));
                else
                    fit_n = fit_n + fitness_calculate(friend_list(j));
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