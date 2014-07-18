if ax1 <= bx1 then  --pared
		banana.dir_x = dir_x
		banana.dir_y = dir_y
	elseif ax2 >= bx2 then
		banana.dir_x = -dir_x
		banana.dir_y = -dir_y
	elseif ay1 <= by1 then
		banana.dir_x = -dir_x
		banana.dir_y = dir_y
	elseif ay2 >= by2 then
		banana.dir_x = dir_x
		banana.dir_y = -dir_y
	end