%% ���ݲ�ͬ�Ĳ����źŵ�S�������
function [error_opt,Rt,queries]=compE_RE(num_queries_to_add,mem_fn, Ln, K, k, Ln_k, prev_queries)

%compute error for random sampling or SP sampling
%they have the same reconstruction method (perfect recovery)

%input:
%num_queries_to_add: the number of selected samples(%*N-�ϴ��Ѿ��ɹ���������)  
%prev_queries: Samples have been taken before.
%mem_fn: input signal(no noiseless and approximately bandlimited)
%k:(L^k)S_c�е�k�η���kԽ��Խ��ȷ���Ǹ��Ӷ�ҲԽ��
%K:���ƴ����źŵĽ��ƴ���

%output
%error_opt: reconstruction error (ԭ�ź���ָ��ź��в���ȵ����ĸ�����/δ������������) 
%queries:the index of the samples


    N = size(Ln,1);
    [v,~] = eig(full(Ln));
    %% compute optimal sampling set and store its cutoff frequency 
%     S_opt = zeros(N,1);
%     S_opt(Sample) = true;%�Ѿ�ѡ���Ϊ1�߼�
%     queries = Sample;
S_opt_prev = false(N,1);
S_opt_prev(prev_queries) = true;%�Ѿ�ѡ���Ϊ1�߼�
[S_opt, ~] = compute_opt_set_inc(Ln_k, k, num_queries_to_add, S_opt_prev);
queries = find(S_opt);%�ҳ��߼���1 ��index% S_opt = zeros(N,1);

    % ���ǽ��ƴ��޵��ź�    
    tic;
    x_S = mem_fn(queries,:);
    x_Ke=pinv(v(queries,1:K))*x_S;%pinv ����α�� % x_Ke: estimate of x_K
    x_e=v(:,1:K)*x_Ke;
    % predicted class labels  ���ڱ�ǩ��˵����Ҫ����ʮ�ֹ����ȵı����Ƚ�
    [~,f_recon] = max(x_e,[],2);
    %max(mem_fn_recon,[],2)ֱ�ӷ���ÿ�е����ֵ��[a,b]=max(mem_fn_recon,[],2)����aΪ����ֵ��bΪindex
    % true class lables
    [~,f] = max(mem_fn,[],2);
    % reconstruction error ��ȷ�ʵļ��㷽�������Ƶĺ�ԭ������Ⱦ�����ȷ��ֻ����δ֪��ǩ�Ĺ��Ƹ��Ӻ���
    error_opt = sum(f(~S_opt)~=f_recon(~S_opt))/sum(~S_opt); % error for unknown labels only
    Rt = toc;
end