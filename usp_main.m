clear;
close all;
clc;

%% data and required toolboxes

addpath(genpath('data'));
addpath(genpath('sgwt_toolbox'));

%%
%1.�ȸ��ݽڵ���Ŀ��Ҫ������󻯽�ֹƵ��ΪĿ��ѡ��ڵ㼯�ϣ�greedy���㷨������Ӧ����label
%2.����ѡ��Ľڵ�ȷ����ֹƵ�ʣ��ڸý�ֹƵ��֮�µ�����ֵ����������Ϊ�������źű�ʾ
%3.���ݵ������㷨����ԭʼ���źţ�Ҳ����ȫ�����ݼ��Ĺ�����������������Ҳ��10���
%����10����������Ļָ�����Ƚϣ�ѡ������label
%ѭ��ʮ����������ݼ������ֵ
%%

% Number of datasets (avg results reported) ���ݼ�����������Ĵ������ڽ���һ��
num_datasets = 10;
%numan�����ֹ����Ŀ
L = 10;

% Power of Laplacian
k = 6; % higher k leads to better estimate of the cut-off frequency,����12�����ܵı仯

K = 30;%�źŵĴ���

%M = 300;%�ܵĲ�������

% compare the classification accuracies
labelled_percentage = 0.04:0.01:0.1;
num_points = length(labelled_percentage);

% t_RE = zeros(num_points, num_datasets);%����ʱ��
% t_MIA = zeros(num_points, num_datasets);%����ʱ��
% t = zeros(num_points, num_datasets);

 error_list = zeros(num_points, num_datasets);
% error_list_MIA = zeros(num_points, num_datasets);
% error_list_RE = zeros(num_points, num_datasets);
%error_list_AMIA = zeros(num_points, num_datasets);

for iter = 1:num_datasets

    %% data
    
    fprintf(['\n\nloading set' num2str(iter) '...\n\n']);%\n��һ��
    a = load(['set' num2str(iter) '.mat']);%����һ�����ݼ������и��ְ�ලѧϰ
    N = size(a.A,1);%�ڵ����Ŀ

    %% cells to store optimal sampling sets
    
    % We greedily select of batch of nodes to sample. Hence not necessary 
    % to start from scratch when a larger subset of nodes is to be sampled.
    % ��ѡ�����Ĳ������ϵ�ʱ����ʵǰ1%�Ĳ�����������֮ǰ�Ĳ����㣬ÿ��ֻ��Ҫ
    %�����������ӵĵ���
    
      queries = cell(length(labelled_percentage),1);  %��10��cellά��
%      queries_MIA = cell(length(labelled_percentage),1);  %��10��cellά��
%      queries_RE = cell(length(labelled_percentage),1);  %��10��cellά��
%     queries_AMIA = cell(length(labelled_percentage),1);  %��10��cellά��

     %% computation to be done only once 
    %���˽ṹ�Ѿ��̶�����ÿһ���������˵

    
    % compute the symmetric normalized Laplacian matrix
    d = sum(a.A,2);
    d(d~=0) = d.^(-1/2);
    Dinv = spdiags(d,0,N,N);%spdiags �ͼ򵥵�diag��ʲô�����أ�
    %A = spdiags(B,d,m,n) 
    %creates an m-by-n sparse matrix by taking the columns of B and placing them along the diagonals specified by d
    Ln = speye(N) - Dinv*a.A*Dinv;%����ϡ��Ĵ洢��ʽ��1000000��������52��Ŀռ�
    clear Dinv;

    % make sure the Laplacian is symmetric
    Ln = 0.5*(Ln+Ln.');%֮ǰ���ڷǶԳ�����
    % make sure the Laplacian is symmetric
   
    Ln_k = Ln;
    for i = 1:(k-1)
        Ln_k = Ln_k*Ln;% s.^(3)�����ָ������ÿ��Ԫ�صĵ���ָ����
    end
   Ln_k = 0.5*(Ln_k+Ln_k.');  
    %% Choosing optimal sampling sets of different sizes
%    prev_queries_AMIA = [];
%    prev_queries_MIA = [];
     prev_queries = []; % sampling set chosen in previous iteration
    %��index����ʽ�洢��queries = find(S_opt);%�ҳ��߼���1 ��index
    
    prev_nqueries = 0; % number of labels queried so far
    cur_nqueries = 0; % number of labels queried in current iteration

%     Rt_RE =  zeros(num_points,1);
%     Rt_MIA =  zeros(num_points,1);
%     Rt =  zeros(num_points,1);

     error = zeros(num_points,1);
%     error_MIA = zeros(num_points,1);
%     error_RE = zeros(num_points,1);
%        error_AMIA = zeros(num_points,1);
    
    for index_lp = 1:num_points%��Ǳ����ı�ǩ
        fprintf('\n\n*** fraction of data labelled = %f ***\n\n', labelled_percentage(index_lp))
        %*** fraction of data labelled = 0.010000 ***
        nqueries = round(labelled_percentage(index_lp) * N);
        
        cur_nqueries = nqueries - prev_nqueries;%ÿ��ֻҪ�����Ѱ���µĽڵ㣬������֮ǰ�Ľڵ�֮��
        
%          [error_MIA(index_lp),Rt_MIA(index_lp),prev_queries_MIA] = compE_MIA(cur_nqueries,a.mem_fn, Ln, Ln_k, K, L, k, prev_queries);                                                                                           
          [prev_queries,Rt(index_lp), error(index_lp)] = proposed_active_ssl_inc(cur_nqueries,a.mem_fn, Ln, k, Ln_k, prev_queries);
%          [error_RE(index_lp),Rt_RE,prev_queries_RE] = compE_RE(cur_nqueries,a.mem_fn, Ln, K, k, Ln_k, prev_queries);
%          [error_AMIA(index_lp),Rt_AMIA(index_lp),prev_queries_AMIA] = compE_AMIA(cur_nqueries,a.mem_fn, Ln, Ln_k, K, L, k, prev_queries_AMIA);
         
%            fprintf('classification error_MIA (proposed) = %f \n\n', error_MIA(index_lp));
            fprintf('classification error (proposed) = %f \n\n', error(index_lp));
%            fprintf('classification error_RE (proposed) = %f \n\n', error_RE(index_lp));
%            fprintf('classification error_AMIA (proposed) = %f \n\n', error_AMIA(index_lp));

%           queries_RE{index_lp} = prev_queries_RE;
%           queries_MIA{index_lp} = prev_queries_MIA;
           queries{index_lp} = prev_queries;
%          queries_AMIA{index_lp} = prev_queries_AMIA;
        
        prev_nqueries = nqueries;
    end
    
%    error_list_RE(:,iter) = error_RE;
%     error_list_MIA(:,iter) = error_MIA;
     error_list(:,iter) = error;
%        error_list_AMIA(:,iter) = error_AMIA;

%     t_RE(:,iter) = Rt_RE;    
%     t_MIA(:,iter) = Rt_MIA;
%     t(:,iter) = Rt;
end
% e_RE = mean(1-error_list_RE,2);
% e_MIA = mean(1-error_list_MIA,2);
% e_pocs = mean(1-error_list,2);
e_AMIA = mean(1-error_list_AMIA,2);

save(['D:\matlab\����\shouxieshuzishibie\error\e_all.mat'],'e_RE','e_MIA','e_pocs')
%save(['D:\matlab\����\shouxieshuzishibie\error\e_AMIA.mat'],'e_AMIA')

