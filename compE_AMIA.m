%% ���ݲ�ͬ�Ĳ����źŵ�S�������
function [error_opt,Rt,queries]=compE_AMIA(num_queries_to_add,mem_fn, Ln, Ln_k, K, L, k, prev_queries)
%compute error for the propsoed MIA sampling method whose reconstruction is
%MIA recovery (Section IV in paper)

%input:
%num_queries_to_add: the number of selected samples(%*N-�ϴ��Ѿ��ɹ���������)  
%prev_queries: Samples have been taken before.
%mem_fn: input signal(no noiseless and approximately bandlimited)
%k:(L^k)S_c�е�k�η���kԽ��Խ��ȷ���Ǹ��Ӷ�ҲԽ��

%output
%error_opt: reconstruction error (ԭ�ź���ָ��ź��в���ȵ����ĸ�����/δ������������) 
%queries:the index of the samples

%Tpoly: Chebychev matrix polynomial approximation of T, output for recovery
%gama: Neumann series of finally selected S and output for recovery

N = size(Ln,1);

%% compute optimal sampling set 
S_opt_prev = false(N,1);
S_opt_prev(prev_queries) = true;%�Ѿ�ѡ���Ϊ1�߼�
[S_opt, ~] = compute_opt_set_inc(Ln_k, k, num_queries_to_add, S_opt_prev);
queries = find(S_opt);%�ҳ��߼���1 ��index% S_opt = zeros(N,1);

% S_opt(Sample) = true;%�Ѿ�ѡ���Ϊ1�߼�
% queries = Sample;

tic;
% the cutoff frequency to approximate eigenvalue
sample_30 = queries(1:K);%��������ΪK���ý�ֹƵ��Omega_(S)����lambda_|S|
S = zeros(N,1);
S(sample_30) = true;%�Ѿ�ѡ���Ϊ1�߼�
[~,omega] = eigs(Ln_k(~S,~S),1,'sm');
omega = abs(omega)^(1/k);%�����ֹƵ��
    
%%Tpoly: output for recovery
% approximate low pass filter using SGWT toolbox
% lambda=eig(Ln);
filterlen =10;
alpha = 8;
freq_range = [0 2];%���ڹ�һ���ľ������
g = @(x)(1./(1+exp(alpha*(x-omega))));%�������k�����30
c = sgwt_cheby_coeff(g,filterlen,filterlen+1,freq_range);%1*11��ϵ��
%�����Ҫ�������Ļ�
% rewrite sgwt_cheby_op.m to sgwt_cheby_matrix.m since we need polynomial
% matrix rather the result of matrix-vector product
Tpoly=sgwt_cheby_matrix(Ln,c,freq_range);%�Ѿ���֤�ڸ��־���ϡ����������µģ�����double��ʽ����졣

% %gama:  output for recovery
eye_size=length(queries);
        B=eye(eye_size)-Tpoly(queries,queries);
        B_sum=B;
        for l=1:(L-1)
            B_sum=(eye(eye_size)+B_sum)*B;
        end
gama=B_sum+eye(eye_size);

% if BN %�������˼��bandlimited+noisy
% %% �������+����Ĳ����ź�
%     x_spower=norm(x).^2/length(x);
%     sigma=1/(10^(SNR/10))*x_spower;%��������
% 
%     for i=1:1000 %����ļ����Ǹ���ÿ�������������źżӵģ�samples are noisy
%         WhiteNoise =randn(1, m);%��K�㹻���ʱ�������Ĺ��ʷ���SNR����С��ʱ����оֲ��Ĺ�һ��
%         UnitNoise = WhiteNoise/norm(WhiteNoise)*sqrt(length(WhiteNoise));
%         N0=sqrt(sigma)*UnitNoise;
%         y=x(S)+N0';
%         % recovery
%         tic;
%         x_e=Tpoly(:,S)*gama*y; % accompained elegent close-form recovery method 
%         Rt(i)=toc;
%         %recovery error
%         e(i)=norm(x_e-x)^2;% ��������Ӱ���� �ָ��������һ��������� ��Ҫ������� ʵ�־�ֵ��
%     end
%     Rt=mean(Rt);
%     error_opt=mean(e);%1000������ֵ�Ľ����sig �ľ�ֵ50*step��sample�Ա������Ĵ���
%     
% else

% ���ƴ���+�������Ĳ����ź�;ֱ�Ӳ����ָ������漰�����Լ������ľ��ʻ�
% recovery

     x_S = mem_fn(queries,:);
     x_e=Tpoly(:,queries)*gama*x_S;% accompained elegent close-form recovery method 
     Rt=toc;
% predicted class labels  ���ڱ�ǩ��˵����Ҫ����ʮ�ֹ����ȵı����Ƚ�
[~,f_recon] = max(x_e,[],2);
%max(mem_fn_recon,[],2)ֱ�ӷ���ÿ�е����ֵ��[a,b]=max(mem_fn_recon,[],2)����aΪ����ֵ��bΪindex

% true class lables
[~,f] = max(mem_fn,[],2);

% reconstruction error ��ȷ�ʵļ��㷽�������Ƶĺ�ԭ������Ⱦ�����ȷ��ֻ����δ֪��ǩ�Ĺ��Ƹ��Ӻ���
error_opt = sum(f(~S_opt)~=f_recon(~S_opt))/sum(~S_opt); % error for unknown labels only

end