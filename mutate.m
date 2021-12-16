function result=mutate(geno)
r=randi(length(geno),1,1);
geno(r)=randi(3,1)-1;
result=geno;
end