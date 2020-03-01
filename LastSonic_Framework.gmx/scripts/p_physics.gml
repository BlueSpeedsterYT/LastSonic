//limits
if hsp > hspl hsp = hspl;
if hsp<-hspl hsp = -hspl;
if vsp>vspl vsp = vspl;
if vsp<-vspl vsp=-vspl;

//h movemnt

if hsp >0
{
    for(i=0; i<hsp && !collision_circle(x+16,y,3,obj_walls,true,true) ;i+=1)
    {
        x+=1;
    }
}

if hsp<0
{
   for(i=0;i>hsp && !collision_circle(x-16,y,3,obj_walls,true,true);i-=1)
   {
      x-=1;
   }
}

//v motion

if vsp>0
{
   for(i=0;i<vsp &&!collision_circle(x,y+16,3,obj_walls,true,true);i+=1)
   {
      y+=1;
   }
}

if vsp<0
{
   for(i=0;i>vsp && !collision_circle(x,y-16,3,obj_walls,true,true);i-=1;)
   {
      y-=1;
   }
}

///wall collision

while(collision_circle(x+16,y,3,obj_walls,true,true))
{
   x-=1;
}

while(collision_circle(x-16,y,3,obj_walls,true,true))
{
   x+=1;
}

///landing.

if vsp>=0 && !ground && collision_circle(x,y+16,4,obj_walls,true,true)
{
   vsp=0;
   ground = true;
}

/// leave ground

if !collision_circle(x,y+16,4,obj_walls,true,true) && ground{
   ground = false;
}

///gravity

if !ground vsp+=grv;
