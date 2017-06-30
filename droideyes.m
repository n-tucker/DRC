
%% Initialization
clear variables;
close all;

cam= webcam('HD WebCam')
%preview(cam)
cam.Brightness = 10;
cam.Saturation=100;
cam.Contrast= 95;
cam.BacklightCompensation=1;
centre= [0 0];
numBlobs = 1;

hblob = vision.BlobAnalysis('AreaOutputPort', false, ... % Set blob analysis handling
                                'CentroidOutputPort', true, ... 
                                'BoundingBoxOutputPort', true);

for idx = 1:100
 % Acquire a single image.
   rgbFrame = snapshot(cam);

   % Convert RGB to  HSV
   image = rgb2hsv(rgbFrame);
   H = image(:,:,1); %Hue
   %S= image(:,:,2);
   %V= image(:,:,3);
   H2= image(:,:,1);  
   H3= image(:,:,1);
   %for blue. Note, the values = colour wheel value/360
   %basically make everything not b;lue = nothing. dark blue =0.7 -0.65
    b=H;
    b( b( : , : , 1 ) > 0.70 ) = 0;
    b( b(: , : , 1) < 0.65 ) = 0;
   blue = medfilt2(medfilt2(b)); %use a medfilter
   binblue=imfill(im2bw(blue),'holes'); %make a binary image and fill in 
   
   %inred= imcomplement(binred);
   %imshow(binblue);
   
   
   %for red. We really need to get some sliders going
   %r=H2;
   % r( r( : , : , 1 )> 1.0) = 0;
    %r( r(: , : , 1) <0.98 ) = 0;
   % red= medfilt2(r);
   % binred=im2bw(red,0.1);
   %subimage(binred); %plots on same image. If you don't want it, get rid of it! 
   %imshow(binred);
 
   %for green
   %g=H3;
   %g( g( : , : , 1 )> 0.5) = 0;
   %g( g(: , : , 1) <0.194 ) = 0;
   %green= medfilt2(g);
   %bingreen=im2bw(green);
   %subimage(bingreen);
   %imshow(bingreen); 
    
%[centroidRed, bboxRed] = step(hblob, binred); % Get the centroids and bounding boxes of the red blobs
%centroidRed = uint16(centroidRed); % Convert the centroids into Integer for further steps 
%xCntdR = centroidRed(:,1);
%yCntdR = centroidRed(:,2);
%j = 1;
%for i = 1:numel(xCntdR)
 %   if bboxRed(i,3)*bboxRed(i,4) < 50
  %      bboxRedClear(j) = i;
  %      j = j+1;
   % end
%end
%bboxRed(bboxRedClear,:) = [];
%xCntdR(bboxRedClear) = [];
%yCntdR(bboxRedClear) = [];

%[centroidGreen, bboxGreen] = step(hblob, bingreen); % Get the centroids and bounding boxes of the green blobs
%centroidGreen = uint16(centroidGreen); % Convert the centroids into Integer for further steps 
%xCntdG = centroidGreen(:,1);
%yCntdG = centroidGreen(:,2);
%j = 1;
%for i = 1:numel(xCntdG)
 %   if bboxGreen(i,3)*bboxGreen(i,4) < 50
 %       bboxGreenClear(j) = i;
  %      j = j+1;
  %  end
%end
%bboxGreen(bboxGreenClear,:) = [];
%xCntdG(bboxGreenClear) = [];
%yCntdG(bboxGreenClear) = [];

[centroidBlue, bboxBlue] = step(hblob, binblue); % Get the centroids and bounding boxes of the blue blobs
centroidBlue = uint16(centroidBlue); % Convert the centroids into Integer for further steps 
xCntdB = centroidBlue(:,1);
yCntdB = centroidBlue(:,2);
j = 1;
for i = 1:numel(xCntdB)
    if bboxBlue(i,3)*bboxBlue(i,4) < 17000
        bboxBlueClear(j) = i;
        j = j+1;
    end
end
bboxBlue(bboxBlueClear,:) = [];
xCntdB(bboxBlueClear) = [];
yCntdB(bboxBlueClear) = [];

figure(3);
imshow(binblue);
hold on;
for i = 1:numel(xCntdB)
    plot(xCntdB(i),yCntdB(i),'b*');
    plot(bboxBlue(i,1):bboxBlue(i,1)+bboxBlue(i,3),bboxBlue(i,2),'b*','linewidth',0.5);
    plot(bboxBlue(i,1):bboxBlue(i,1)+bboxBlue(i,3),bboxBlue(i,2)+bboxBlue(i,4),'b*','linewidth',0.5);
    plot(bboxBlue(i,1),bboxBlue(i,2):bboxBlue(i,2)+bboxBlue(i,4),'b*','linewidth',0.5);
    plot(bboxBlue(i,1)+bboxBlue(i,3),bboxBlue(i,2):bboxBlue(i,2)+bboxBlue(i,4),'b*','linewidth',0.5);
end

%if else loop for the wheels

%if centroidBlue(1,2)-centre(1,2) > centroidGreen(1,2)-centre(1,2);
 %   then turn wheels left/right
%if centroid centroidBlue(1,2)-centre(1,2) > centroidGreen(1,2)-centre(1,2);
 %   then turn wheelse right/left


%figure(1);
%imshow(binred);
%hold on;
%for i = 1:numel(xCntdR)
 %   plot(xCntdR(i),yCntdR(i),'r*');
  %  plot(bboxRed(i,1):bboxRed(i,1)+bboxRed(i,3),bboxRed(i,2),'r*','linewidth',0.5);
   % plot(bboxRed(i,1):bboxRed(i,1)+bboxRed(i,3),bboxRed(i,2)+bboxRed(i,4),'r*','linewidth',0.5);
   % plot(bboxRed(i,1),bboxRed(i,2):bboxRed(i,2)+bboxRed(i,4),'r*','linewidth',0.5);
   % plot(bboxRed(i,1)+bboxRed(i,3),bboxRed(i,2):bboxRed(i,2)+bboxRed(i,4),'r*','linewidth',0.5);
%end

%figure(2);
%imshow(bingreen);
%hold on;
%for i = 1:numel(xCntdG)
 %   plot(xCntdG(i),yCntdG(i),'g*');
 %   plot(bboxGreen(i,1):bboxGreen(i,1)+bboxGreen(i,3),bboxGreen(i,2),'g*','linewidth',0.5);
 %   plot(bboxGreen(i,1):bboxGreen(i,1)+bboxGreen(i,3),bboxGreen(i,2)+bboxGreen(i,4),'g*','linewidth',0.5);
 %   plot(bboxGreen(i,1),bboxGreen(i,2):bboxGreen(i,2)+bboxGreen(i,4),'g*','linewidth',0.5);
 %   plot(bboxGreen(i,1)+bboxGreen(i,3),bboxGreen(i,2):bboxGreen(i,2)+bboxGreen(i,4),'g*','linewidth',0.5);
 
end
%clear('cam');