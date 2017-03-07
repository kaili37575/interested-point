% Local Feature Stencil Code
 
% Returns a set of feature descriptors for a given set of interest points. 

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'feature_width', in pixels, is the local feature width. You can assume
%   that feature_width will be a multiple of 4 (i.e. every cell of your
%   local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)

function [features] = get_features(image, x, y, feature_width)

% To start with, you might want to simply use normalized patches as your
% local feature. This is very simple to code and works OK. However, to get
% full credit you will need to implement the more effective SIFT descriptor
% (See Szeliski 4.1.2 or the original publications at
% http://www.cs.ubc.ca/~lowe/keypoints/)

% Your implementation does not need to exactly match the SIFT reference.
% Here are the key properties your (baseline) descriptor should have:
%  (1) a 4x4 grid of cells, each feature_width/4.
%  (2) each cell should have a histogram of the local distribution of
%    gradients in 8 orientations. Appending these histograms together will
%    give you 4x4 x 8 = 128 dimensions.
%  (3) Each feature should be normalized to unit length
%
% You do not need to perform the interpolation in which each gradient
% measurement contributes to multiple orientation bins in multiple cells
% As described in Szeliski, a single gradient measurement creates a
% weighted contribution to the 4 nearest cells and the 2 nearest
% orientation bins within each cell, for 8 total contributions. This type
% of interpolation probably will help, though.

% You do not have to explicitly compute the gradient orientation at each
% pixel (although you are free to do so). You can instead filter with
% oriented filters (e.g. a filter that responds to edges with a specific
% orientation). All of your SIFT-like feature can be constructed entirely
% from filtering fairly quickly in this way.

% You do not need to do the normalize -> threshold -> normalize again
% operation as detailed in Szeliski and the SIFT paper. It can help, though.

% Another simple trick which can help is to raise each element of the final
% feature vector to some power that is less than one. This is not required,
% though.

% Placeholder that you can delete. Empty features.

n=size(x,1);
h= fspecial('gaussian',[25 25],2);  
   
image = filter2(h,image);   

fx=[-1 0 1;-1 0 1;-1 0 1];
fy=fx';

z=zeros(1,128);
t=zeros(n,128);
features=zeros(n,128);
c=zeros(1,8);
count=1;
x=x';
y=y';
 
 for i=1:n
   A=image(x(i)-7:x(i)+8,y(i)-7:y(i)+8);  %find 16by16 block around interested point
   A_x=imfilter(A,fx);
   A_y=imfilter(A,fy);
   A_xy=(A_x.^2+A_y.^2).^0.5;
   
   for j=1:16
       for k=1:16
   if A_xy(j,k)==0 
       A_xy(j,k)=0.000001;
   end
   
   theta(j,k)=asin(A_x(j,k)/A_xy(j,k));
      theta(j,k)=round(rad2deg(theta(j,k)));
      theta = wrapTo360(theta);%compute angle and translate it into 0-360 degree
       end
   end

for mm=1:4
    for nn=1:4
    e=theta(1+(mm-1)*4:4*mm,1+(nn-1)*4:4*nn);
    em=e(:);
[c]=histc(em,1:45:360);%compute HOG and divided into 8 bins

c=c';
ssum=sum(c);
c=c./ssum; 
[max_c inx]=max(c);



if inx>1
temp1=c(inx:end);
temp2=c(1:inx-1);
temp=[temp2 temp1];

end


z(count:count+7)=c;
count=count+8;
c(:)=0;
    end
end

   
t(i,:)=z;
count=1;
 end

features=t;


end





