%% Initialization
clear variables;
close all;
%Set the box threshold eg 17000
boxThreshold = 50;
obstacleThreshold= 50;
%for Cam 1 for video 0 
CamVideo = 1;
%Motors1 for power to motors
motors = 0;
%UI 1 for on 0 for off 
UI = 1;
r= groot;
size= get(groot, 'ScreenSize');
xcentre= (size(1,3)/2);
ycentre= (size(1,4)/2);
centre= [xcentre ycentre];

%intial Thresholding
HMaxB = 1;
HMinB = 0;
SMaxB = 1;
SMinB = 0;
VMaxB = 1;
VMinB = 0;

HMaxY = 0.6;
HMinY = 0.2;
SMaxY = 1;
SMinY = 0.2;
VMaxY = 1;
VMinY = 0;
if motors ==1
    s = serial('/dev/cu.usbmodem1421');
    fopen(s);
end
if CamVideo ==1
    cam= webcam(1);
    %preview(cam)
    %cam.Brightness = 10;
    %cam.Saturation=100;
    %cam.Contrast= 95;
    %cam.BacklightCompensation=1;
else
    cam = VideoReader('test1.avi');
end
centre= [0 0];
numBlobs = 1;

hblob = vision.BlobAnalysis('AreaOutputPort', true, ... % Set blob analysis handling
                                'CentroidOutputPort', true, ... 
                                'BoundingBoxOutputPort', true);
if true%UI ==1
    sliders = figure('Name', 'Colour Sliders');
    %Blue Sliders
    %Hue
    HBlueMax = uicontrol('Parent',sliders,'Style','slider','Position',[81,254,419,23],...
                  'value',HMaxB, 'min',0, 'max',1);
    HBlueMax.Callback = @(es,ed) es.Value;            
    HBlueMax1 = uicontrol('Parent',sliders,'Style','text','Position',[50,254,23,23],...
                    'String','0');
    HBlueMax2 = uicontrol('Parent',sliders,'Style','text','Position',[500,254,23,23],...
                    'String','1');
    HBlueMax3 = uicontrol('Parent',sliders,'Style','text','Position',[240,235,100,23],...
                    'String','Max Blue');    
    HBlueMin = uicontrol('Parent',sliders,'Style','slider','Position',[81,220,419,23],...
                  'value',HMinB, 'min',0, 'max',1);
    HBlueMin.Callback = @(es,ed) es.Value; 
    HBlueMin1 = uicontrol('Parent',sliders,'Style','text','Position',[50,210,23,23],...
                    'String','0');
    HBlueMin2 = uicontrol('Parent',sliders,'Style','text','Position',[500,210,23,23],...
                    'String','1');
    HBlueMin3 = uicontrol('Parent',sliders,'Style','text','Position',[240,200,100,23],...
                    'String','Min Blue');  
    %Saturation
    SBlueMax = uicontrol('Parent',sliders,'Style','slider','Position',[81,154,419,23],...
                  'value',SMinB, 'min',0, 'max',1);
    SBlueMax.Callback = @(es,ed) es.Value;            
    SBlueMax1 = uicontrol('Parent',sliders,'Style','text','Position',[50,154,23,23],...
                    'String','0');
    SBlueMax2 = uicontrol('Parent',sliders,'Style','text','Position',[500,154,23,23],...
                    'String','1');
    SBlueMax3 = uicontrol('Parent',sliders,'Style','text','Position',[240,135,100,23],...
                    'String','Max Blue');    
    SBlueMin = uicontrol('Parent',sliders,'Style','slider','Position',[81,120,419,23],...
                  'value',SMinB, 'min',0, 'max',1);
    SBlueMin.Callback = @(es,ed) es.Value; 
    SBlueMin1 = uicontrol('Parent',sliders,'Style','text','Position',[50,110,23,23],...
                    'String','0');
    SBlueMin2 = uicontrol('Parent',sliders,'Style','text','Position',[500,110,23,23],...
                    'String','1');
    SBlueMin3 = uicontrol('Parent',sliders,'Style','text','Position',[240,100,100,23],...
                    'String','Min Blue'); 
    %Value
    VBlueMax = uicontrol('Parent',sliders,'Style','slider','Position',[81,54,419,23],...
                  'value',VMaxB, 'min',0, 'max',1);
    VBlueMax.Callback = @(es,ed) es.Value;            
    VBlueMax1 = uicontrol('Parent',sliders,'Style','text','Position',[50,54,23,23],...
                    'String','0');
    VBlueMax2 = uicontrol('Parent',sliders,'Style','text','Position',[500,54,23,23],...
                    'String','1');
    VBlueMax3 = uicontrol('Parent',sliders,'Style','text','Position',[240,35,100,23],...
                    'String','Max Blue');    
    VBlueMin = uicontrol('Parent',sliders,'Style','slider','Position',[81,20,419,23],...
                  'value',VMinB, 'min',0, 'max',1);
    VBlueMin.Callback = @(es,ed) es.Value; 
    VBlueMin1 = uicontrol('Parent',sliders,'Style','text','Position',[50,10,23,23],...
                    'String','0');
    VBlueMin2 = uicontrol('Parent',sliders,'Style','text','Position',[500,10,23,23],...
                    'String','1');
    VBlueMin3 = uicontrol('Parent',sliders,'Style','text','Position',[240,0,100,23],...
                    'String','Min Blue'); 


    %Yellow Sliders
    %Hue
    HYellowMax = uicontrol('Parent',sliders,'Style','slider','Position',[81,554,419,23],...
                  'value',HMaxY, 'min',0, 'max',1);
    HYellowMax.Callback = @(es,ed) es.Value;  

    HYellowMax1 = uicontrol('Parent',sliders,'Style','text','Position',[50,554,23,23],...
                    'String','0');
    HYellowMax2 = uicontrol('Parent',sliders,'Style','text','Position',[500,554,23,23],...
                    'String','1');
    HYellowMax3 = uicontrol('Parent',sliders,'Style','text','Position',[240,535,100,23],...
                    'String','Max Yellow');   
    HYellowMin = uicontrol('Parent',sliders,'Style','slider','Position',[81,520,419,23],...
                  'value',HMinY, 'min',0, 'max',1);
    HYellowMin.Callback = @(es,ed) es.Value;  
    HYellowMin1 = uicontrol('Parent',sliders,'Style','text','Position',[50,510,23,23],...
                    'String','0');
    HYellowMin2 = uicontrol('Parent',sliders,'Style','text','Position',[500,510,23,23],...
                    'String','1');
    HYellowMin3 = uicontrol('Parent',sliders,'Style','text','Position',[240,500,100,23],...
                    'String','Min Yellow'); 
    %Saturation 
    SYellowMax = uicontrol('Parent',sliders,'Style','slider','Position',[81,454,419,23],...
                  'value',SMaxY, 'min',0, 'max',1);
    SYellowMax.Callback = @(es,ed) es.Value;  

    SYellowMax1 = uicontrol('Parent',sliders,'Style','text','Position',[50,454,23,23],...
                    'String','0');
    SYellowMax2 = uicontrol('Parent',sliders,'Style','text','Position',[500,454,23,23],...
                    'String','1');
    SYellowMax3 = uicontrol('Parent',sliders,'Style','text','Position',[240,435,100,23],...
                    'String','Max Yellow');   
    SYellowMin = uicontrol('Parent',sliders,'Style','slider','Position',[81,420,419,23],...
                  'value',SMinY, 'min',0, 'max',1);
    SYellowMin.Callback = @(es,ed) es.Value;  
    SYellowMin1 = uicontrol('Parent',sliders,'Style','text','Position',[50,410,23,23],...
                    'String','0');
    SYellowMin2 = uicontrol('Parent',sliders,'Style','text','Position',[500,410,23,23],...
                    'String','1');
    SYellowMin3 = uicontrol('Parent',sliders,'Style','text','Position',[240,400,100,23],...
                    'String','Min Yellow'); 
    %Value 
    VYellowMax = uicontrol('Parent',sliders,'Style','slider','Position',[81,354,419,23],...
                  'value',VMaxY, 'min',0, 'max',1);
    VYellowMax.Callback = @(es,ed) es.Value;  

    VYellowMax1 = uicontrol('Parent',sliders,'Style','text','Position',[50,354,23,23],...
                    'String','0');
    VYellowMax2 = uicontrol('Parent',sliders,'Style','text','Position',[500,354,23,23],...
                    'String','1');
    VYellowMax3 = uicontrol('Parent',sliders,'Style','text','Position',[240,335,100,23],...
                    'String','Max Yellow');   
    VYellowMin = uicontrol('Parent',sliders,'Style','slider','Position',[81,320,419,23],...
                  'value',VMinY, 'min',0, 'max',1);
    VYellowMin.Callback = @(es,ed) es.Value;  
    VYellowMin1 = uicontrol('Parent',sliders,'Style','text','Position',[50,310,23,23],...
                    'String','0');
    VYellowMin2 = uicontrol('Parent',sliders,'Style','text','Position',[500,310,23,23],...
                    'String','1');
    VYellowMin3 = uicontrol('Parent',sliders,'Style','text','Position',[240,300,100,23],...
                    'String','Min Yellow'); 

         %Purple Sliders
    %Hue
    HPurpleMax = uicontrol('Parent',sliders,'Style','slider','Position',[81,254,419,23],...
                  'value',HMaxP, 'min',0, 'max',1);
    HPurpleMax.Callback = @(es,ed) es.Value;            
    HPurpleMax1 = uicontrol('Parent',sliders,'Style','text','Position',[50,254,23,23],...
                    'String','0');
    HPurpleMax2 = uicontrol('Parent',sliders,'Style','text','Position',[500,254,23,23],...
                    'String','1');
    HPurpleMax3 = uicontrol('Parent',sliders,'Style','text','Position',[240,235,100,23],...
                    'String','Max Purple');    
    HPurpleMin = uicontrol('Parent',sliders,'Style','slider','Position',[81,220,419,23],...
                  'value',HMinB, 'min',0, 'max',1);
    HPurpleMin.Callback = @(es,ed) es.Value; 
    HPurpleMin1 = uicontrol('Parent',sliders,'Style','text','Position',[50,210,23,23],...
                    'String','0');
    HPurple2 = uicontrol('Parent',sliders,'Style','text','Position',[500,210,23,23],...
                    'String','1');
    HPurpleMin3 = uicontrol('Parent',sliders,'Style','text','Position',[240,200,100,23],...
                    'String','Min Purple');  
    %Saturation
    SPurpleMax = uicontrol('Parent',sliders,'Style','slider','Position',[81,154,419,23],...
                  'value',SMinP, 'min',0, 'max',1);
    SPurpleMax.Callback = @(es,ed) es.Value;            
    SPurpleMax1 = uicontrol('Parent',sliders,'Style','text','Position',[50,154,23,23],...
                    'String','0');
    SPurpleMax2 = uicontrol('Parent',sliders,'Style','text','Position',[500,154,23,23],...
                    'String','1');
    SPurpleMax3 = uicontrol('Parent',sliders,'Style','text','Position',[240,135,100,23],...
                    'String','Max Purple');    
    SPurpleMin = uicontrol('Parent',sliders,'Style','slider','Position',[81,120,419,23],...
                  'value',SMinP, 'min',0, 'max',1);
    SPurpleMin.Callback = @(es,ed) es.Value; 
    SPurpleMin1 = uicontrol('Parent',sliders,'Style','text','Position',[50,110,23,23],...
                    'String','0');
    SPurpleMin2 = uicontrol('Parent',sliders,'Style','text','Position',[500,110,23,23],...
                    'String','1');
    SPurpleMin3 = uicontrol('Parent',sliders,'Style','text','Position',[240,100,100,23],...
                    'String','Min Blue'); 
    Value
    VPurpleMax = uicontrol('Parent',sliders,'Style','slider','Position',[81,54,419,23],...
                  'value',VMaxB, 'min',0, 'max',1);
    VPurpleMax.Callback = @(es,ed) es.Value;            
    VPurpleMax1 = uicontrol('Parent',sliders,'Style','text','Position',[50,54,23,23],...
                    'String','0');
    VPurpleMax2 = uicontrol('Parent',sliders,'Style','text','Position',[500,54,23,23],...
                    'String','1');
    VPurpleMax3 = uicontrol('Parent',sliders,'Style','text','Position',[240,35,100,23],...
                    'String','Max Purple');    
    VPurpleMin = uicontrol('Parent',sliders,'Style','slider','Position',[81,20,419,23],...
                  'value',VMinP, 'min',0, 'max',1);
    VPurpleMin.Callback = @(es,ed) es.Value; 
    VPurpleMin1 = uicontrol('Parent',sliders,'Style','text','Position',[50,10,23,23],...
                    'String','0');
    VPurpleMin2 = uicontrol('Parent',sliders,'Style','text','Position',[500,10,23,23],...
                    'String','1');
    VPurpleMin3 = uicontrol('Parent',sliders,'Style','text','Position',[240,0,100,23],...
                    'String','Min Purple'); 

           
     pause(0.1); 
end


while true
    % Acquire a single image.
   tic
   if CamVideo ==1
     rgbFrame = snapshot(cam);
     rgbFrame = imresize(rgbFrame, 0.5);
   else 
     rgbFrame = readFrame(cam);
     rgbFrame = imresize(rgbFrame, 0.25);
   end
   if UI ==1
   figure(2);
   imshow(rgbFrame);
   end
   % Convert RGB to  HSV
   image = rgb2hsv(rgbFrame);
   I = image;
   
   %for blue. Note, the values = colour wheel value/360
   %basically make everything not b;lue = nothing. dark blue =0.7 -0.65
   
   pause(0.1); 
   bmask = I(:,:,1)>=HBlueMin.Value & I(:,:,1)<=HBlueMax.Value & I(:,:,2)>=SBlueMin.Value & I(:,:,2)<=SBlueMax.Value & I(:,:,3)>=VBlueMin.Value & I(:,:,3)<=VBlueMax.Value;
   binblue=imfill(bmask,'holes'); 
   ymask = I(:,:,1)>=HYellowMin.Value & I(:,:,1)<=HYellowMax.Value & I(:,:,2)>=SYellowMin.Value & I(:,:,2)<=SYellowMax.Value & I(:,:,3)>=VYellowMin.Value & I(:,:,3)<=VYellowMax.Value;
   binyellow=imfill(ymask,'holes'); 
   pmask = I(:,:,1)>=HPurpleMin.Value & I(:,:,1)<=HPurpleMax.Value & I(:,:,2)>=SPurpleMin.Value & I(:,:,2)<=SPurpleMax.Value & I(:,:,3)>=VPurpleMin.Value & I(:,:,3)<=VPurpleMax.Value;
   binpurple=imfill(pmask,'holes'); 
  
 
   
[areaYellow,centroidYellow, bboxYellow] = step(hblob, binyellow); % Get the centroids and bounding boxes of the blue blobs
    centroidYellow = uint16(centroidYellow); % Convert the centroids into Integer for further steps
    [areaY, idxY] = max(areaYellow(:)); %finds the largest area
    [I_rowY, I_colY] = ind2sub(size(areaYellow),idxY);%finds the row and column of the largest area
    xCntdY = centroidYellow(I_rowY,1); %x value corresponding to largest centroid
    yCntdY = centroidYellow(I_rowY,2);%y value corresponding to largest centroid

    if size(xCntdY,1)~=0
        j = 1;
        for i = 1:numel(xCntdY)
            if bboxYellow(i,3)*bboxYellow(i,4) < boxThreshold
                bboxYellowClear(j) = i;
                j = j+1;
            end
        end
        if j >1
            bboxYellow(bboxYellowClear,:) = [];
            xCntdY(bboxYellowClear) = [];
            yCntdY(bboxYellowClear) = [];
            bboxYellowClear = [];
            if UI ==1
                figure(5);
                imshow(binyellow);
                hold on;
            end 
            if UI ==1
                for i = 1:numel(xCntdY)
                    plot(xCntdY(i),yCntdY(i),'b*');
                    plot(bboxYellow(i,1):bboxYellow(i,1)+bboxYellow(i,3),bboxYellow(i,2),'b*','linewidth',0.5);
                    plot(bboxYellow(i,1):bboxYellow(i,1)+bboxYellow(i,3),bboxYellow(i,2)+bboxYellow(i,4),'b*','linewidth',0.5);
                    plot(bboxYellow(i,1),bboxYellow(i,2):bboxYellow(i,2)+bboxYellow(i,4),'b*','linewidth',0.5);
                    plot(bboxYellow(i,1)+bboxYellow(i,3),bboxYellow(i,2):bboxYellow(i,2)+bboxYellow(i,4),'b*','linewidth',0.5);
                end
            end
        end
    end
    [areaBlue,centroidBlue, bboxBlue] = step(hblob, binblue); % Get the centroids and bounding boxes of the blue blobs
    centroidBlue = uint16(centroidBlue); % Convert the centroids into Integer for further steps
    [areaB, idxB] = max(areaBlue(:)); %finds the largest area
    [I_rowB, I_colB] = ind2sub(size(areaBlue),idxB);%finds the row and column of the largest area
    xCntdB = centroidBlue(I_rowB,1); %x value corresponding to largest centroid
    yCntdB = centroidBlue(I_rowB,2);%y value corresponding to largest centroid
    j = 1;
    if size(xCntdB,1) ~=0
        for i = 1:numel(xCntdB)
            if bboxBlue(i,3)*bboxBlue(i,4) < boxThreshold
                bboxBlueClear(j) = i;
                j = j+1;
            end
        end
        bboxBlue(bboxBlueClear,:) = [];
        xCntdB(bboxBlueClear) = [];
        yCntdB(bboxBlueClear) = [];
        
        bboxBlueClear = [];
        if UI ==1
            figure(3);
            imshow(binblue);
            hold on;
        end
        if UI ==1
            for i = 1:numel(xCntdB)
                plot(xCntdB(i),yCntdB(i),'b*');
                plot(bboxBlue(i,1):bboxBlue(i,1)+bboxBlue(i,3),bboxBlue(i,2),'b*','linewidth',0.5);
                plot(bboxBlue(i,1):bboxBlue(i,1)+bboxBlue(i,3),bboxBlue(i,2)+bboxBlue(i,4),'b*','linewidth',0.5);
                plot(bboxBlue(i,1),bboxBlue(i,2):bboxBlue(i,2)+bboxBlue(i,4),'b*','linewidth',0.5);
                plot(bboxBlue(i,1)+bboxBlue(i,3),bboxBlue(i,2):bboxBlue(i,2)+bboxBlue(i,4),'b*','linewidth',0.5);
            end
        end
    end
    
  [areaPurple,centroidPurple, bboxPurple] = step(hblob, binpurple); % Get the centroids and bounding boxes of the blue blobs
    centroidPurple = uint16(centroidPurple); % Convert the centroids into Integer for further steps
    [areaP, idxP] = max(areaPurple(:)); %finds the largest area
    [I_rowP, I_colP] = ind2sub(size(areaPurple),idxP);%finds the row and column of the largest area
    xCntdP = centroidPurple(I_rowP,1); %x value corresponding to largest centroid
    yCntdP = centroidPurple(I_rowP,2);%y value corresponding to largest centroid

    j = 1;
    if size(xCntdP,1) ~=0
        for i = 1:numel(xCntdP)
            if bboxPurple(i,3)*bboxPurple(i,4) < boxThreshold
                bboxPurpleClear(j) = i;
                j = j+1;
            end
        end
        bboxPurple(bboxPurpleClear,:) = [];
        xCntdB(bboxPurpleClear) = [];
        yCntdB(bboxPurpleClear) = [];
        
        bboxPurpleClear = [];
        if UI ==1
            figure(3);
            imshow(binblue);
            hold on;
        end
        if UI ==1
            for i = 1:numel(xCntdP)
                plot(xCntdB(i),yCntdP(i),'p*');
                plot(bboxPurple(i,1):bboxPurple(i,1)+bboxPurple(i,3),bboxPurple(i,2),'p*','linewidth',0.5);
                plot(bboxPurple(i,1):bboxPurple(i,1)+bboxPurple(i,3),bboxPurple(i,2)+bboxPurple(i,4),'p*','linewidth',0.5);
                plot(bboxPurple(i,1),bboxPurple(i,2):bboxPurple(i,2)+bboxPurple(i,4),'p*','linewidth',0.5);
                plot(bboxPurple(i,1)+bboxPurple(i,3),bboxPurple(i,2):bboxPurple(i,2)+bboxPurple(i,4),'p*','linewidth',0.5);
            end
        end
    end
  
   % numBiggestY=find(bboxYellow(:,3).*bboxYellow(:,4)==max(bboxYellow(:,3).*bboxYellow(:,4)))
   % numBiggestB=find(bboxBlue(:,3).*bboxBlue(:,4)==max(bboxBlue(:,3).*bboxBlue(:,4)))

   %if else loop for the obstacle. Assume Blue right, yellow left.

  
   if motors ==1
      if maxareaP > obstacleThreshold (how ever many pixels) %obstacle is a problem
          if abs(xCtdB-xCtdP)< abs(xCtdY-xCtdP) %if the purple is on the RHS, new RHS is purple
              rhs=xCtdP;
          elseif  abs(xCtdB-xCtdP)< abs(xCtdY-xCtdP) 
              lhs=xCtdP;
          end
       elseif max(areaPurple)< obstacleThreshold
              rhs = xCtdB;
              lhs= xCtdY;
      end
   end      
    
%if else loop for the wheels
        if lhs > rhs
     %   then turn wheels right
        wheelAngle = (bboxBlue(numBiggest,1)-size(bmask,2))/(size(bmask,2)/90)
    elseif lhs < rhs 
        wheelAngle = (bboxYellow(numBiggest,1)-size(bmask,2))/(size(bmask,2)/90)+90
    end
     fwrite(wheelAngle,1);
      end
    %else
    %return 0;

 toc
end
%clear('cam');
