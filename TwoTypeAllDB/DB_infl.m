function [result_1, result_2, result] = DB_infl(uff, ufn, unn, con_matrix, alpha, iterate_time, N, percentage, p_ini_1, p_ini_2, B, b)
%   Date: 2019.08.15
%   This code is modified, so as to be more efficient
%   liyuejiang
    
    uff = uff * alpha;
    ufn = ufn * alpha;
    unn = unn * alpha;
    B = B * (1 - alpha);
    b = b * (1 - alpha);
    
    
    action_table = zeros(1, N);
    result_1 = zeros(1, iterate_time);  % result_1 is xf of influential user
    result_2 = zeros(1, iterate_time);  % result_2 is xf of non-influential user
    result = zeros(1, iterate_time);  % result is xf of the total user

    degree_table = sum(con_matrix ~= 0, 2).';  % calculate degree of each nodes
    num_inf = round(N*percentage);  % number of influential (Type 1) users
    baseline_table = zeros(1, N);
    baseline_table(1:num_inf) = B;  % set the first num_inf users as the influential users
    baseline_table(num_inf+1:N) = b;
    
    % strategy Initialization
    ini_infl_user =  randperm(num_inf, round(num_inf * p_ini_1));
    ini_no_infl_user = num_inf + randperm(N - num_inf, round((N - num_inf) * p_ini_2));
    action_table(ini_infl_user) = 1;
    action_table(ini_no_infl_user) = 1;
    
    fit_table = zeros(1, N); % fit_table: recording each user's fitness.
    for i = 1:N
        neigh_list = con_matrix(i, 1:degree_table(i));
        str_neigh = action_table(neigh_list);
        sf_neigh_num = sum(str_neigh); % count how many neighbors use sf
        if action_table(i)
            fit_table(i) = baseline_table(i) + sf_neigh_num * uff + (degree_table(i) - sf_neigh_num) * ufn;
        else
            fit_table(i) = baseline_table(i) + sf_neigh_num * ufn + (degree_table(i) - sf_neigh_num) * unn;
        end
    end
    
    count = 1;
    result_1(count) = sum(action_table(1:num_inf))/num_inf;
    result_2(count) = sum(action_table(num_inf+1:N))/(N - num_inf);
    result(count) = sum(action_table)/N;
    count = count + 1;
    
    % begin DB update rule
    while count <= iterate_time
        for p = 1:N
            i = randi(N);  % pick a central user
            friend_number = degree_table(i);  % find friends
            friend_list = con_matrix(i, 1:friend_number);
            fit_f = 0;
            fit_n = 0;
            for j = friend_list
                if action_table(j)
                    fit_f = fit_f + fit_table(j);
                else
                    fit_n = fit_n + fit_table(j);
                end
            end
            
            if action_table(i) == 1  % strategy update
                judge = fit_n/(fit_f + fit_n);
                if rand <= judge
                    action_table(i) = 0;
                    for j = friend_list  % update correlated fitness
                        if action_table(j)
                            fit_table(i) = fit_table(i) + ufn - uff;
                            fit_table(j) = fit_table(j) + ufn - uff;
                        else
                            fit_table(i) = fit_table(i) + unn - ufn;
                            fit_table(j) = fit_table(j) + unn - ufn;
                        end
                    end
                end
            else
                judge = fit_f/(fit_f + fit_n);
                if rand <= judge
                    action_table(i) = 1;
                    for j = friend_list
                        if action_table(j)
                            fit_table(i) = fit_table(i) + uff - ufn;
                            fit_table(j) = fit_table(j) + uff - ufn;
                        else
                            fit_table(i) = fit_table(i) + ufn - unn;
                            fit_table(j) = fit_table(j) + ufn - unn;
                        end
                    end
                end
            end
            
        end
        result_1(count) = sum(action_table(1:num_inf))/num_inf;
        result_2(count) = sum(action_table(num_inf+1:N))/(N - num_inf);
        result(count) = sum(action_table)/N;
        count = count +1;
    end
    
end