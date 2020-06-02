tic
cd('./PanoBasic-master')
add_path; 
jsonpath = ('./imgs/Location/pre/M=DRIVING_S=600x300.json');
dir_ima_pre = ('./imgs/Location/pre/51.5008535,-0.122286/M=DRIVING_S=600x300-jpegs');
dir_ima_post = ('./imgs/Location/post/M=DRIVING_S=600x300-jpegs');
dir_semantic_mask = ('./imgs/Location/res');
dirGT_location = ('./imgs/Location/GT/PixelLabelData_1/Label_3.png');
dir_target_ima = ('./imgs/Location/post/M=DRIVING_S=600x300-jpegs/labelmaps/00005.csv');
dir_deeplab = ('./imgs/Location/deeplab');
imagestructure = jsondecode(fileread(jsonpath));
nlabels = 182;
nx = 600;
ny = 300;
target_heading = 0;%Heading = 0, pitch = 10 CHOOSE TARGET IMAGE
target_pitch = 10;
[interesting_imagefiles, interesting_images, target_ima_pos] = cleanup_database(target_heading, target_pitch, imagestructure, dir_ima_pre);
nimages = length(imagestructure.images);
ninteresting_images = length(interesting_images);
ninteresting_files = length(interesting_imagefiles);
[class_ima, score_class_ima, interesting_imagefiles] = coordinates(ninteresting_files,interesting_imagefiles, dir_ima_post, nlabels);
[bbox_target_ima, bbox_600_300,obj_ima] = reprojection(target_heading, target_pitch, interesting_images, imagestructure, ninteresting_files, nlabels, score_class_ima, class_ima);
[matrix_label_end_agregation_1, matrix_score_end_agregation_1, matrix_label_end_agregation_2, matrix_score_end_agregation_2, matrix_label_end_agregation_3, matrix_score_end_agregation_3] = agregation(nlabels, nx, ny, bbox_600_300);
[matrix_fin_print_1, matrix_fin_print_2, matrix_fin_print_3] = matrix2print(nlabels, matrix_label_end_agregation_1, matrix_label_end_agregation_2, matrix_label_end_agregation_3);
matrix_label_end_agregation_1(matrix_label_end_agregation_1 == -1) = 182;
imwrite(uint8(matrix_label_end_agregation_1'),strcat(dir_semantic_mask,'/mask_agregation1.png'))
matrix_label_end_agregation_2(matrix_label_end_agregation_2 == -1) = 182;
imwrite(uint8(matrix_label_end_agregation_2'),strcat(dir_semantic_mask,'/mask_agregation2.png'))
matrix_label_end_agregation_3(matrix_label_end_agregation_3 == -1) = 182;
imwrite(uint8(matrix_label_end_agregation_3'),strcat(dir_semantic_mask,'/mask_agregation3.png'))
print_mask(matrix_fin_print_1, matrix_fin_print_2, matrix_fin_print_3,nlabels, target_ima_pos, interesting_imagefiles);
[metrics_deeplab_vs_GT_location, metrics_agregacion_1_vs_GT_location, metrics_agregacion_2_vs_GT_location, metrics_agregacion_3_vs_GT_location] = metrics(dir_ima_post, dir_semantic_mask, dirGT_location, dir_deeplab);
