function [interesting_imagefiles, interesting_images, target_ima_pos]= cleanup_database(target_heading, target_pitch, imagestructure, dir_ima_pre)
target_heading_pitch = [imagestructure.images.heading; imagestructure.images.pitch];
target_ima_pos = find(target_heading_pitch(1,:) == target_heading & target_heading_pitch(2,:) == target_pitch);
if isempty(target_ima_pos) == 1
    fprintf('Target heading and pitch not found\n');
else
%heading_obj = imagestructure.images(target_ima_pos).heading;
heading_obj_max = target_heading + 90;
flag_heading_obj_max = 0;
if (heading_obj_max > 360)
    heading_obj_max = heading_obj_max - 360;
    flag_heading_obj_max = 1;
end
heading_obj_min = target_heading - 90;
flag_heading_obj_min = 0;
if (heading_obj_min < 0)
    heading_obj_min = 360 + heading_obj_min ;
    flag_heading_obj_min = 1;
end
allCN = [imagestructure.images.heading]; 
if (isempty(find(allCN == heading_obj_max, 1)) == 1) && (isempty(find(allCN == heading_obj_min, 1)) == 1)
    distmin = abs(allCN-heading_obj_min);
    distmax = abs(allCN-heading_obj_max);
    minDistmin = min(distmin);
    minDistmax = min(distmax);
    idxmin = find(distmin == minDistmin);
    idxmax = find(distmax == minDistmax);
    [fidxmin, sidxmin] = size(idxmin);
    [fidxmax, sidxmax] = size(idxmax);
    idxmin_post = idxmin(1:sidxmin/2);
    idxmax_post = idxmax(1+sidxmax/2:sidxmax);
    [fidxmin_post, sidxmin_post] = size(idxmin_post);
    [fidxmax_post, sidxmax_post] = size(idxmax_post);
    if (flag_heading_obj_min == 1) || (flag_heading_obj_max == 1)
        interesting_images = [imagestructure.images(1:idxmax_post(end)); imagestructure.images((idxmin_post(1)):(end))];
    else
        interesting_images = imagestructure.images((idxmin_post(1)):idxmax_post(end));
    end
else
    distmin = abs(allCN-heading_obj_min);
    distmax = abs(allCN-heading_obj_max);
    minDistmin = min(distmin);
    minDistmax = min(distmax);
    idxmin_post = find(distmin == minDistmin);
    idxmax_post = find(distmax == minDistmax);
    if (flag_heading_obj_min == 1) || (flag_heading_obj_max == 1)
        interesting_images = [imagestructure.images(1:idxmax_post(end)); imagestructure.images((idxmin_post(1)):(end))];  
    else
        interesting_images = imagestructure.images((idxmin_post(1)):idxmax_post(end));
    end
end
imagefiles = dir(strcat(dir_ima_pre,'/*.jpg'));
if (flag_heading_obj_min == 1) || (flag_heading_obj_max == 1)
    interesting_imagefiles = [struct('name', {imagefiles(1:idxmax_post(end)).name}, 'folder', {imagefiles(1:idxmax_post(end)).folder}),struct('name', {imagefiles(idxmin_post(1):end).name}, 'folder', {imagefiles(idxmin_post(1):end).folder})];
else
    interesting_imagefiles = struct('name', {imagefiles(((interesting_images(1).seqNumber)+1):((interesting_images(end).seqNumber)+1)).name}, 'folder', {imagefiles(((interesting_images(1).seqNumber)+1):((interesting_images(end).seqNumber)+1)).folder});
end

interesting_imagefiles(1).folder_name = [];
% target_pitch_max = target_pitch + 20;
% target_pitch_min = target_pitch - 20;
% idx = [interesting_images(:).pitch]>target_pitch_max;
% interesting_images = interesting_images(~idx);
% interesting_imagefiles = interesting_imagefiles(~idx);
% idx = [interesting_images(:).pitch]<target_pitch_min;
% interesting_images = interesting_images(~idx);
% interesting_imagefiles = interesting_imagefiles(~idx);
end