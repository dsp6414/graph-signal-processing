%������netplot
%ʹ�÷���������help netplot
%����ֻ�ܴ�������ͼ
 %���÷�������netplot(A,flag)���޷���ֵ

 %AΪ�ڽӾ���
 %NΪ�ڵ�����
 %mΪ�������ĵ���
 %�޷���ֵ
  
    function ND_netplot(A,N,m)
    x = zeros(1,N);
    y = zeros(1,N);
    for i = 1:N
        x(i)=10*rand(1);
        y(i)=10*rand(1);
    end
    S_opt = randi(N,m,1);
    title('����ͼ');
    plot(x,y,'o','MarkerFaceColor','k');
    hold on
    for i = 1:m
        plot(x(S_opt(i)),y(S_opt(i)),'o','MarkerFaceColor','r');
        hold on
    end
    for i = 1:N
        for j = i:N
            if A(i,j) ~=0
                plot([x(i),x(j)],[y(i),y(j)],'b-');
                hold on
            end
        end
    end
    end

