function [matrix_label_end_agregation_1, matrix_score_end_agregation_1, matrix_label_end_agregation_2, matrix_score_end_agregation_2, matrix_label_end_agregation_3, matrix_score_end_agregation_3] = agregation(nlabels, nx, ny, bbox_600_300)
label_label_def = cell(1,nlabels);
label_score_def = cell(1,nlabels);
label_score_def_ag = cell(1,nlabels);
label_score = cell(1,nlabels);
for ilabels=1:nlabels
    label_score{1,ilabels} = vertcat(bbox_600_300{:,ilabels});
    if isempty(label_score{1,ilabels}) == 0
        [f,s] = size(label_score{1,ilabels});
            if ilabels == 1
                label_score{1,ilabels}  = [label_score{1,ilabels}  ((182)*ones(f,1))];
                label_score_def{1,ilabels} = accumarray([label_score{1,ilabels}(:,1),label_score{1,ilabels}(:,2)],label_score{1,ilabels}(:,3),[nx ny],@max);
                label_score_def_ag{1,ilabels} = accumarray([label_score{1,ilabels}(:,1),label_score{1,ilabels}(:,2)],label_score{1,ilabels}(:,3),[nx ny]);
                label_label_def{1,ilabels} = accumarray([label_score{1,ilabels}(:,1),label_score{1,ilabels}(:,2)],label_score{1,ilabels}(:,4),[nx ny], @max);
            else
            label_score{1,ilabels}  = [label_score{1,ilabels}  ((ilabels-1)*ones(f,1))];
            label_score_def{1,ilabels} = accumarray([label_score{1,ilabels}(:,1),label_score{1,ilabels}(:,2)],label_score{1,ilabels}(:,3),[nx ny],@max);
            label_score_def_ag{1,ilabels} = accumarray([label_score{1,ilabels}(:,1),label_score{1,ilabels}(:,2)],label_score{1,ilabels}(:,3),[nx ny]);
            label_label_def{1,ilabels} = accumarray([label_score{1,ilabels}(:,1),label_score{1,ilabels}(:,2)],label_score{1,ilabels}(:,4),[nx ny], @max);
            end
    end
end
clear ilabels iimages bbox_600_300_b bbox_600_300 label_score f s 
matrix_per_label_def = cell(1,nlabels);
matrix_score_per_label_def = cell(1,nlabels);
matrix_score_per_label_def_ag = cell(1,nlabels);
for k=1:nlabels
    matrix_per_label_def{1,k} = label_label_def{1,k}(:);
    matrix_score_per_label_def{1,k} = label_score_def{1,k}(:);
    matrix_score_per_label_def_ag{1,k} = label_score_def_ag{1,k}(:);
end
clear label_label_def label_score_def label_score_def_ags
%maximum point average agregation  and weighted maximum point average agregation 
an_label = [];
an_score = [];
an_label_ag = [];
an_score_ag = [];
count = 0;
an_cell_array = cell(nx,ny);
for pos=1:(nx*ny)
    an = [];
    an_agregation = [];
    for k=1:nlabels
        if isempty(matrix_per_label_def{1,k}) == 0
            if matrix_per_label_def{1,k}(pos) ~= 0
                an = [an; single(pos) (matrix_per_label_def{1,k}(pos)) matrix_score_per_label_def{1,k}(pos)];        
                an_agregation = [an_agregation; single(pos) (matrix_per_label_def{1,k}(pos)) matrix_score_per_label_def_ag{1,k}(pos)]; 
            end
        end
    end
    if isempty(an) == 0
        escore = accumarray(an(:,1),an(:,3),[],@max);
        [rowscore,colscore] = find(an==escore(end));
        [s,z] = size(rowscore);
        if (s > 1)
            rowscore = rowscore(1);
            colscore = colscore(1);
            count = count + 1;
        end
        an_label = [an_label; an(rowscore,(colscore-1))];
        an_score = [an_score; an(rowscore,colscore)];
        clear rowscore colscore an
    else 
        an_label = [an_label; NaN];
        an_score = [an_score; NaN];
    end
    if isempty(an_agregation) == 0
        an_cell_array{pos} = an_agregation;
        [max_sco,index] = max(accumarray(an_agregation(:,2),an_agregation(:,3)));
        an_label_ag = [an_label_ag; index];
        an_score_ag = [an_score_ag; max_sco];
        
        clear max_sco index an_agregation
    else
        an_agregation = [an_agregation; single(pos) 200 0];
        an_cell_array{pos} = an_agregation;
        an_label_ag = [an_label_ag; NaN];
        an_score_ag = [an_score_ag; NaN];
        clear an_agregation
    end
end
matrix_label_end_agregation_1 = reshape(an_label,[nx,ny]);
matrix_score_end_agregation_1 = reshape(an_score,[nx,ny]);
matrix_label_end_agregation_2 = reshape(an_label_ag,[nx,ny]);
matrix_score_end_agregation_2 = reshape(an_score_ag,[nx,ny]);

%weighted maximum local average agregation
an_res_label = zeros(nx,ny);
an_res_score = zeros(nx,ny);
sigma = 0.5;
for i=1:(nx*ny)
    [y,x] = ind2sub([nx ny],i);
    if (y == 1) && (x == 1)
        hsize = [3 3];
        h = fspecial('gaussian',hsize,sigma);
        h_new = h(2:3,2:3);
        minor_column = x; larger_column = x+1; minor_row = y; larger_row = y+1;
        auu = an_cell_array(minor_row:larger_row,minor_column:larger_column);
        a = [];
        for ii=1:2
            for j=1:2
                auu{ii,j}(:,3) = auu{ii,j}(:,3)*h_new(ii,j);
                a = [a; auu{ii,j}(:,2) auu{ii,j}(:,3)];
            end
        end
        accum_a = accumarray(a(:,1), a(:,2), [], @sum);
        [C,I] = max(accum_a);
        an_res_label(y,x) = I;
        an_res_score(y,x) = C;
    elseif (x == 1) && (y == nx)
        %y = nx; x = 1;
        hsize = [3 3];
        h = fspecial('gaussian',hsize,sigma);
        h_new = h(1:2,2:3);
        minor_column = x; larger_column = x+1; minor_row = y-1; larger_row = y;
        auu = an_cell_array(minor_row:larger_row,minor_column:larger_column);
        a = [];
        for ii=1:2
            for j=1:2
                auu{ii,j}(:,3) = auu{ii,j}(:,3)*h_new(ii,j);
                a = [a; auu{ii,j}(:,2) auu{ii,j}(:,3)];
            end
        end
        accum_a = accumarray(a(:,1), a(:,2), [], @sum);
        [C,I] = max(accum_a);
        an_res_label(y,x) = I;
        an_res_score(y,x) = C;
    elseif (x == ny) && (y == 1)
        %y = 1; x = ny;
        hsize = [3 3];
        h = fspecial('gaussian',hsize,sigma);
        h_new = h(2:3,1:2);
        minor_column = x-1; larger_column = x; minor_row = y; larger_row = y+1;
        auu = an_cell_array(minor_row:larger_row,minor_column:larger_column);
        a = [];
        for ii=1:2
            for j=1:2
                auu{ii,j}(:,3) = auu{ii,j}(:,3)*h_new(ii,j);
                a = [a; auu{ii,j}(:,2) auu{ii,j}(:,3)];
            end
        end
        accum_a = accumarray(a(:,1), a(:,2), [], @sum);
        [C,I] = max(accum_a);
        an_res_label(y,x) = I;
        an_res_score(y,x) = C;
    elseif (x == ny) && (y == nx)
        %y = nx; x = ny;
        hsize = [3 3];
        h = fspecial('gaussian',hsize,sigma);
        h_new = h(1:2,1:2);
        minor_column = x-1; larger_column = x; minor_row = y-1; larger_row = y;
        auu = an_cell_array(minor_row:larger_row,minor_column:larger_column);
        a = [];
        for ii=1:2
            for j=1:2
                auu{ii,j}(:,3) = auu{ii,j}(:,3)*h_new(ii,j);
                a = [a; auu{ii,j}(:,2) auu{ii,j}(:,3)];
            end
        end
        accum_a = accumarray(a(:,1), a(:,2), [], @sum);
        [C,I] = max(accum_a);
        an_res_label(y,x) = I;
        an_res_score(y,x) = C;
    elseif (x == 1)
        %y = 3; x = 1;
        hsize = [3 3];
        h = fspecial('gaussian',hsize,sigma);
        h_new = h(1:3,2:3);
        minor_column = x; larger_column = x+1; minor_row = y-1; larger_row = y+1;
        auu = an_cell_array(minor_row:larger_row,minor_column:larger_column);
        a = [];
        for ii=1:3
            for j=1:2
                auu{ii,j}(:,3) = auu{ii,j}(:,3)*h_new(ii,j);
                a = [a; auu{ii,j}(:,2) auu{ii,j}(:,3)];
            end
        end
        accum_a = accumarray(a(:,1), a(:,2), [], @sum);
        [C,I] = max(accum_a);
        an_res_label(y,x) = I;
        an_res_score(y,x) = C;
    elseif (y == 1)
        %x = 3; y = 1;
        hsize = [3 3];
        h = fspecial('gaussian',hsize,sigma);
        h_new = h(2:3,1:3);
        minor_column = x-1; larger_column = x+1; minor_row = y; larger_row = y+1;
        auu = an_cell_array(minor_row:larger_row,minor_column:larger_column);
        a = [];
        for ii=1:2
            for j=1:3
                auu{ii,j}(:,3) = auu{ii,j}(:,3)*h_new(ii,j);
                a = [a; auu{ii,j}(:,2) auu{ii,j}(:,3)];
            end
        end
        accum_a = accumarray(a(:,1), a(:,2), [], @sum);
        [C,I] = max(accum_a);
        an_res_label(y,x) = I;
        an_res_score(y,x) = C;
    elseif (y == nx)
        %y = nx; x = 3;
        hsize = [3 3];
        h = fspecial('gaussian',hsize,sigma);
        h_new = h(1:2,1:3);
        minor_column = x-1; larger_column = x+1; minor_row = y-1; larger_row = y;
        auu = an_cell_array(minor_row:larger_row,minor_column:larger_column);
        a = [];
        for ii=1:2
            for j=1:3
                auu{ii,j}(:,3) = auu{ii,j}(:,3)*h_new(ii,j);
                a = [a; auu{ii,j}(:,2) auu{ii,j}(:,3)];
            end
        end
        accum_a = accumarray(a(:,1), a(:,2), [], @sum);
        [C,I] = max(accum_a);
        an_res_label(y,x) = I;
        an_res_score(y,x) = C;
    elseif (x == ny)
        %y = 2; x = ny;
        hsize = [3 3];
        h = fspecial('gaussian',hsize,sigma);
        h_new = h(1:3,1:2);
        minor_column = x-1; larger_column = x; minor_row = y-1; larger_row = y+1;
        auu = an_cell_array(minor_row:larger_row,minor_column:larger_column);
        a = [];
        for ii=1:3
            for j=1:2
                auu{ii,j}(:,3) = auu{ii,j}(:,3)*h_new(ii,j);
                a = [a; auu{ii,j}(:,2) auu{ii,j}(:,3)];
            end
        end
        accum_a = accumarray(a(:,1), a(:,2), [], @sum);
        [C,I] = max(accum_a);
        an_res_label(y,x) = I;
        an_res_score(y,x) = C;
    else   
        hsize = [3 3];
        h = fspecial('gaussian',hsize,sigma);
        minor_column = x-1; larger_column = x+1; minor_row = y-1; larger_row = y+1;
        auu = an_cell_array(minor_row:larger_row,minor_column:larger_column);
        a = [];
        for ii=1:3
            for j=1:3
                auu{ii,j}(:,3) = auu{ii,j}(:,3)*h(ii,j);
                a = [a; auu{ii,j}(:,2) auu{ii,j}(:,3)];
            end
        end
        accum_a = accumarray(a(:,1), a(:,2), [], @sum);
        [C,I] = max(accum_a);
        an_res_label(y,x) = I;
        an_res_score(y,x) = C;
    end
    
end
matrix_label_end_agregation_3 = an_res_label;
matrix_score_end_agregation_3 = an_res_score;
clear matrix_per_label_def an_cell_array an_res_label an_res_score matrix_score_per_label_def matrix_score_per_label_def_ag an_label an_score an_label_ag an_score_ag
end