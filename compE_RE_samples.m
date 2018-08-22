%% ���ݲ�ͬ�Ĳ����źŵ�S�������
function [error_opt,Rt,queries]=compE_RE_samples(mem_fn, Ln, K, S_opt)

%compute error for random sampling or SP sampling
%they have the same reconstruction method (perfect recovery)

%input:
%S_opt:�Ѿ��ɺõ�����
%mem_fn: input signal(no noiseless and approximately bandlimited)
%K:���ƴ����źŵĽ��ƴ���

%output
%error_opt: reconstruction error (ԭ�ź���ָ��ź��в���ȵ����ĸ�����/δ������������) 
%queries:the index of the samples

    [v,~] = eig(full(Ln));

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