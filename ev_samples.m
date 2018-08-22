%%����������S_opt
clear;
close all;
clc;

%% data and required toolboxes

addpath(genpath('data'));

%%
%1.�ȸ��ݽڵ���Ŀ��Ҫ������󻯽�ֹƵ��ΪĿ��ѡ��ڵ㼯�ϣ�greedy���㷨������Ӧ����label
%2.����ѡ��Ľڵ�ȷ����ֹƵ�ʣ��ڸý�ֹƵ��֮�µ�����ֵ����������Ϊ�������źű�ʾ
%3.���ݵ������㷨����ԭʼ���źţ�Ҳ����ȫ�����ݼ��Ĺ�����������������Ҳ��10���
%����10����������Ļָ�����Ƚϣ�ѡ������label
%ѭ��ʮ����������ݼ������ֵ
%%

% Number of datasets (avg results reported) ���ݼ�����������Ĵ������ڽ���һ��
num_datasets = 10;

% Power of Laplacian
k = 12; % higher k leads to better estimate of the cut-off frequency

% compare the classification accuracies
labelled_percentage = 0.045:0.01:0.095;
num_points = length(labelled_percentage);
for iter = 8:num_datasets

    %% data
    
    fprintf(['\n\nloading set' num2str(iter) '...\n\n']);%\n��һ��
    a  = load(['set' num2str(iter) '.mat']);%����һ�����ݼ������и��ְ�ලѧϰ

    N = size(a.A,1);%�ڵ����Ŀ

    %% cells to store optimal sampling sets
    
    % We greedily select of batch of nodes to sample. Hence not necessary 
    % to start from scratch when a larger subset of nodes is to be sampled.
    % ��ѡ�����Ĳ������ϵ�ʱ����ʵǰ1%�Ĳ�����������֮ǰ�Ĳ����㣬ÿ��ֻ��Ҫ
    %�����������ӵĵ���
        
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

%full�������ܣ���MATLAB�У��ú������ڰ�һ��ϡ�����sparse matrix��ת����һ��ȫ����full matrix��
    % higher power of Laplacian
    Ln_k = Ln;
    for i = 1:(k-1)
        Ln_k = Ln_k*Ln;% s.^(3)�����ָ������ÿ��Ԫ�صĵ���ָ����
    end
   Ln_k = 0.5*(Ln_k+Ln_k.');  
    %% Choosing optimal sampling sets of different sizes
    
    prev_queries = []; % sampling set chosen in previous iteration
    %��index����ʽ�洢��queries = find(S_opt);%�ҳ��߼���1 ��index
    
    prev_nqueries = 0; % number of labels queried so far
    cur_nqueries = 0; % number of labels queried in current iteration
    
    for index_lp = 1:length(labelled_percentage)%��Ǳ����ı�ǩ
        fprintf('\n\n*** fraction of data labelled = %f ***\n\n', labelled_percentage(index_lp))
        %*** fraction of data labelled = 0.010000 ***
        nqueries = round(labelled_percentage(index_lp) * N);
 
        cur_nqueries = nqueries - prev_nqueries;%ÿ��ֻҪ�����Ѱ���µĽڵ㣬������֮ǰ�Ľڵ�֮��
        
        S_opt_prev = false(N,1);
        S_opt_prev(prev_queries) = true;%�Ѿ�ѡ���Ϊ1�߼�
        [ S_opt, ~, ~ ] = compute_opt_set_inc( Ln_k, k, cur_nqueries, S_opt_prev);
        prev_queries = find(S_opt);                                                                                       
        prev_nqueries = nqueries;
        save(['D:\matlab\����\USPS\USPS\EV_samples\samples' num2str(iter) '_' num2str(labelled_percentage(index_lp)) '.mat'],'S_opt')
    end   
end
