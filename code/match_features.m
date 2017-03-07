% Local Feature Stencil Code


% 'features1' and 'features2' are the n x feature dimensionality features
%   from the two images.
% If you want to include geometric verification in this stage, you can add
% the x and y locations of the features as additional inputs.
%
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features 1, the second column is an index
%   in features2. 
% 'Confidences' is a k x 1 matrix with a real valued confidence for every
%   match.
% 'matches' and 'confidences' can empty, e.g. 0x2 and 0x1.
function [matches, confidences] = match_features(features1, features2)

% This function does not need to be symmetric (e.g. it can produce
% different numbers of matches depending on the order of the arguments).

% For extra credit you can implement various forms of spatial verification of matches.


% 
%< Placeholder that you can delete. Random matches and confidences
%pleae detect this following paragraph and implement your own codes; 
%'matches':and 'confidences' according to the
%near neighbor based matching algorithm. 

threshold=0.7;
n1=size(features1,1);
n2=size(features2,1);
fe1=features1;
fe2=features2;
ratio=zeros(1,n2);
ll=ones(1,128);

for i=1:n1
for j=1:n2
         ratio(j)=((fe1(i,:)-fe2(j,:)).^2*ll').^0.5; 

end
 
       
max_c=max(ratio);
min_c=min(ratio);
ratio=ratio./(max_c-min_c); 

       mi = sort((ratio));

if mi(1)<threshold*mi(2)
mi_inx=find(ratio==(mi(1)));
matches(i,1)=i;
matches(i,2)=mi_inx;
confidences(i)=1-mi(1);


else
matches(i,1)=0;
confidences(i)=0;
end      
end


[r,c]=size(matches);
index=1:r;  
all(matches') ;
matches=matches(index(all(matches')),:);

c=find(confidences==0);
confidences(c)=[];
matches

end


%    num_features1 = size(features1, 1)
%    num_features2 = size(features2, 1);
%    matches = zeros(num_features1, 2);
%    matches(:,1) = randperm(num_features1);
 %   matches(:,2) = randperm(num_features2);
  %confidences = rand(n1,1);
%> 

% Sort the matches so that the most confident onces are at the top of the
% list. You should probably not delete this, so that the evaluation
% functions can be run on the top matches easily.
%[confidences, ind] = sort(confidences, 'descend');
%matches = matches(ind,:)