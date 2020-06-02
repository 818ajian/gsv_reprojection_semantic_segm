# gsv_reprojection_semantic_segm
Tests for the reprojection of semantic segmentation masks in Google Street View Images to check if the aggregation of redundant information improves direct semantic segmentation.

Google Street View images extracted via https://github.com/pcarballeira/gsv_database_creator_fork . In this repository the images can be found in the following path: gsv_reprojection_semantic_segm/imgs/Location/pre/51.5008535,-0.122286/M=DRIVING_S=600x300-jpegs

Semantic segmentation masks extracted via https://github.com/pcarballeira/gsv_semantic_segmentation . In this repository the masks, labelmaps and scoremaps can be found in the following path: gsv_reprojection_semantic_segm/imgs/Location/post/M=DRIVING_S=600x300-jpegs

# Requirements
- Matlab
# Set up
Download PanoBasic from https://github.com/yindaz/PanoBasic and copy everything inside this folder.
The code consists of a main script and functions that make the different phases of the process.
When everything is downloaded and in the right place, you just need to run main.m
# Results
The code returns the scoremap and labemap of the 3 aggregations.
It also returns the semantic masks as follows:
- Maximum point average agregation
![alt text](https://github.com/pcarballeira/gsv_reprojection_semantic_segm/blob/master/imgs/Location/tests/maximum_point_average_agregation.png)
- Weighted maximum point average agregation
![alt text](https://github.com/pcarballeira/gsv_reprojection_semantic_segm/blob/master/imgs/Location/tests/weighted_maximum_point_average_agregation.png)
- Weighted maximum local average agregation
![alt text](https://github.com/pcarballeira/gsv_reprojection_semantic_segm/blob/master/imgs/Location/tests/weighted_maximum_local_average_agregation.png)

Finally, it shows the metrics of each aggregation and direct segmentation against the ground truth.
