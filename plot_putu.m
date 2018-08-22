clear;
close all;
clc;

%% data and required toolboxes
    load(['set' num2str(1) '.mat']);%����һ�����ݼ������и��ְ�ලѧϰ

    N = size(A,1);%�ڵ����Ŀ
    
    %���˽ṹ�Ѿ��̶�����ÿһ���������˵

    % compute the symmetric normalized Laplacian matrix
    d = sum(A,2);
    d(d~=0) = d.^(-1/2);
    Dinv = spdiags(d,0,N,N);%spdiags �ͼ򵥵�diag��ʲô�����أ�
    %A = spdiags(B,d,m,n) 
    %creates an m-by-n sparse matrix by taking the columns of B and placing them along the diagonals specified by d
    Ln = speye(N) - Dinv*A*Dinv;%����ϡ��Ĵ洢��ʽ��1000000��������52��Ŀռ�
    clear Dinv;

    % make sure the Laplacian is symmetric
    Ln = 0.5*(Ln+Ln.');%֮ǰ���ڷǶԳ�����
    % make sure the Laplacian is symmetric
    [v,eigval] = eig(full(Ln));
    x = v'*mem_fn(:,1);
    e = eigval(eigval~=0);
    figure
%     bar(e',x',0.01);%1��width
    plot(e',x');
     set(gca,'XLim',[0 2]);%X���������ʾ��Χ  
     set(gca,'YLim',[-2 6]);%X���������ʾ��Χ  
     xlabel('��_i');
     ylabel('f(��_i)');
     eng_total = (norm(x))^2;
     eng = eng_total*0.9;
     eng_K = (norm(x(1:60,:)))^2;
%     hold on
%     scatter(e',x','r*');

