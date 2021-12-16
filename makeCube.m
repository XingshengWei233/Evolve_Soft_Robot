function [sp,m] = makeCube(sp,m,c,b)
%MAKECUBE Summary of this function goes here
%   Detailed explanation goes here
for i=2:7
    if connected(m(c(1)),m(c(i))) == 0
        [sp(length(sp)+1),m(c(1)),m(c(i))] = connectSpring(length(sp)+1,m(c(1)),m(c(i)),b);
    end
    if connected(m(c(1)),m(c(i))) == 1
        sp(mToSpr(m(c(1)),m(c(i)))).b = min(sp(mToSpr(m(c(1)),m(c(i)))).b,b);%b
    end
end

if connected(m(c(2)),m(c(4))) == 0
    [sp(length(sp)+1),m(c(2)),m(c(4))] = connectSpring(length(sp)+1,m(c(2)),m(c(4)),b);
end
if connected(m(c(2)),m(c(4))) == 1
    sp(mToSpr(m(c(2)),m(c(4)))).b = min(sp(mToSpr(m(c(2)),m(c(4)))).b,b);%b
end
    
if connected(m(c(2)),m(c(6))) == 0
    [sp(length(sp)+1),m(c(2)),m(c(6))] = connectSpring(length(sp)+1,m(c(2)),m(c(6)),b);
end
if connected(m(c(2)),m(c(6))) == 1
    sp(mToSpr(m(c(2)),m(c(6)))).b = min(sp(mToSpr(m(c(2)),m(c(6)))).b,b);%b
end

if connected(m(c(3)),m(c(4))) == 0
    [sp(length(sp)+1),m(c(3)),m(c(4))] = connectSpring(length(sp)+1,m(c(3)),m(c(4)),b);
end
if connected(m(c(3)),m(c(4))) == 1
    sp(mToSpr(m(c(3)),m(c(4)))).b = min(sp(mToSpr(m(c(3)),m(c(4)))).b,b);%b
end

if connected(m(c(3)),m(c(7))) == 0
    [sp(length(sp)+1),m(c(3)),m(c(7))] = connectSpring(length(sp)+1,m(c(3)),m(c(7)),b);
end
if connected(m(c(3)),m(c(7))) == 1
    sp(mToSpr(m(c(3)),m(c(7)))).b = min(sp(mToSpr(m(c(3)),m(c(7)))).b,b);%b
end

if connected(m(c(4)),m(c(6))) == 0
    [sp(length(sp)+1),m(c(4)),m(c(6))] = connectSpring(length(sp)+1,m(c(4)),m(c(6)),b);
end
if connected(m(c(4)),m(c(7))) == 0
    [sp(length(sp)+1),m(c(4)),m(c(7))] = connectSpring(length(sp)+1,m(c(4)),m(c(7)),b);
end

if connected(m(c(4)),m(c(8))) == 0
    [sp(length(sp)+1),m(c(4)),m(c(8))] = connectSpring(length(sp)+1,m(c(4)),m(c(8)),b);
end
if connected(m(c(4)),m(c(8))) == 1
    sp(mToSpr(m(c(4)),m(c(8)))).b = min(sp(mToSpr(m(c(4)),m(c(8)))).b,b);%b
end


if connected(m(c(5)),m(c(6))) == 0
    [sp(length(sp)+1),m(c(5)),m(c(6))] = connectSpring(length(sp)+1,m(c(5)),m(c(6)),b);
end
if connected(m(c(5)),m(c(6))) == 1
    sp(mToSpr(m(c(5)),m(c(6)))).b = min(sp(mToSpr(m(c(5)),m(c(6)))).b,b);%b
end



if connected(m(c(5)),m(c(7))) == 0
    [sp(length(sp)+1),m(c(5)),m(c(7))] = connectSpring(length(sp)+1,m(c(5)),m(c(7)),b);
end
if connected(m(c(5)),m(c(7))) == 1
    sp(mToSpr(m(c(5)),m(c(7)))).b = min(sp(mToSpr(m(c(5)),m(c(7)))).b,b);%b
end

if connected(m(c(6)),m(c(7))) == 0
    [sp(length(sp)+1),m(c(6)),m(c(7))] = connectSpring(length(sp)+1,m(c(6)),m(c(7)),b);
end


if connected(m(c(6)),m(c(8))) == 0
    [sp(length(sp)+1),m(c(6)),m(c(8))] = connectSpring(length(sp)+1,m(c(6)),m(c(8)),b);
end
if connected(m(c(6)),m(c(8))) == 1
    sp(mToSpr(m(c(6)),m(c(8)))).b = min(sp(mToSpr(m(c(6)),m(c(8)))).b,b);%b
end

if connected(m(c(7)),m(c(8))) == 0
    [sp(length(sp)+1),m(c(7)),m(c(8))] = connectSpring(length(sp)+1,m(c(7)),m(c(8)),b);
end
if connected(m(c(7)),m(c(8))) == 1
    sp(mToSpr(m(c(7)),m(c(8)))).b = min(sp(mToSpr(m(c(7)),m(c(8)))).b,b);%b
end

