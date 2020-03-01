//limts
if(hsp>hspl) hsp = hspl;
if(hsp<-hspl) hsp =-hspl;
if(vsp>vspl) vsp =vspl;

///h movment
if hsp>0
{
    for(i=0; i<hsp && !collision_script_right(16);i+=1)
    {
        x+=acos;
        y-=asin;    
    }
}
if hsp<0
{
    for(i=0;i>hsp && !collision_script_left(16);i-=1)
    {
        x-=acos;
        y+=asin;
    }
}
//v movment
if vsp>0
{
    for(i=0;i<vsp &&!collision_script_bottom(16);i+=1)
    {
        y+=1;
    }
}

if vsp<0
{
    for(i=0;i>vsp && !collision_script_top(16);i-=1;)
    {
        y-=1;
    }
}

///landing
if vsp>=0 && !ground && collision_script_bottom(16) && (collision_script_left_line(16) || collision_script_right_line(16))
{
    angle = find_angle(angle,16,16);
    acos = cos(degtorad(angle));
    asin = sin(degtorad(angle));
    
    hsp -= (asin*vsp*2);
    vsp = 0;
    ground = true;
}


///lock to ground
if ground
{
    while (collision_script_main(16))
    {
        x-=asin;
        y-=acos;
    }

    while (!collision_script_main(16) && collision_script_ground(16))
    {
        x+=asin; 
        y+=acos;
    }

    var collide_offset;
    collide_offset = 16
    var collide_check_condition;
    collide_check_condition = !collision_point(x+collide_offset*asin,y+collide_offset*acos,obj_walls,true,true) || (!collision_point(x+collide_offset*asin,y+collide_offset*acos,obj_bwalls,true,true) && xlayer = 0) || (!collision_point(x+collide_offset*asin,y+collide_offset*acos,obj_fwalls,true,true) && xlayer = 1) || (!collision_point(x+collide_offset*asin,y+collide_offset*acos,obj_rail,true,true) && canGrind = true)
    
    if (collide_check_condition)
    {
        x += asin
        y += acos
    }
    else
    {
        x -= asin
        y -= acos
    }
    
}

//leave ground
if (!collision_script_left_line(16) || !collision_script_right_line(16)) && !collision_script_bottom(16) && ground  && !collision_line(x,y,x+20*asin,y+20*acos,obj_walls,true,true)// &&!collision_point(x+18*asin,y+18*acos,obj_walls,true,true)
{   
    ground = false;
    vsp = -asin*hsp;
    hsp = acos*hsp; 
    
    angle = 0;
    asin = 0
    acos = 1    
}


//wall collision
while(collision_script_right(16))
{
    x-=acos;
    y+=asin;
    hsp = 0
}
while(collision_script_left(16))
{
    x+=acos;
    y-=asin;
    hsp = 0
}



//gravity
if !ground 
    vsp += grv;

///angle speed
if angle > 70 && angle < 290 && abs(hsp) < 1.5 && action != 11
{
    x -= asin*5
    y -= acos*5
    angle = 0;
    vsp = -(asin*hsp)//+acos*hsp;
    hsp = (acos*hsp)//-asin*hsp;
    ground = false;
}

///slope factor
if action = 0 slp =0.125;
if action = 2 {if sign(hsp) = sign(asin) slp=0.078125; if sign(hsp) != sign(asin) slp =0.3125;}
if (action >=0 && hsp < hspm) hsp-=slp*asin;

if ground && (collision_script_left_line(16) && collision_script_right_line(16))
{
    angle = find_angle(angle,16,25);
}

/*if collision_script_top(16) && !ground 
{
    vsp = 0
}
*/
if !ground && collision_script_top(16) && vsp < 0
{

    var check_angle;
    check_angle = find_angle(180,16,25)
    if (check_angle >= 135 && check_angle <= 170)
    {
        action = 0
        angle = check_angle
        hsp = -vsp
        vsp = 0
    }
    else if (check_angle >= 190 && check_angle <= 225)
    {
        action = 0
        angle = check_angle
        hsp = vsp
        vsp = 0
    }
    else
    {
        vsp = 0
        angle = 0
    }
}


acos = cos(degtorad(angle));
asin = sin(degtorad(angle));
