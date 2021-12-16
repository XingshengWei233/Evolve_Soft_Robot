function plotCube(P,f,m,sp,c,geno)
%PLOTMASS Summary of this function goes here
%   Detailed explanation goes here

%plot3(P(:,1,f),P(:,2,f),P(:,3,f),'b.');%plot mass


for i = 1:length(m)
    if m(i).mass~=0
        plot3(P(i,1,f),P(i,2,f),P(i,3,f),'k.');
        hold on
    end
end


for i = 1:length(sp)
    plot3Spring(P,f,sp(i));%plot spring
end

for i = 1:length(c)
    if geno(i) == 1
        fill3Square(P,f,c(i,1),c(i,5),c(i,6),c(i,2),'g');
        fill3Square(P,f,c(i,1),c(i,3),c(i,4),c(i,2),'g');
        fill3Square(P,f,c(i,1),c(i,5),c(i,7),c(i,3),'g');
        fill3Square(P,f,c(i,6),c(i,2),c(i,4),c(i,8),'g');
        fill3Square(P,f,c(i,4),c(i,3),c(i,7),c(i,8),'g');
        fill3Square(P,f,c(i,6),c(i,5),c(i,7),c(i,8),'g');
    end
    if geno(i) == 2
        fill3Square(P,f,c(i,1),c(i,5),c(i,6),c(i,2),'y');
        fill3Square(P,f,c(i,1),c(i,3),c(i,4),c(i,2),'y');
        fill3Square(P,f,c(i,1),c(i,5),c(i,7),c(i,3),'y');
        fill3Square(P,f,c(i,6),c(i,2),c(i,4),c(i,8),'y');
        fill3Square(P,f,c(i,4),c(i,3),c(i,7),c(i,8),'y');
        fill3Square(P,f,c(i,6),c(i,5),c(i,7),c(i,8),'y');
    end
end
end

