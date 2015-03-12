%rand('seed',1234);
    
iteration=20;
optimum=5;
popsize=100;
length=70;
xoverrate=0.95;
mutrate=0.01;

maxfitness=zeros(iteration,1);
minfitness=zeros(iteration,1);
meanfitness=zeros(iteration,1);
offspring=zeros(popsize,length); %temp
matingpool=zeros(popsize,1);
fitness_table=[3,0;5,1];

% initial the population %
pop=round(rand(popsize,length));

t=1;
for t=1:iteration
t;
for i=1:popsize
 a=6;
  for j=1:popsize
    for k=1:6
        a=a+pop(j,k)*2^(k-1);
    end
    next_move(j)=pop(a);
    a=6;
  end
  for j=1:popsize
  % evaluate fitness of P(t) %
        fitness(i,j)=fitness_table(next_move(i)+1,next_move(j)+1);
        pop(i,1)=pop(i,3);
        pop(i,2)=pop(i,4);        
        pop(i,3)=pop(i,5);
        pop(i,4)=pop(i,6); 
        pop(i,5)=next_move(i);
        pop(i,6)=next_move(j);
               
        end
    end

  sum=0; %sum of fitness
  for i =1:popsize
     mean_fitness(i)=mean(fitness(i,:));
     sum=sum+mean_fitness(i);
  end
 mean_fitness;

  % select parants %
      % calculate the cumulative prob %
  cprob=zeros(popsize,1);%cumulative prob
  for i=1:popsize
     if i==1
         cprob(i)=mean_fitness(i)/sum;
     else
         cprob(i)=cprob(i-1)+mean_fitness(i)/sum;
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
  t;
  maxfitness(t)=max(mean_fitness);
  minfitness(t)=min(mean_fitness);
  meanfitness(t)=sum/popsize;
  
  if maxfitness(t)==optimum
      break;
  end
  %t=t+1;
end
% plot the line %
x=1:1:t-1;

t-1;
plot(x,maxfitness(1:t-1),x,meanfitness(1:t-1),x,minfitness(1:t-1))
legend('Best Fitness','Mean Fitness','Worst Fitness');

