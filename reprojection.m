function [bbox_target_ima, bbox_600_300,obj_ima] = reprojection(target_heading, target_pitch, interesting_images, imagestructure, ninteresting_files, nlabels, score_class_ima, class_ima)
pano_resolution_factor = round(360/90);
sphereW = imagestructure.width * pano_resolution_factor; 
sphereH = sphereW/2;
if target_heading == 360
    target_heading = 0;
end
new_target_heading_pitch = [interesting_images.heading; interesting_images.pitch];
obj_ima = find(new_target_heading_pitch(1,:) == target_heading & new_target_heading_pitch(2,:) == target_pitch);
xyz_obj = single(uv2xyzN([((interesting_images(obj_ima).heading/360)*2*pi),((interesting_images(obj_ima).pitch/360)*2*pi)]));
colormapcell = cell(1,1);
colormapcell{1} = hsv(nlabels);
bbox_target_ima = cell(ninteresting_files,nlabels);
for iimages=1:ninteresting_files
    for ilabels=1:nlabels
        if isempty(class_ima{iimages,ilabels}) == 0
           imHoriFOV_rad = ([interesting_images(iimages).fov]/360)*2*pi;
           [xyz] = single(uv2xyzN([((interesting_images(iimages).heading/360)*2*pi),((interesting_images(iimages).pitch/360)*2*pi)]));
           [bbox_xyz,out3DPlane] = projectPointFromSeparateView(single(class_ima{iimages,ilabels}),xyz, single(imHoriFOV_rad), single(imagestructure.width), single(imagestructure.height));
           [bbox_uv] = xyz2uvN( bbox_xyz);
           [bbox_coords_pano] = uv2coords(bbox_uv, sphereW, sphereH);
           [bbox_uv] = coords2uv(bbox_coords_pano, sphereW, sphereH);
           [bbox_targetima, valid, division] = projectPoint2SeparateView(bbox_xyz, xyz_obj, single(imHoriFOV_rad), single(imagestructure.width), single(imagestructure.height));
           bbox_target_ima{iimages,ilabels}= [bbox_targetima score_class_ima{iimages,ilabels}];
        end
    end
end
clear out3DPlane bbox_xyz xyz sphereH sphereW valid division class_ima imagestructure xyz_obj imHoriFOV_rad bbox_targetima score_class_ima
bbox_600_300 = cell(ninteresting_files,nlabels);
bbox_600_300_b = cell(ninteresting_files,nlabels);
for iimages=1:ninteresting_files
    for ilabels=1:nlabels
        for i=1:size(bbox_target_ima{iimages,ilabels})
                if (bbox_target_ima{iimages,ilabels}(i,1) > 1 && bbox_target_ima{iimages,ilabels}(i,1) <= 600 && bbox_target_ima{iimages,ilabels}(i,2) > 1 && bbox_target_ima{iimages,ilabels}(i,2) <= 300)
                    bbox_600_300{iimages,ilabels} = [bbox_600_300{iimages,ilabels} ; round(bbox_target_ima{iimages,ilabels}(i,1)) round(bbox_target_ima{iimages,ilabels}(i,2)) bbox_target_ima{iimages,ilabels}(i,3)];                   
                end
        end
        if isempty(bbox_600_300{iimages,ilabels}) == 0
             B2 = accumarray([bbox_600_300{iimages,ilabels}(:,1),bbox_600_300{iimages,ilabels}(:,2)],bbox_600_300{iimages,ilabels}(:,3),[],@max);
            [B2f, B2s] = size(B2);B1 = find(B2);[b1row,b1col] = ind2sub([B2f B2s],B1);
            bbox_600_300_b{iimages,ilabels} = [b1row, b1col,B2(B1)];
        end
    end
end
clear ilabels iimages i bbox_target_ima_b B2 i B2f B2s B1 b1row b1col 
end