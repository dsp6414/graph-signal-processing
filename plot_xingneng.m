%%ʹ��sp��EV��������Ļָ����
 addpath(genpath('error'));
  labelled_percentage = 0.04:0.01:0.1;
%labelled_percentage = [0.04,0.045,0.05,0.055,0.06,0.065,0.07];
 figure
%  load('e_sp_k13.mat');%��kΪ13ʱ��ʹ��EV������AMIA�ָ������Ļָ���ȷ��
%  plot(labelled_percentage,e_AMIA([1 2 3 4 5 6 7],:),'-<k');
%  hold on
 load('error_all.mat');%��kΪ13ʱ��ʹ��EV������AMIA�ָ������Ļָ���ȷ��
 plot(labelled_percentage, e_AMIA([1 3 5 7 9 11 13],:),'-p','LineWidth',1.5,'Color',[1,0,0])
 hold on 
 plot(labelled_percentage, e_MIA([1 3 5 7 9 11 13],:),'-s','LineWidth',1.5,'Color',[0,0,1])
 hold on 
 plot(labelled_percentage,e_pocs([1 3 5 7 9 11 13],:),'-d','LineWidth',1.5,'Color',[0,0,0]);
 hold on
 plot(labelled_percentage,e_RE([1 3 5 7 9 11 13],:),'->','LineWidth',1.5,'Color',[0,0.5,0]);

%%���������ָ������
% addpath(genpath('error'));
% labelled_percentage = 0.04:0.01:0.1;
% load('e_rnd_all.mat');%����һ�����ݼ������и��ְ�ලѧϰ
% figure
% plot(labelled_percentage, e_MIA,'-<k')
% hold on 
% plot(labelled_percentage,e_pocs,'-^g');
% hold on
% plot(labelled_percentage,e_RE,'->b');
% hold on
% plot(labelled_percentage,e_AMIA,'-sr');
 legend('A-MIA','MIA','ILSR','LS');
 xlabel('Percentage of labeled data'); 
 ylabel('Accuracy');
 set(gca,'YLim',[0.88 0.93]);
%%��ͬkֵ��AMIA�ָ������бȽ�
% addpath(genpath('error'));
%  labelled_percentage = 0.04:0.01:0.1;
% figure
% load('e_all.mat');
% plot(labelled_percentage,e_MIA,'-sk');
% hold on
% load('e_sp_k7.mat');%��kΪ7ʱ��ʹ��EV������AMIA�ָ������Ļָ���ȷ��
% plot(labelled_percentage,e_AMIA,'-dr');
% hold on
% load('e_sp_k12.mat');%��kΪ12ʱ��ʹ��EV������AMIA�ָ������Ļָ���ȷ��
% plot(labelled_percentage,e_AMIA,'-hb');
% hold on
% load('e_sp_k13.mat');%��kΪ13ʱ��ʹ��EV������AMIA�ָ������Ļָ���ȷ��
% plot(labelled_percentage,e_AMIA,'-dg');
% legend('���������(MIA)�ؽ�','���ٵľ��������(A-MIA)�ؽ�,k = 7','k = 12','k = 13');
% xlabel('percentage of labeled data'); 
% ylabel('Accuracy');