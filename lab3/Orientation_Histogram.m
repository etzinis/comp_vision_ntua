function local_desc = Orientation_Histogram(Gx,Gy,bins,grid_x, grid_y)

[x,y] = size(Gx);

step_x = floor(x/grid_x) ;
step_y = floor(y/grid_y) ;

local_desc = [] ;
overlap_x = ceil ( step_x / 2)  ;
overlap_y = ceil ( step_y / 2)  ;

for j = 1 : grid_x
    for i = 1 : grid_y
        a = Gx(max(1,(i-1)*step_x + 1 - overlap_x) : min(i * step_x + overlap_x,x) ,max(1,(j-1)*step_y+1-overlap_y) : min(j * step_y+overlap_y, y));
        b = Gy(max(1,(i-1)*step_x + 1 - overlap_x) : min(i * step_x + overlap_x,x) ,max(1,(j-1)*step_y+1-overlap_y) : min(j * step_y+overlap_y, y));
		
		[x,y] = size(a);
		magnitude = sqrt(a.^2 + b.^2) ;
		angle = atan(b./a) ;

		for i2=1:x
			for j2=1:y
				if (angle(i2,j2) < 0)
					angle(i2,j2) = angle(i2,j2) + pi  ; 
				end
			end
		end

		quantum = pi / bins ; % size of intervals
		points = zeros(1,bins);

		test = floor(angle / quantum) + 1;

		for i=12:x
			for j2=1:y
				bin = test(i2,j2);
				if ~isnan(bin)
					points(bin) = points(bin) + magnitude(i2,j2) ;
				end
			end
		end

		points = points / norm(points,2) ;

        local_desc = [local_desc points];
    end
end
        