clear;
close all;
clc;

%% data and required toolboxes
    load('usps_all');
    b = zeros(16,16,12);%����ÿ�����ֵ�����ͼ
    c = data(:,1:10);%����3*4ά��ͼ
    for num = 1:10        %�ܹ���ʾ12������
        a = data(:,1,num);%data�ĵ�һάΪ256*1������������
            for n = 1:16
                b(n,:,num) = a((1+(n-1)*16):16*n,:);%��256*1ת��Ϊ16*16������ͼ��������b��
            end
    end     

    for num = 7:8        %�ܹ���ʾ12������
        a = data(:,1,num);%data�ĵ�һάΪ256*1������������
            for n = 1:16
                b(n,:,num+4) = a((1+(n-1)*16):16*n,:);%��256*1ת��Ϊ16*16������ͼ��������b��
            end
    end    
    for j = 1:12
        d = b(:,:,j);
        subplot(3,4,j);
        imshow(d');
    end

