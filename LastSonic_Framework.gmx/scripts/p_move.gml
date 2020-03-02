//controls
key_u = keyboard_check(vk_up)  || gamepad_button_check(0,gp_padu);
key_l = keyboard_check(vk_left)  || gamepad_button_check(0,gp_padl);
key_r = keyboard_check(vk_right) || gamepad_button_check(0,gp_padr);
key_d = keyboard_check(vk_down)  || gamepad_button_check(0,gp_padd);
key_a = keyboard_check_pressed(ord('X'))  || gamepad_button_check_pressed(0,gp_face1);
key_ar = keyboard_check_released(ord('X'))  || gamepad_button_check_released(0,gp_face1);
key_b = keyboard_check_pressed(ord('C'))  || gamepad_button_check_pressed(0,gp_face2);
key_x = keyboard_check_pressed(ord('Z')) || gamepad_button_check_pressed(0,gp_face3)
key_y = keyboard_check_pressed(ord('S')) || gamepad_button_check_pressed(0,gp_face4)

//direction
if action = 0
{
    if key_l xdir = -1;
    if key_r xdir =  1;
}

//player movement

if (action=0||action=1)
{
    if ground{
        if key_r
        {if hsp >=0 {if hsp< hspm hsp+=acc} else hsp+=dcc;}
        if key_l
        {if hsp<=0 {if hsp > -hspm hsp-=acc} else hsp-=dcc;}
        if !key_r && !key_l
        {if hsp > 0 hsp-=frc; if hsp<0 hsp+=frc;if hsp <= frc && hsp >= -frc hsp=0;}
    }
    else
    {
        if key_r
        {if hsp >=0 {if hsp< hspm hsp+=acc*2}}
        if key_l
        {if hsp<=0 {if hsp > -hspm hsp-=acc*2}}
        if !key_r && !key_l
        {if hsp > 0 hsp-=frc; if hsp<0 hsp+=frc;if hsp <= frc && hsp >= -frc hsp=0;}
    }
}
if action =2
{
    if ground{
        if hsp > bfr {hsp-=bfr;if key_l hsp-=bdcc}
        if hsp <-bfr {hsp+=bfr;if key_r hsp+=bdcc}
        if hsp < bfr && hsp > -bfr hsp=0;
    }
    else
    {
        if key_r
        {if hsp >=0 {if hsp< hspm hsp+=acc*2}}
        if key_l
        {if hsp<=0 {if hsp > -hspm hsp-=acc*2}}
    }
}


//jumping

if key_a && ground && (action = 0 || action = 2)
{
    ground =0;
    vsp= acos*jmp;
    hsp=hsp*acos + asin*jmp;
    angle = 0;
    acos=1;
    asin=0;
    action=1;
}

///smal jump

if key_ar && vsp<sjmp && action =1
{
    vsp =sjmp;
}

//air drag

if vsp<0 && vsp>-4
{
    if abs(hsp) >=0.125 {hsp=hsp*adrag};
}

//stomp

if (action == 0 || action == 1) && !ground && key_b
{
    action = 4
}
if action == 4
{
   vsp = vspl;
   hsp = 0;
   
   if ground
   {
    vibrate_xbox_controller(30)
    shake_camera(15)
    vsp = 0;
    action = 0
   }
}

//landing

if ground && (action = 1)
{action = 0;}

///rolling ducking

if key_d && ground && action = 0
{
    if abs(hsp) < 1.03125 {hsp=0; action = -1;}
    if abs(hsp) >= 1.03125 {action = 2;}   
}
if action=-1 &&!key_d {action=0;}///un duck
if action = 2 && abs(hsp) <0.5 && ground {action =0;}///un roll
if action =2 && vsp>0 && !ground && collision_script_ground(14)//un roll on ground
{action = 0;}
 
///looking up

if key_u && ground && action =0
{
    if abs(hsp) < 0.2 {hsp =0;action =-3};
}
if (!key_u||!ground||key_r||key_l)&&action=-3 action=0;

///dash

if (xdir = -1 && key_x && (action = 0 || action = 1 || action = 2)) {
    action = 3;
    if action = 3
    {
    hsp -= 4;
    action = 0;
    }
    else if action = 3 && action = 1
    {
    hsp -= 4;
    vsp = 0;
    action = 0;
    }
}

if (xdir = 1 && key_x && (action = 0 || action = 1 || action = 2)) {
    action = 3;
    if action = 3
    {
    hsp += 4;
    action = 0;
    }
    else if action = 3 && action = 1
    {
    hsp += 4;
    vsp = 0;
    ground = 0;
    action = 0;
    }
}

///spin dash

if sp > 0 {sp = sp-((sp div 1)/265)}
if sp > 192 sp = 192;
if action = -2 && key_a {sp+=8;}
if action = -2 && !key_d {hsp = xdir*9+(xdir*floor(sp)/8);action = 2; sp =0;}
if action =-1 && key_a 
{
    sp = 0;
    action = -2; 
}
