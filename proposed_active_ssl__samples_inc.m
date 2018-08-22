function [Rt, error_opt] = proposed_active_ssl__samples_inc(mem_fn, Ln, k, Ln_k, S_opt)
%   AUTHOR: Akshay Gadde, USC
%   This function does the following: it finds the optimal set of nodes to 
%   add to the given sampling set. Using the labels on this net sampling
%   set, it predicts the unknown labels and reports the classification
%   error along with the net sampling set.

% % %
% PARAMETER DESCRIPTION
% 
% INPUT
%S_opt:�Ѿ��ɺõ�����
% mem_fn:  ground truth membership functions of each
% Ln: normalized Laplacian
% k: Power of Laplacian while computing cutoff, higher the order,
% greater the accuracy, but the complexity is also higher.
% Ln_k: kth power of the Laplacian 
% 
% OUTPUT
% error_opt: classification error
% % %

%% options

num_iter = 100;%POCS��ͶӰ����
%% compute its cutoff frequency 
[~,omega] = eigs(Ln_k(~S_opt,~S_opt),1,'sm');%ֻ���ڲ���ѡ��ÿ�ı�һ���ı仯
cutoff = abs(omega)^(1/k);

% S_opt = zeros(N,1);
% S_opt(Sample) = true;%�Ѿ�ѡ���Ϊ1�߼�
% queries = Sample;
% [~,omega] = eigs(Ln_k(~S_opt,~S_opt),1,'sm');
% omega = abs(omega)^(1/k);%�����ֹƵ��
%% reconstruction using POCS

tic;
norm_val = zeros(num_iter,1); % used for checking convergence

% reconstruction using POCS

% approximate low pass filter using SGWT toolbox
filterlen = 10;
alpha = 8;
freq_range = [0 2];%���ڹ�һ���ľ������
g = @(x)(1./(1+exp(alpha*(x-cutoff))));
c = sgwt_cheby_coeff(g,filterlen,filterlen+1,freq_range);%1*11��ϵ��


% initialization
mem_fn_du = mem_fn;
mem_fn_du(~S_opt,:) = 0;%down-up sampling
%ֻ��ѡ�е����ݲű���ԭ����men-fun,Ҳ���ǽ��в�����������ʮ��������һ����
mem_fn_recon = sgwt_cheby_op(mem_fn_du,Ln,c,freq_range);%��խ���źſռ�ͶӰ�Ľ��//f0

for iter = 1:num_iter % takes fewer iterations
    % projection on C1
    err_s = (mem_fn_du-mem_fn_recon); 
    err_s(~S_opt,:) = 0; % error on the known set
    
    % projection on C2
    mem_fn_temp = sgwt_cheby_op(mem_fn_recon + err_s,Ln,c,freq_range); % err on S approx LP
    
    norm_val(iter) = norm(mem_fn_temp-mem_fn_recon); % to check convergence�����ϴεĽ������εķ���
    if (iter > 1 && norm_val(iter) > norm_val(iter-1) ), break; end % avoid divergence  ��ɢ������Ӧ��Խ��ԽС
    mem_fn_recon = mem_fn_temp;
end
Rt = toc;
% predicted class labels  ���ڱ�ǩ��˵����Ҫ����ʮ�ֹ����ȵı����Ƚ�
[~,f_recon] = max(mem_fn_recon,[],2);
%max(mem_fn_recon,[],2)ֱ�ӷ���ÿ�е����ֵ��[a,b]=max(mem_fn_recon,[],2)����aΪ����ֵ��bΪindex

% true class lables
[~,f] = max(mem_fn,[],2);

% reconstruction error ��ȷ�ʵļ��㷽�������Ƶĺ�ԭ������Ⱦ�����ȷ��ֻ����δ֪��ǩ�Ĺ��Ƹ��Ӻ���
error_opt = sum(f(~S_opt)~=f_recon(~S_opt))/sum(~S_opt); % error for unknown labels only