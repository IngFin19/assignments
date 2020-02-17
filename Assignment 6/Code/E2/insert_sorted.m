function [x,y] = insert_sorted(x,y,xq,yq)
    % perform the insertion of point xq in vector x, and the
    % corresponding yq in y s.t. the vectors are then
    % ordered by x values.
    % if xq is in x it should not be added
    %
    %INPUT
    %  _ x = where the function is defined (colum vector)
    %  _ y =  value of the function (colum vector)
    %  _ xq = values to add in x (colum vector)
    %  _ yq = values to add in y, correposonding to xq (colum vector)
    
    x = [x;xq];
    [x,idx] = unique(x);
    y = [y;yq];
    y = y(idx);
end

