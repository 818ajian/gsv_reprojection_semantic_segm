function  [metrics_deeplab_vs_GT_location, metrics_agregacion_1_vs_GT_location, metrics_agregacion_2_vs_GT_location, metrics_agregacion_3_vs_GT_location] = metrics(dir_ima_post, dir_semantic_mask, dirGT_location, dir_deeplab)
classes = string({'bicycle';'car';'motorcycle';'airplane';'bus';'train';'truck';'boat';'traffic_light';'fire_hydrant';'street_sign';'stop_sign';'parking_meter';'bench';'bird';'cat';'dog';'horse';'sheep';'cow';'elephant';'bear';'zebra';'giraffe';'hat';'backpack';'umbrella';'shoe';'eye_glasses';'handbag';'tie';'suitcase';'frisbee';'skis';'snowboard';'sports_ball';'kite';'baseball_bat';'baseball_glove';'skateboard';'surfboard';'tennis_racket';'bottle';'plate';'wine_glass';'cup';'fork';'knife';'spoon';'bowl';'banana';'apple';'sandwich';'orange';'broccoli';'carrot';'hot_dog';'pizza';'donut';'cake';'chair';'couch';'potted_plant';'bed';'mirror';'dining_table';'window';'desk';'toilet';'door';'tv';'laptop';'mouse';'remote';'keyboard';'cell_phone';'microwave';'oven';'toaster';'sink';'refrigerator';'blender';'book';'clock';'vase';'scissors';'teddy_bear';'hair_drier';'toothbrush';'hair_brush';'banner';'blanket';'branch';'bridge';'building_other';'bush';'cabinet';'cage';'cardboard';'carpet';'celing_other';'ceiling_tile';'cloth';'clothes';'clouds';'counter';'cupboard';'curtain';'desk_stuff';'dirt';'door_stuff';'fence';'floor_marble';'floor_other';'floor_stone';'floor_tile';'floor_wood';'flower';'fog';'food_other';'fruit';'furniture_other';'grass';'gravel';'ground_other';'hill';'house';'leaves';'light';'mat';'metal';'mirror_stuff';'moss';'mountain';'mud';'napkin';'net';'paper';'pavement';'pillow';'plant_other';'plastic';'platform';'playingfield';'railing';'railroad';'river';'road';'rock';'roof';'rug';'salad';'sand';'sea';'shelf';'sky_other';'skyscraper';'snow';'solid_other';'stairs';'stone';'straw';'structural_other';'table';'tent';'textile_other';'towel';'tree';'vegetable';'wall_brick';'wall_concrete';'wall_other';'wall_panel';'wall_stone';'wall_tile';'wall_wood';'water_other';'waterdrops';'window_blind';'window_other';'wood';'person'}');
pixel_id = [1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27;28;29;30;31;32;33;34;35;36;37;38;39;40;41;42;43;44;45;46;47;48;49;50;51;52;53;54;55;56;57;58;59;60;61;62;63;64;65;66;67;68;69;70;71;72;73;74;75;76;77;78;79;80;81;82;83;84;85;86;87;88;89;90;91;92;93;94;95;96;97;98;99;100;101;102;103;104;105;106;107;108;109;110;111;112;113;114;115;116;117;118;119;120;121;122;123;124;125;126;127;128;129;130;131;132;133;134;135;136;137;138;139;140;141;142;143;144;145;146;147;148;149;150;151;152;153;154;155;156;157;158;159;160;161;162;163;164;165;166;167;168;169;170;171;172;173;174;175;176;177;178;179;180;181;182]';

deeplab_location = csvread(dir_target_ima);
deeplab_location(deeplab_location == 0) = 182;
imwrite(uint8(deeplab_location),strcat(dir_deeplab,'/deeplab_location.png'));
pixelLabelDatastore_GT_location = pixelLabelDatastore(dirGT_location, classes, pixel_id);
pixelLabelDatastore_deeplab_location = pixelLabelDatastore(strcat(dir_deeplab,'/deeplab_location.png'), classes, pixel_id);
pixelLabelDatastore_agregation_1_location = pixelLabelDatastore(strcat(dir_semantic_mask,'/mask_agregation1.png'), classes, pixel_id);
pixelLabelDatastore_agregation_2_location = pixelLabelDatastore(strcat(dir_semantic_mask,'/mask_agregation2.png'), classes, pixel_id);
pixelLabelDatastore_agregation_3_location = pixelLabelDatastore(strcat(dir_semantic_mask,'/mask_agregation3.png'), classes, pixel_id);
%deeplab vs GT
metrics_deeplab_vs_GT_location= evaluateSemanticSegmentation(pixelLabelDatastore_deeplab_location, pixelLabelDatastore_GT_location);
%agregation vs GT
metrics_agregacion_1_vs_GT_location = evaluateSemanticSegmentation(pixelLabelDatastore_agregation_1_location, pixelLabelDatastore_GT_location);
metrics_agregacion_2_vs_GT_location = evaluateSemanticSegmentation(pixelLabelDatastore_agregation_2_location, pixelLabelDatastore_GT_location);
metrics_agregacion_3_vs_GT_location = evaluateSemanticSegmentation(pixelLabelDatastore_agregation_3_location, pixelLabelDatastore_GT_location);

Table_location = vertcat(metrics_deeplab_vs_GT_location.ImageMetrics,metrics_agregacion_1_vs_GT_location.ImageMetrics, metrics_agregacion_2_vs_GT_location.ImageMetrics, metrics_agregacion_3_vs_GT_location.ImageMetrics);
count_location = countEachLabel(pixelLabelDatastore_GT_location);

Accuracy_location = horzcat((1:1:182)', metrics_deeplab_vs_GT_location.ClassMetrics{:,:}(:,1),metrics_agregacion_1_vs_GT_location.ClassMetrics{:,:}(:,1), metrics_agregacion_2_vs_GT_location.ClassMetrics{:,:}(:,1), metrics_agregacion_3_vs_GT_location.ClassMetrics{:,:}(:,1)) ;
IoU_location = horzcat((1:1:182)',metrics_deeplab_vs_GT_location.ClassMetrics{:,:}(:,2),metrics_agregacion_1_vs_GT_location.ClassMetrics{:,:}(:,2), metrics_agregacion_2_vs_GT_location.ClassMetrics{:,:}(:,2), metrics_agregacion_3_vs_GT_location.ClassMetrics{:,:}(:,2)) ;
BFScore_location = horzcat((1:1:182)',metrics_deeplab_vs_GT_location.ClassMetrics{:,:}(:,3),metrics_agregacion_1_vs_GT_location.ClassMetrics{:,:}(:,3), metrics_agregacion_2_vs_GT_location.ClassMetrics{:,:}(:,3), metrics_agregacion_3_vs_GT_location.ClassMetrics{:,:}(:,3)) ;

end
