function DRC()
    clear;
    webcamlist

    cam = webcam(1);

    tic
    while(1)
    img = snapshot(cam);
    smallImg = imresize(img, 0.25);
    BW = im2bw(smallImg);
    hsv = rgb2hsv(smallImg);
    colorMask = colorSegment(hsv, [0,0,0], [0.1,0.99,0.99]);
    se = strel('line',10,90);
    colorMask=imerode(colorMask,se);
    colorMaskdilated = imdilate(colorMask,se);
    edges = edge(BW,'Canny');
    
    [H,theta,rho] = hough(edges);
    
    P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
    
    lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',7);
    
    figure(1), imshow(smallImg), hold on
    max_len = 0;
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
        
        % Plot beginnings and ends of lines
        plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
        plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
        
        % Determine the endpoints of the longest line segment
        len = norm(lines(k).point1 - lines(k).point2);
        if ( len > max_len)
            max_len = len;
            xy_long = xy;
        end
    end
    % highlight the longest line segment
    plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');


%     figure(1);
%     subplot(1,3,1);
%     imshow(colorMask);
%     subplot(1,3,2);
%     imshow(colorMaskdilated);
%     subplot(1,3,3);
%     imshow(edges);
    frameRate =1/toc;
    display('Frame Rate:',num2str(frameRate));
    end
end

function mask = colorSegment(I, minHSV, maxHSV)
   
    
   
    mask1 = I(:,:,1)>minHSV(1) & I(:,:,1)<maxHSV(1); 
    
    
    mask2 = I(:,:,2)>minHSV(2) & I(:,:,2)<maxHSV(2); 
    
    
    mask3 = I(:,:,3)>minHSV(3) & I(:,:,3)<maxHSV(3); 
    
    
    mask = mask1.*mask2.*mask3;
    

    return
end