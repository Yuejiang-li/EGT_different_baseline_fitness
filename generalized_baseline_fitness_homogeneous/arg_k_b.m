k_table = 18:2:24;
b_table = [1, 5, 10, 15, 20];
len_k = length(k_table);
len_b = length(b_table);
result = cell(len_b, len_k);

for ii = 1:len_b
    ii
    b = b_table(ii);
    for jj = 1:len_k
        jj
        tic
        k = k_table(jj);
        result{ii, jj} = simulate_DB_control_script(0.6, 0.8, 0.4, 2000, k, 0.1, 1500, 0.1, b);
        save(['./temp_result/' 'temp_result'], 'result');
        toc
    end
end
