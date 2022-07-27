function child=crossover(parent_1,parent_2) %genotype 1*125
    nCube=length(parent_1);
    start=randi([1,nCube]);
    finish=randi([start,nCube]);
    child=zeros(1,nCube);
   
    primParent = randi(2);
    if primParent == 1
        child(1:start)=parent_1(1:start);
        child(start:finish)=parent_2(start:finish);
        if finish<nCube
            child(finish:nCube)=parent_1(finish:nCube);
        end
    end
    if primParent == 2
        child(1:start)=parent_2(1:start);
        child(start:finish)=parent_1(start:finish);
        if finish<nCube
            child(finish:nCube)=parent_2(finish:nCube);
        end
    end
end