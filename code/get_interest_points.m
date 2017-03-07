% Local Feature Stencil Code

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'feature_width', in pixels, is the local feature width. It might be
%   useful in this function in order to (a) suppress boundary interest
%   points (where a feature wouldn't fit entirely in the image, anyway)
%   or(b) scale the image filters being used. Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
function [x, y, confidence, scale, orientation] = get_interest_points(image, feature_width)

% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.

% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.

% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in 
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.

% Placeholder that you can delete. 20 random points
x_filter=[-1 0 1;-1 0 1;-1 0 1];
y_filter=[1 1 1;0 0 0;-1 -1 -1];
Ix=imfilter(image,x_filter);
Iy=imfilter(image,y_filter);
Ix2 = Ix.^2;   
Iy2 = Iy.^2;   
Ixy = Ix.*Iy; 
h= fspecial('gaussian',[25 25],2);  
   
Ix2 = filter2(h,Ix2);   
Iy2 = filter2(h,Iy2);   
Ixy = filter2(h,Ixy);

[h,w]=size(image);

Rmax = 0;                     
for i = 1:h   
    for j = 1:w  
        M = [Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)];         
        R(i,j) = det(M)-0.06*(trace(M))^2;            
        if R(i,j) > Rmax   %find Rmax value
            Rmax = R(i,j);   
        end   
    end  
end
cnt = 0; %count of interest points

for i = 2:h-1   
    for j = 2:w-1   
        % set threshold 
        if R(i,j) > 0.01*Rmax && R(i,j) > R(i-1,j-1) && R(i,j) > R(i-1,j) && R(i,j) > R(i-1,j+1) && R(i,j) > R(i,j-1) && R(i,j) > R(i,j+1) && R(i,j) > R(i+1,j-1) && R(i,j) > R(i+1,j) && R(i,j) > R(i+1,j+1)   
            result(i,j) = 1;   
            cnt = cnt+1;  
        else
            result(i,j)=0;
        end  
        
 if i >0.9*h||i <0.1*h||j >0.9*w||j <0.1*w
        result(i,j)=0;
 end
 
    end  
end  
   cnt
[x y]=find(result(:)==1);

cc=1;
for i=1:h-2
    for j=1:w-2
        if result(i,j)==1
            x(cc)=i;
            y(cc)=j;
            cc=cc+1;
        end
    end
end


%figure;
%imshow(result);

%hAx  = axes;
%imshow(image,'Parent', hAx);
%for  i=1:600
%imrect(hAx, [y(i), x(i), 1,1]);
%end


end

