function [matrix_fin_print_1, matrix_fin_print_2, matrix_fin_print_3] = matrix2print(nlabels, matrix_label_end_agregation_1, matrix_label_end_agregation_2, matrix_label_end_agregation_3)
matrix_label_end_agregation_1(matrix_label_end_agregation_1 == 0) = NaN;
[f,s] = size(matrix_label_end_agregation_1);
matrix_fin_print_1 = cell(1,nlabels);
for j=1:s
    for i=1:f
        for ilabels=1:nlabels
            if ilabels == 1
                if matrix_label_end_agregation_1(i,j) == 182
                matrix_fin_print_1{1,ilabels} = [matrix_fin_print_1{1,ilabels} ; i j];
                end
            else
                if matrix_label_end_agregation_1(i,j) == (ilabels-1)
                    matrix_fin_print_1{1,ilabels} = [matrix_fin_print_1{1,ilabels} ; i j];
                end
            end
        end
    end
end
matrix_label_end_agregation_2(matrix_label_end_agregation_2 == 0) = NaN;
[f,s] = size(matrix_label_end_agregation_2);
matrix_fin_print_2 = cell(1,nlabels);
for j=1:s
    for i=1:f
        for ilabels=1:nlabels
            if ilabels == 1
                if matrix_label_end_agregation_2(i,j) == 182
                matrix_fin_print_2{1,ilabels} = [matrix_fin_print_2{1,ilabels} ; i j];
                end
            else
                if matrix_label_end_agregation_2(i,j) == (ilabels-1)
                    matrix_fin_print_2{1,ilabels} = [matrix_fin_print_2{1,ilabels} ; i j];
                end
            end
        end
    end
end
matrix_label_end_agregation_3(matrix_label_end_agregation_3 == 0) = NaN;
[f,s] = size(matrix_label_end_agregation_3);
matrix_fin_print_3 = cell(1,nlabels);
for j=1:s
    for i=1:f
        for ilabels=1:nlabels
            if ilabels == 1
                if matrix_label_end_agregation_3(i,j) == 182
                matrix_fin_print_3{1,ilabels} = [matrix_fin_print_3{1,ilabels} ; i j];
                end
            else
                if matrix_label_end_agregation_3(i,j) == (ilabels-1)
                    matrix_fin_print_3{1,ilabels} = [matrix_fin_print_3{1,ilabels} ; i j];
                end
            end
        end
    end
end
end