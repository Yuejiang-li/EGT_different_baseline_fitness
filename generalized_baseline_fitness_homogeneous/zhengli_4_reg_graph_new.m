% This code is modified based on 'zhengli_4_general_graph_new.m'
% In this derivation code, we consider the regular graph,
% so the average degeree of a neighbor, which we use m in the previous
% code, is k now.
% 2019.07.25
syms alpha b k uff ufn unn pf kf gamma_f gamma_n kf_3 kf_2 kf_1 Phi_f Phi_n
% we use m here to represent the average degree of neighbors when center
% user's degree is given by k.
% fitness of center user with strategy Sf and Sn, respectively.
fit_f = (1 - alpha) * b + alpha*( kf*uff + (k - kf)*ufn );
fit_n = (1 - alpha) * b + alpha*( kf*ufn + (k - kf)*unn );

% average fitness of different neighbors: 4 situations 
fit_ff = (1 - alpha) * b + alpha*( (k - 1) * kf/k * uff + (k - 1) * (k - kf)/k * ufn + uff );
fit_nf = (1 - alpha) * b + alpha*( (k - 1) * kf/k * ufn + (k - 1) * (k - kf)/k * unn + ufn );
fit_fn = (1 - alpha) * b + alpha*( (k - 1) * kf/k * uff + (k - 1) * (k - kf)/k * ufn + ufn );
fit_nn = (1 - alpha) * b + alpha*( (k - 1) * kf/k * ufn + (k - 1) * (k - kf)/k * unn + unn );

% according to DB update rule, the probability of strategy changing:
num_f_to_n = (k - kf) * fit_nf;
dom_f_to_n = kf * fit_ff + (k - kf) * fit_nf;
num_n_to_f = kf * fit_fn;
dom_n_to_f = kf * fit_fn + (k - kf) * fit_nn;

% simplify the f -> n probability and collect it into the form of 
%  A + alpha * B
% ---------------
%  C + alpha * D
num_f_to_n = expand(num_f_to_n);
num_f_to_n = collect(num_f_to_n, alpha);
dom_f_to_n = expand(dom_f_to_n);
dom_f_to_n = collect(dom_f_to_n, alpha);
[co_1_fn, terms_1_fn] = coeffs(num_f_to_n, alpha);
[co_2_fn, terms_2_fn] = coeffs(dom_f_to_n, alpha);
A = co_1_fn(2);
B = co_1_fn(1);
C = co_2_fn(2);
D = co_2_fn(1);

% use the approximation 
% (A + alpha * B)/(C + alpha * D) == A/C + (BC - AD)/C^2
% and subsitue uff - ufn -> Phi_f, ufn - unn -> Phi_n to simplify
num_ap_1 = B*C - A*D;
num_ap_1 = collect(num_ap_1, [b, k, pf, kf]);
num_ap_1 = subs(num_ap_1, {uff - ufn, ufn - unn}, {Phi_f, Phi_n});
num_ap_1 = collect(num_ap_1, kf);

% similar derivation of probability of n -> f
num_n_to_f = expand(num_n_to_f);
num_n_to_f = collect(num_n_to_f, alpha);
dom_n_to_f = expand(dom_n_to_f);
dom_n_to_f = collect(dom_n_to_f, alpha);
[co_1_nf, terms_1_nf] = coeffs(num_n_to_f, alpha);
[co_2_nf, terms_2_nf] = coeffs(dom_n_to_f, alpha);
A_2 = co_1_nf(2);
B_2 = co_1_nf(1);
C_2 = co_2_nf(2);
D_2 = co_2_nf(1);
num_ap_2 = B_2*C_2 - A_2*D_2;
num_ap_2 = collect(num_ap_2, [b, k, pf, kf]);
num_ap_2 = subs(num_ap_2, {uff - ufn, ufn - unn}, {Phi_f, Phi_n});
num_ap_2 = collect(num_ap_2, kf);

% calculate the average change of pf, that is,
% (1 - pf) * p(n->f) - pf * p(f -> n). 
% the first term (1 - pf) * A_2 - pf * A
num1 = (1 - pf) * A_2 - pf * A;
num1 = expand(num1);
num1 = collect(num1, kf);
% the second term (1 - pf) * (BC - AD) - pf * (B_2*C_2 - A_2*D_2)
num2 = (1 - pf) * num_ap_2 - pf * num_ap_1;
num2 = expand(num2);
num2 = collect(num2, kf);

% we first take the expection over kf, which follow the binoma distribution
% B(k, pf)
num1_avr = subs(num1, {kf^3, kf^2, kf}, {kf_3, kf_2, kf_1});
num1_avr = subs(num1_avr, {kf_3, kf_2, kf_1}, {k*pf + 3*k*(k - 1)*pf^2 + k*(k-1)*(k-2)*pf^3, k*pf + k*(k-1)*pf^2, k*pf});
num1_avr = expand(num1_avr)
num2_avr = subs(num2, {kf^3, kf^2, kf}, {kf_3, kf_2, kf_1});
num2_avr = subs(num2_avr, {kf_3, kf_2, kf_1}, {k*pf + 3*k*(k - 1)*pf^2 + k*(k-1)*(k-2)*pf^3, k*pf + k*(k-1)*pf^2, k*pf});
factor(num2_avr)