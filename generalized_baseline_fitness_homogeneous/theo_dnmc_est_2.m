function theo_result = theo_dnmc_est_2(uff, ufn, unn, graph, alpha, iterate_time, p_ini, b)
    
    function y = dyn_ess(t, x)
        y = alpha/b * x * (1 - x) * (g1 * phi * x + g2 * phi + g3 * phi_n);
    end
    
    ess = network_statistic(graph);
    g1 = ess(1); g2 = ess(2); g3 = ess(3);
    phi_f = uff - ufn; phi_n = ufn - unn; phi = phi_f - phi_n;
    [t, x] = ode45(@dyn_ess, [0:iterate_time - 1], p_ini);
    theo_result = x;
    
end