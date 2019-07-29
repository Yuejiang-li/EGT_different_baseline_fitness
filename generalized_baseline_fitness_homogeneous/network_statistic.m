function ess = network_statistic(graph)
    N = size(graph, 1);
    % calculate each node's degree
    degree_table = sum(graph); % the degree table of all node
    % calculate average degree
    avr_degree = mean(degree_table);
    % calculate total degree number and edge number
    degree_tot = sum(degree_table);
    edge_num = sum(degree_table)/2;
    % find out the minimum and maximum degree
    min_deg = min(degree_table);
    max_deg = max(degree_table);
    deg_range = max_deg - min_deg + 1;
    % form the index table for degree
    degree_idx = min_deg : max_deg;
    % histogram the frequency of each degree
    deg_fre = zeros(1, deg_range);
    for i = degree_table
        deg_fre(i - min_deg + 1) = deg_fre(i- min_deg + 1) + 1;
    end
    deg_fre = deg_fre / N;
    % calculate the joint degree distribution
    joint_deg_dist = zeros(deg_range, deg_range);
    for i = 1:N
        for j = i+1:N
            if graph(i, j) == 1
                joint_deg_dist(degree_table(i)- min_deg + 1, degree_table(j)- min_deg + 1) = ...
                    joint_deg_dist(degree_table(i)- min_deg + 1, degree_table(j)- min_deg + 1) + 1;
                joint_deg_dist(degree_table(j)- min_deg + 1, degree_table(i)- min_deg + 1) = ...
                    joint_deg_dist(degree_table(j)- min_deg + 1, degree_table(i)- min_deg + 1) + 1;
            end
        end
    end

    % using the joint degree distribution, we can calculate when the center
    % user's degree is given by k, the degree distribution and the average
    % degree of his/her neighbors (which we used in the paper is m)
    marginal_dist = sum(joint_deg_dist, 2);
    % convert to the conditional probability
    conditional_dist = zeros(deg_range, deg_range);
    for i = 1 : deg_range
        conditional_dist(i, :) = joint_deg_dist(i, :) / marginal_dist(i);
    end
    % calculate the average degree of neighbors w.r.t different degree
    neigh_avr_deg = zeros(1, deg_range);
    for i = 1: deg_range
        if deg_fre(i) == 0
            neigh_avr_deg(i) = 0;
        else
            for j = 1:deg_range
                neigh_avr_deg(i) = neigh_avr_deg(i) + ...
                    conditional_dist(i, j) * degree_idx(j);
            end
        end
    end
    g1_tab = deg_fre.* ((degree_idx - 1).*(2 - 2*neigh_avr_deg + degree_idx.*neigh_avr_deg))./degree_idx.^2;
    g2_tab = deg_fre.* ((neigh_avr_deg - 1).*(degree_idx - 1))./degree_idx.^2;
    g3_tab = deg_fre.* (neigh_avr_deg .*(degree_idx - 1))./degree_idx;
    g1 = sum(g1_tab);
    g2 = sum(g2_tab);
    g3 = sum(g3_tab);
    uff = 0.6; ufn = 0.8; unn = 0.4;
    phif = uff - ufn; phin = ufn - unn; phi = phif - phin;
    ess = -1*(g2 * phi + g3 * phin)/(phi * g1);
    ess = [g1; g2; g3; ess];
end