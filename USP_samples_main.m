clear;
close all;
clc;

%% data and required toolboxes

addpath(genpath('data'));
addpath(genpath('sgwt_toolbox'));
%addpath(genpath('random_samples'));
addpath(genpath('EV_samples'));
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
% k = 7; % higher k leads to better estimate of the cut-off frequency,����12�����ܵı仯
k = 13;

K = 60;%�źŵĴ���

%M = 300;%�ܵĲ�������

% compare the classification accuracies
labelled_percentage = 0.04:0.005:0.1;
num_points = length(labelled_percentage);

% t_RE = zeros(num_points, num_datasets);%����ʱ��
% t_MIA = zeros(num_points, num_datasets);%����ʱ��
% t = zeros(num_points, num_datasets);

  error_list = zeros(num_points, num_datasets);
  error_list_MIA = zeros(num_points, num_datasets);
  error_list_RE = zeros(num_points, num_datasets);
 error_list_AMIA = zeros(num_points, num_datasets);

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
    %% Choosing random sampling sets of different sizes
    %��index����ʽ�洢��queries = find(S_opt);%�ҳ��߼���1 ��index
    
      Rt_RE =  zeros(num_points,1);
      Rt_MIA =  zeros(num_points,1);
      Rt =  zeros(num_points,1);
      Rt_AMIA =  zeros(num_points,1);

       error = zeros(num_points,1);
       error_MIA = zeros(num_points,1);
       error_RE = zeros(num_points,1);
       error_AMIA = zeros(num_points,1);
    
    for index_lp = 1:num_points%��Ǳ����ı�ǩ
        fprintf('\n\n*** fraction of data labelled = %f ***\n\n', labelled_percentage(index_lp))
        %*** fraction of data labelled = 0.040000 ***
        s = load(['ev_samples' num2str(iter) '_' num2str(labelled_percentage(index_lp)) '.mat']);%����һ�����ݼ������и��ְ�ලѧϰ

        %save(['D:\matlab\����\shouxieshuzishibie\S_opt\rdm_samples' num2str(iter) num2str(index_lp) '.mat'],'S_opt')
        [Rt(index_lp), error(index_lp)] = proposed_active_ssl__samples_inc(a.mem_fn, Ln, k, Ln_k, s.S_opt);
          [error_MIA(index_lp),Rt_MIA(index_lp)] = compE_MIA_samples(a.mem_fn, Ln, L, s.S_opt);                                                                                           
           [error_RE(index_lp),Rt_RE] = compE_RE_samples(a.mem_fn, Ln, K, s.S_opt);
         [error_AMIA(index_lp),Rt_AMIA(index_lp)] = compE_AMIA_samples(a.mem_fn, Ln, Ln_k, K, L, k, s.S_opt);
         
         fprintf('classification error_MIA (proposed) = %f \n\n', error_MIA(index_lp));
         fprintf('classification error (proposed) = %f \n\n', error(index_lp));
         fprintf('classification error_RE (proposed) = %f \n\n', error_RE(index_lp));
         fprintf('classification error_AMIA (proposed) = %f \n\n', error_AMIA(index_lp));

    end
    
      error_list_RE(:,iter) = error_RE;
      error_list_MIA(:,iter) = error_MIA;
      error_list(:,iter) = error;
      error_list_AMIA(:,iter) = error_AMIA;

%     t_RE(:,iter) = Rt_RE;    
%     t_MIA(:,iter) = Rt_MIA;
%     t(:,iter) = Rt;
end
  e_RE = mean(1-error_list_RE,2);
  e_MIA = mean(1-error_list_MIA,2);
  e_pocs = mean(1-error_list,2);
  e_AMIA = mean(1-error_list_AMIA,2);

  save(['D:\matlab\����\USPS\USPS\error\error_all.mat'],'e_AMIA','e_RE','e_pocs','e_MIA')

