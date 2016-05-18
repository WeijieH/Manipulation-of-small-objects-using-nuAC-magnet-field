videoSource = vision.VideoFileReader('02mgml_5Hz_100fps_processed.avi','ImageColorSpace','Intensity','VideoOutputDataType','uint8');
foregroundDetector = vision.ForegroundDetector('NumGaussians', 2, 'NumTrainingFrames', 70, 'MinimumBackgroundRatio', 0.4);
blobAnalysis = vision.BlobAnalysis('CentroidOutputPort', false, 'AreaOutputPort', false, 'BoundingBoxOutputPort', true, 'MinimumBlobArea', 200, 'MaximumCount', 150);
se_r = strel('square', 10);
se = strel('square', 2);
Result_out=VideoWriter('02mgml_5Hz_100fps_processed_Result.avi','Motion JPEG AVI');
Mask_out= VideoWriter('02mgml_5Hz_100fps_processed_Foreground.avi','Motion JPEG AVI');
Result_out.FrameRate=20;
Mask_out.FrameRate=20;
open(Result_out);
open(Mask_out);
while ~isDone(videoSource)
    frame = step(videoSource); % read the next video frame
    foreground = step(foregroundDetector, frame);
    closedForeground = imclose(foreground,se);
    filteredForeground = imopen(closedForeground, se_r);
    bbox = step(blobAnalysis, filteredForeground);
    result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green');
    numCars = size(bbox, 1);
    result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, 'FontSize', 14);
    writeVideo(Mask_out,uint8(255*filteredForeground));
    writeVideo(Result_out,result);
end
release(videoSource);
close(Mask_out);
close(Result_out);