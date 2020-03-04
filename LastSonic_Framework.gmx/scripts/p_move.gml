//controls
key_u = keyboard_check(vk_up) || gamepad_axis_value(0,gp_axislv)<0  || gamepad_button_check(0,gp_padu);
key_l = keyboard_check(vk_left) || gamepad_axis_value(0,gp_axislh)<0  || gamepad_button_check(0,gp_padl);
key_r = keyboard_check(vk_right) || gamepad_axis_value(0,gp_axislh)>0 || gamepad_button_check(0,gp_padr);
key_d = keyboard_check(vk_down)  || gamepad_axis_value(0,gp_axislv)>0 || gamepad_button_check(0,gp_padd);
key_a = keyboard_check_pressed(ord('Z'))  || gamepad_button_check_pressed(0,gp_face1);
key_ar = keyboard_check_released(ord('Z'))  || gamepad_button_check_released(0,gp_face1);
key_b = keyboard_check_pressed(ord('C'))  || gamepad_button_check_pressed(0,gp_face2);
key_x = keyboard_check_pressed(ord('X')) || gamepad_button_check_pressed(0,gp_face3);
key_y = keyboard_check_pressed(ord('S')) || gamepad_button_check_pressed(0,gp_face4);
//key_rb = keyboard_check_pressed(ord('D')) || gamepad_button_check_pressed(0,gp_shoulderrb);
key_start = keyboard_check_pressed(vk_enter) || gamepad_button_check_pressed(0,gp_start);

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
    
    if !instance_exists(obj_jumpfx)
    instance_create(x,y,obj_jumpfx)
    audio_play_sound(snd_classic_jump,1,false);
    audio_play_sound(snd_jump,1,false);
    audio_play_sound(snd_SonicAttack2,1,false)
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
    action = 18
    audio_play_sound(snd_stomp_start,1,false);
    instance_create(x,y,obj_stompfx);
    audio_play_sound(snd_SonicAttack3,1,false)
}
if action == 18
{
   vsp = vspl;
   hsp = 0;
   
   if ground
    {
        vibrate_xbox_controller(30)
        shake_camera(15)
        if audio_is_playing(snd_stomp_start)
            audio_stop_sound(snd_stomp_start)
        audio_play_sound(snd_stomp_end,1,false)
        action = 0
        vsp = 0
    }
}
if action != 18 && audio_is_playing(snd_stomp_start)
    audio_stop_sound(snd_stomp_start)

//landing

if ground && (action = 1)
{action = 0;}

///rolling ducking

if key_d && ground && action = 0
{
    if abs(hsp) < 1.03125 {hsp=0; action = -1;}
    if abs(hsp) >= 1.03125 {action = 2; audio_play_sound(snd_roll,1,false)}  
}
if action=-1 &&!key_d {action=0;}///un duck
if action = 2 && abs(hsp) <0.5 && ground {action =0;}///un roll
if action =2 && vsp>0 && !ground && collision_script_ground(14)//un roll on ground
{action = 0;}
 
///looking up

if key_u && ground && action =0
{
    if abs(hsp) < 0.2 {hsp =0;};
}
if (!key_u||!ground||key_r||key_l) action=0;

///dash

if (xdir = -1 && key_x && ground && (action = 0 || action = 1 || action = 2)) {
    action = 29;
    if action = 29
    {
    hsp -= hspm;
    action = 0;
    audio_play_sound(snd_homing,1,false)
    audio_play_sound(snd_SonicBoost1,1,false)
    }
    else if action = 29 && !ground && action == 1
    {
    audio_play_sound(snd_homing,1,false)
    audio_play_sound(snd_SonicBoost2,1,false)
    hsp -= hspm;
    action = 0;
    vsp = 0
    }
}


if (xdir = 1 && key_x && ground && (action = 0 || action = 1 || action = 2)) {
    action = 29;
    if action = 29
    {
    hsp += hspm;
    action = 0;
    audio_play_sound(snd_homing,1,false)
    audio_play_sound(snd_SonicBoost1,1,false)
    }
    else if action = 29 && !ground && action == 1
    {
        audio_play_sound(snd_homing,1,false)
        audio_play_sound(snd_SonicBoost2,1,false)
        hsp += hspm;
        action = 0;
        vsp = 0
    }
}
///spin dash

if sp > 0 {sp = sp-((sp div 1)/265)}
if sp > 192 sp = 192;
if action = -2 && key_a {sp+=8;audio_play_sound(snd_spindash,1,false)}
if action = -2 && !key_d {hsp = xdir*9+(xdir*floor(sp)/8);action = 2; sp =0;audio_play_sound(snd_spindash_launch,1,false) audio_play_sound(snd_SonicAttack1,1,false)}
if action =-1 && key_a 
{
    sp = 0;
    action = -2; 
    
    audio_play_sound(snd_spindash,1,false)
    instance_create(x,y,obj_spindash_dust)
}

//homing attack
if (action == 1 || (action == 0 && !ground) || action == 13) // || (action == 5 && hsp == 0))
{
    canHome = true   
}
else 
{
    canHome = false
}

if canHome && distance_to_object(instance_nearest(x,y,obj_homable)) <= 200 && instance_nearest(x,y,obj_homable).y > (y - 10) && !collision_line(x,y,instance_nearest(x,y,obj_homable).x,instance_nearest(x,y,obj_homable).y,obj_walls,true,true) && instance_nearest(x,y,obj_homable).canHit && (( x < instance_nearest(x,y,obj_homable).x && xdir == 1) || ( x > instance_nearest(x,y,obj_homable).x && xdir == -1))
{
    if !instance_exists(obj_hominglock)
        instance_create(instance_nearest(x,y,obj_homable).x,instance_nearest(x,y,obj_homable).y,obj_hominglock)
}
else if distance_to_object(instance_nearest(x,y,obj_homable)) > 200 || ground || instance_nearest(x,y,obj_homable).y <= (y -10) || ( x < instance_nearest(x,y,obj_homable).x && xdir == -1) || ( x > instance_nearest(x,y,obj_homable).x && xdir == 1)
{
    if instance_exists(obj_hominglock)
        with(obj_hominglock)
        {
            instance_destroy();
        }
}

if (action == 1 && djmp && key_ar) || (action == 0 && !ground) || action == 5
    djmp = false
    

if instance_exists(obj_hominglock)
{
    if key_a && !djmp
    {
        if action != 4
        audio_play_sound(snd_homing,1,false);
        action = 4
        hsp = 0
        vsp = 0
        move_towards_point(obj_hominglock.x,obj_hominglock.y,20);
    }
}
else
{
    if key_a && !ground && (action == 1 || action == 0) && !djmp && djmp2
    {
        if action != 4.5
            audio_play_sound(snd_homing,1,false);
        action = 4.5
        hsp = xdir*9
        vsp = 0
        alarm2 = 15
        djmp = true
        djmp2 = false
    }
}

if !djmp && ground
    djmp = true

if !djmp2 && ground
    djmp2 = true
    
    
if action == 4.5
{
    hsp = xdir*12
    vsp = 0
}

if action == 4 && instance_exists(obj_hominglock)
{
    move_towards_point(obj_hominglock.x,obj_hominglock.y,20);
}
else
{ 
    vspeed = 0;
    hspeed = 0;
}

if action == 4 && (place_meeting(x,y,obj_walls) || ground) 
    action = 0

/// spring jump and dash ring

if (action == 5 || action == 6)
{
    if hsp > 0
        xdir = 1;
    else if hsp < 0
        xdir = -1;
        
    if ground
        action = 0;
} 

/// dash ramp

if action == 7
{
    hsp = 12*xdir
    if ground
        action = 0
}

/// dash pad

if action == 8
{
    if hsp > 0
        hsp = hspl
    else if hsp < 0
        hsp = -hspl
}

/// grinding
if vsp >= 0
    canGrind = true
else
    canGrind = false


if canGrind && ground && collision_line(x,y,x+20*asin,y+20*acos,obj_rail,true,true)  //collision_point(x+16*asin,y+16*acos,obj_rail,true,true)
{
    if action == 2
        action = 0
        
    if action != 11
    {
        audio_play_sound(snd_railcontact,1,false)
        if !instance_exists(obj_grindspark)
            instance_create(x,y,obj_grindspark)
    }
    action = 11    
}


if action == 11
{
    if !audio_is_playing(snd_grinding)
        audio_play_sound(snd_grinding,1,false)
        
    if hsp > 0
        xdir = 1
    else if hsp < 0
        xdir = -1
    if abs(hsp) < hspm
        hsp += acc*xdir
    hsp += -asin*(dcc/6)
    if !ground  || !collision_line(x,y,x+20*asin,y+20*acos,obj_rail,true,true)   
        action = 0
}
if action != 11 && audio_is_playing(snd_grinding)
    audio_stop_sound(snd_grinding)

///taking damage

if action == 22
{
    if ground
    {    
        hsp = 0
        vsp = 0
    }    
    if image_i >= 21
    {
        image_i = 0
        action = 0
    }
}

/// light ring dash

if distance_to_object(instance_nearest(x,y,obj_lightrings)) <= 20 && key_y
    action = 23

if action == 23
{
    if instance_exists(obj_lightrings) && distance_to_object(instance_nearest(x,y,obj_lightrings)) <= 50
    {    
        if instance_nearest(x,y,obj_lightrings).x > x
            xdir = 1
        else if instance_nearest(x,y,obj_lightrings).x < x
            xdir = -1
        move_towards_point(instance_nearest(x,y,obj_lightrings).x,instance_nearest(x,y,obj_lightrings).y,20)
        hsp = 0
        vsp = 0
        i_angle = point_direction(x,y,instance_nearest(x,y,obj_lightrings).x,instance_nearest(x,y,obj_lightrings).y)
    }
    else
    {
          
        hsp = xdir*9*cos(i_angle)
        vsp = 9*sin(i_angle)
        action = 0
        hspeed = 0
        vspeed = 0
    }
}

///dead

if action == 26
{
    if ground
    {
        hsp = 0
        vsp = 0
    }
}
