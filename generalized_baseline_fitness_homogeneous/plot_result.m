% result_number = length(result);
% for i = 1: result_number
%     plot(result{1, i})
%     hold on
% end

% [len_b, len_k] = size(result);
% for i = 1:len_b
%     figure
%     for j = 1:len_k
%         plot(result{i, j});
%         hold on
%     end
% end

% show the results with respect to different b
% [len_b, len_k] = size(result);
% for i = 1:len_b
%     figure
%     for j = 1:len_k
%         plot(result{i, j});
%         hold on
%     end
% end

% show the results with respect to differet k
[len_b, len_k] = size(result);
for i = 1:len_k
    figure
    for j = 1:len_b
        plot(result{j, i});
        hold on
    end
end

% plot the ess changing with k, w.r.t differet b
% figure
% k_table = 80:2:100;
% [len_b, len_k] = size(result);
% ess_table = zeros(len_b, len_k);
% for i = 1:len_b
%     for j = 1:len_k
%         ess_table(i, j) = mean(result{i, j}(end - 200: end));
%     end
%     plot(k_table, ess_table(i, :));
%     hold on
% end
% legend('b = 1', 'b = 5', 'b = 10', 'b = 15', 'b = 20')

% [~, len_r] = size(result);
% for i = 1:len_r
%     plot(result{1, i}(3, :))
%     hold on
% end