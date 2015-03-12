rand('seed',1234);
record=zeros(100,1);
record=zeros(100,1);
for time=1:100
    
n=30;
generation=1000;
mu=30;%u
lamda=200;%
learningrate=1/sqrt(n);

sigma=ones(mu,1);%o~
sigma1=zeros(lamda,1);%o~'
parent=zeros(lamda,n);
offspring=zeros(lamda,n);

minf=zeros(generation,1);
meanf=zeros(generation,1);
stdf=zeros(generation,1);

% initialie %
pop=rand(mu,n)*60-30;%initial population range [-30,30]
ackley=zeros(lamda,1);% store function value %
t=1;

while t<=generation
   % recombination %
       % discrete recombination on the object variables %
    for i=1:lamda
        for j=1:n
            r=round(rand*(mu-1))+1;
            parent(i,j)=pop(r,j);
        end
    end
    
      % global intermediate recombination on the sigma %
     for i=1:lamda
        r=round(rand(2,1)*(mu-1))+1;% randomly select two parent
        p1=sigma(r(1));
        p2=sigma(r(2));
        sigma1(i)=p1+rand*(p2-p1);
     end
      % mutate:uncorrelated mutation with one step size %
    for i=1:lamda
          sigma1(i)=sigma1(i)*exp(learningrate*randn);
            % boundary rule %
          if sigma1(i)<0.0001 
              sigma1(i)=0.0001;
          end
        for j=1:n
            parent(i,j)=parent(i,j)+sigma1(i)*randn;
        end
    end
     % evaluate %  
    for i=1:lamda
        ackley(i)=f(parent(i,:),n);
       
    end
     % survivor select best mu% 
    [rank,rank1]=sort(ackley); % rank1:index value. rank:sorted ackley value
    %mark the top mu member
    for i=1:mu
        pop(i,:)=parent(rank1(i),:);
        sigma(i)=sigma1(rank1(i));
    end
    meanf(t)=mean(ackley);
    minf(t)=min(ackley);
    stdf(t)=std(ackley);
    if min(ackley)<=7.48*10^(-8)
        break;
    end
    t=t+1;
end
record(time)=t;% store the best generation of each run
record1(time)=min(minf);%store the best ackley value of each run
end