function [ S_opt,omega] = rdm_sample( L_k, k, num_nodes_to_add )
%�������ʹ�����ָֻ��������бȽ�
%

N = size(L_k,1);

s = randi(N,num_nodes_to_add,1);%����num_nodes_to_add������Ĳ�����
S_opt(s) = true;

[~,omega] = eigs(L_k(~S_opt,~S_opt),1,'sm');%ֻ���ڲ���ѡ��ÿ�ı�һ���ı仯
omega = abs(omega)^(1/k);


