function [ S_opt, omega, omega_list ] = compute_opt_set_inc( L_k, k, num_nodes_to_add, current_S_opt )
%   AUTHOR: Aamir Anis, USC
%   This function computes the optimal sampling set of a given size 
%   "S_opt_size" that maximizes the cutoff frequency.

% % %
% PARAMETER DESCRIPTION
% 
% INPUT
% L_k: kth power of Laplacian
% S_opt_size:  Desired size of the optimal set
% k: Power of Laplacian while computing cutoff, higher the order,
% greater the accuracy, but the complexity is also higher.
% 
% OUTPUT
% S_opt: Optimal set as a logical vector
% omega: cutoff of the optimal set
% omega_list: List of computed cutoffs
% 只有前两个输出
% % %

% fprintf('Starting optimal set search...\n');
N = length(L_k);

% Symmetrization
L_k = 0.5*(L_k+L_k.');

% index vector
p = (1:N)';

% Initialization : If previous state available, initialize to that
if (exist('current_S_opt','var'))
    S_opt = current_S_opt;
else
    S_opt = false(N,1);
end
omega_list = zeros(num_nodes_to_add, 1);  

for iter = 1:num_nodes_to_add

%     tic

%   fprintf('Iteration %d of %d...\n', iter, S_opt_size);

    % create index vector for Sc from indicator functions
    q = p(~S_opt);%如果S-opt出现1，就把对应位置的index去掉，降维的效果

    % compute minimum eigen-pair: efficient way
    [y,omega] = eigs(L_k(~S_opt,~S_opt),1,'sm');%只会在补集选择，每改变一个的变化
    omega = abs(omega)^(1/k);

    % store a list of omega 
    omega_list(iter) = omega;%最后的那个Omega就是cutoff-frequency，y是对应的特征向量

    % find direction of maximum increment in reduced (|Sc|) dimensions
    [~,max_index] = max(abs(y));

    % Find corresponding node in N dimensions
    node_to_add = q(max_index);

    % Update indicator function
    S_opt(node_to_add) = 1;%把最大结果的位置标签加入S-opt

    fprintf('Nodes added = %d...\n', sum(S_opt));
    
%     toc

end

% omega = compute_cutoff(L_k, k, S_opt);%最后的计算下在这个比例下的集合选取的截止频率
[~,omega] = eigs(L_k(~S_opt,~S_opt),1,'sm');
omega = abs(omega)^(1/k);
omega_list = [omega_list; omega];

% fprintf('Finished.\n');
