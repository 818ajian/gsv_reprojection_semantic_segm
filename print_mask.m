function print_mask(matrix_fin_print_1, matrix_fin_print_2, matrix_fin_print_3, nlabels, target_ima_pos, interesting_imagefiles)
fig1 = 1;
fig2 = 2;
fig3 = 3;
co1 = 0;
for ilabels=1:nlabels
    if isempty(matrix_fin_print_1{1,ilabels}) == 0
        co1 = co1 +1;
    end
end  
colormapcell_1 = cell(1,1);
colormapcell_1{1} = hsv(co1);
figure(fig1);
imshow(uint8(interesting_imagefiles(target_ima_pos).folder_name));
hold on
cv1 = 1;
for ilabels=1:nlabels
    if isempty(matrix_fin_print_1{1,ilabels}) == 0
       figure(fig1), scatter(matrix_fin_print_1{1,ilabels}(:,1),matrix_fin_print_1{1,ilabels}(:,2),[],[colormapcell_1{1}(cv1,1) colormapcell_1{1}(cv1,2) colormapcell_1{1}(cv1,3)],'filled','LineWidth', 0.2, 'MarkerFaceAlpha', 0.01); 
       cv1 = cv1 + 1;
    end
end
hold off;

co2 = 0;
for ilabels=1:nlabels
    if isempty(matrix_fin_print_2{1,ilabels}) == 0
        co2 = co2 +1;
    end
end  
colormapcell_2 = cell(1,1);
colormapcell_2{1} = hsv(co2);
figure(fig2);
imshow(uint8(interesting_imagefiles(target_ima_pos).folder_name));
hold on
cv2 = 1;
for ilabels=1:nlabels
    if isempty(matrix_fin_print_2{1,ilabels}) == 0
       figure(fig2), scatter(matrix_fin_print_2{1,ilabels}(:,1),matrix_fin_print_2{1,ilabels}(:,2),[],[colormapcell_2{1}(cv2,1) colormapcell_2{1}(cv2,2) colormapcell_2{1}(cv2,3)],'filled','LineWidth', 0.2, 'MarkerFaceAlpha', 0.01); 
       cv2 = cv2 + 1;
    end
end
hold off;
co3 = 0;
for ilabels=1:nlabels
    if isempty(matrix_fin_print_3{1,ilabels}) == 0
        co3 = co3 +1;
    end
end  
colormapcell_3 = cell(1,1);
colormapcell_3{1} = hsv(co3);
figure(fig3);
imshow(uint8(interesting_imagefiles(target_ima_pos).folder_name));
hold on
cv3 = 1;
for ilabels=1:nlabels
    if isempty(matrix_fin_print_3{1,ilabels}) == 0
       figure(fig3), scatter(matrix_fin_print_3{1,ilabels}(:,1),matrix_fin_print_3{1,ilabels}(:,2),[],[colormapcell_3{1}(cv3,1) colormapcell_3{1}(cv3,2) colormapcell_3{1}(cv3,3)],'filled','LineWidth', 0.2, 'MarkerFaceAlpha', 0.01); 
       cv3 = cv3 + 1;
    end
end
hold off;
end