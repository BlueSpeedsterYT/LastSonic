mask = argument0;
 
if collision_circle(x-asin*(mask*1.5),y+acos*(mask*1.5),3,obj_walls,true,true) return true;
if xlayer = 0 && collision_circle(x-asin*(mask*1.5),y+acos*(mask*1.5),3,obj_bwalls,true,true) return true;
if xlayer = 1 && collision_circle(x-asin*(mask*1.5),y+acos*(mask*1.5),3,obj_fwalls,true,true) return true;
return false;
