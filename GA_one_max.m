rand('seed',1234);
for time=1:10
    
iteration=100;
optimum=25;
popsize=100;
length=25;
xoverrate=0.7;
mutrate=1/length;

maxfitness=zeros(iteration,1);
minfitness=zeros(iteration,1);
meanfitness=zeros(iteration,1);
offspring=zeros(popsize,length); %temp
matingpool=zeros(popsize,1);


% initial the population %
pop=round(rand(popsize,length));

t=1;
while t<=iteration

  % evaluate fitness of P(t) %
  f=zeros(popsize,1);
  sum=0; %sum of fitness
  for i =1:popsize
     for j=1:length
         if pop(i,j)==1
             f(i)=f(i)+1;
         end
     end
     sum=sum+f(i);
  end
  
  maxfitness(t)=max(f);
  minfitness(t)=min(f);
  meanfitness(t)=sum/popsize;
  stdfitness=std(f);
  
  % sigma scaling %
  fitness=zeros(popsize,1);
  sum1=0;
  for i=1:popsize
      fitness(i)=max(f(i)-(meanfitness(t)-2*stdfitness),0);
      sum1=sum1+fitness(i);
  end
  % select parants %
      % calculate the cumulative prob %
  cprob=zeros(popsize,1);%cumulative prob
  for i=1:popsize
     if i==1
         cprob(i)=fitness(i)/sum1;
     else
         cprob(i)=cprob(i-1)+fitness(i)/sum1;
     end
  end
  
      % roulette wheel %
  %curmem=1;
  %for curmem=1:popsize
  %   i=1;
  %   while cprob(i)<rand
  %       i=i+1;
  %   end
  %       matingpool(curmem)=i;
  %end
  
      % SUS %
  curmem=1;
  i=1;
  r=rand/popsize;
  while curmem<=popsize
      while r<=cprob(i)
          matingpool(curmem)=i;
          r=r+1/popsize;
          curmem=curmem+1;
      end
      i=i+1;    
  end
  
  % crossover operation %
  randsel=randperm(100);
  for i=1:popsize/2
      p1=pop(matingpool(randsel(i)),:);
      p2=pop(matingpool(randsel(i+popsize/2)),:);
      rpoint=round(rand*length);
      if rand<xoverrate
          offspring(randsel(i),1:rpoint)=p1(1:rpoint);
          offspring(randsel(i),rpoint+1:end)=p2(rpoint+1:end);
          offspring(randsel(i+popsize/2),1:rpoint)=p2(1:rpoint);
          offspring(randsel(i+popsize/2),rpoint+1:end)=p1(rpoint+1:end);
      else
          offspring(randsel(i),:)=pop(i,:);
          offspring(randsel(i+popsize/2),:)=pop(i+popsize/2,:);
      end
  end
  
  % mutation operation %
  for i=1:popsize
      for j=1:length
        if rand<mutrate
           offspring(i,j)=~offspring(i,j);
        end
      end
  end
  
  % next %
  pop=offspring;
  
  if maxfitness(t)==optimum
      break;
  end
  t=t+1;
end
% plot the line %
x=1:1:t;
figure(time)
t
plot(x,maxfitness(1:t),x,meanfitness(1:t),x,minfitness(1:t))
legend('Best Fitness','Mean Fitness','Worst Fitness');

end