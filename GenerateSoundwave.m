function [ ud_sound, lr_sound ] = GenerateSoundwave( imagedata, stepsize, frequency )
    if nargin < 3
        frequency = 10;
    end
    if nargin < 2
        stepsize = 0.3;
    end
    % load data image
    data = imread(imagedata);
    
    % duration in seconds
    duration = stepsize * nnz(data);
    fs = 8192;
    t = 0:1/fs:duration;
    mask = sin(2*pi*frequency*t);
    % left channel to push down (coil on top)
    ud_sound(:,1)=mask;
    % right channel to push up (coil on bottom)
    ud_sound(:,2)=mask;
    % left channto to push right (coil on left)
    % right channel to push left (coil on right)
    lr_sound = ud_sound;

   
    current_time = 0;
    [current_y, current_x] = find(data==127);
    last_y = current_y;
    last_x = current_x;
    [step, new_x, new_y] = march(current_x, current_y, last_x, last_y, data);
    renew()
    while (step)
        data(current_y,current_x) = 200;
        ix1 = time2index(current_time, fs);
        current_time = current_time + stepsize;
        ix2 = time2index(current_time, fs);
        switch step
            case 1  
                %go right
                ud_sound(ix1:ix2,:) = 0;
                lr_sound(ix1:ix2,2) = 0;
            case 2
                %go left
                ud_sound(ix1:ix2,:) = 0;
                lr_sound(ix1:ix2,1) = 0;
            case 3
                %go down
                ud_sound(ix1:ix2,2) = 0;
                lr_sound(ix1:ix2,:) = 0;
            otherwise
                % go up
                ud_sound(ix1:ix2,1) = 0;
                lr_sound(ix1:ix2,:) = 0;
        end        
        [step, new_x, new_y] = march(current_x, current_y, last_x, last_y, data);
        renew()
    end
    % trim sound
    ix = time2index(current_time, fs);
    ud_sound(ix+1:end,:) = [];
    lr_sound(ix+1:end,:) = [];
    % show path
    figure
    imagesc(data)
    
    function renew()
        last_x = current_x;
        last_y = current_y;
        current_x = new_x;
        current_y = new_y;
    end
end

function [step, new_x, new_y] = march(x, y, last_x, last_y, data)
    step = 0;
    new_x = x;
    new_y = y;
    % Move right
    if (255 == data(y, x+1) && (x+1)~= last_x)
        step = 1;
        new_x = x + 1;
        return
    end
    % Move left
    if (255 == data(y, x-1) && (x-1)~= last_x)
        step = 2;
        new_x = x - 1;
        return
    end
    % Move down
    if (255 == data(y+1, x) && (y+1)~= last_y)
        step = 3;
        new_y = y + 1;
        return
    end
    % Move up
    if (255 == data(y-1, x) && (y-1)~= last_y)
        step = 4;
        new_y = y - 1;
        return
    end    
end

function index = time2index(time, fs)
    index = round(time * fs + 1);
end