%% Initialization
clear variables;
close all;

%for Cam 1 for video 0 
CamVideo = 0;

if CamVideo ==1
    cam= webcam(1);
    %preview(cam)
    %cam.Brightness = 10;
    %cam.Saturation=100;
    %cam.Contrast= 95;
    %cam.BacklightCompensation=1;
else
    cam = VideoReader('GOPR7964.MP4');
end

while true 
    tic
    if CamVideo ==1
         rgbFrame = snapshot(cam);
         rgbFrame = imresize(rgbFrame, 0.5);
       else 
         rgbFrame = readFrame(cam);
         rgbFrame = imresize(rgbFrame, 0.25);
    end
    imHSV = rgb2hsv(rgbFrame);
    rgbFrame = hsv2rgb(imHSV);
    imBlue = (rgbFrame(:,:,3)-(rgbFrame(:,:,1)+rgbFrame(:,:,2))/2);
    Tb = mean(mean(imBlue))+0.04;% + std(std(imBlue));
    imBlue= imBlue- Tb;
    imBlue=imbinarize(imBlue);
    
    imHSV(:,:,1)= mod(imHSV(:,:,1)+(1/3),1);
    imYellowMagenta = hsv2rgb(imHSV);
    
    imYellow = imYellowMagenta(:,:,3)-(imYellowMagenta(:,:,1)+imYellowMagenta(:,:,2))/2;
    Ty = mean(mean(imYellow))+0.04; %+ std(std(imYellow));
    imYellow= (imYellow- Ty);
    imYellow=imbinarize(imYellow);
    
    imMagenta = imYellowMagenta(:,:,2)-(imYellowMagenta(:,:,1)+imYellowMagenta(:,:,2))/2;
    Tm = mean(mean(imMagenta)) + std(std(imMagenta));
    imMagenta= imMagenta- Tm;
    imMagenta=imbinarize(imMagenta);
    toc
%     figure(1);
%     imshow(imYellow);
%     figure(2);
%     imshow(rgbFrame);
%     figure(3);
%     imshow(imBlue);
end

