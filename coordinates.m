function [class_ima, score_class_ima, interesting_imagefiles] = coordinates(ninteresting_files,interesting_imagefiles, dir_ima_post, nlabels)
sco = cell(1,ninteresting_files);
lab = cell(1,ninteresting_files);
for ii=1:ninteresting_files
   interesting_imagefiles(ii).folder_name = double(imread(strcat(interesting_imagefiles(ii).folder,'/',interesting_imagefiles(ii).name)));
   lab{1,ii} = uint8(csvread(sprintf(strcat(dir_ima_post,'/labelmaps/%s.csv'),erase(interesting_imagefiles(ii).name,'.jpg'))));
   sco{1,ii} = single(csvread(sprintf(strcat(dir_ima_post,'/scores/%s.csv'),erase(interesting_imagefiles(ii).name,'.jpg'))));
end

clear imagefiles
[f,s] = size(lab{1,1});
score_class_ima = cell(ninteresting_files,nlabels);
class_ima = cell(ninteresting_files,nlabels);
for iimages=1:ninteresting_files
    for ilabels=1:nlabels
        for j=1:s
            for i=1:f
                if lab{1,iimages}(i,j) == (ilabels-1)
                    class_ima{iimages,ilabels} = uint16([class_ima{iimages,ilabels} ; j i]);
                    score_class_ima{iimages,ilabels} = single([score_class_ima{iimages,ilabels} ; sco{1,iimages}(i,j)]);
                end
            end
        end
    end       
end

    
end