/// stage_list_draw(x, y, offset, color for not selected, color for selected)
 // Draw and handle selection.
 
gamepad_set_axis_deadzone(0,0.7)

    for(i=0; i<1000; i+=1)
    {
        if(global.stage_list[i] != -1)
        {
           if(global.stage_selection == i)
           {
              draw_set_color(argument4);
           }
           else
           {
              draw_set_color(argument3);
           }
           var name;
           name = room_get_name(global.stage_list[i]);
           name = string_replace_all(name, "_", " ");
           name = string_replace_all(name, "rm", "");          
           draw_text(argument0, argument1 + (i*argument2), string_upper(name));
        }
    }
    
 // Selection:
    if(global.stage_list[0] != -1)
    {
       if(keyboard_check_pressed(vk_down) || gamepad_axis_value(0,gp_axislv)>0 || gamepad_button_check_pressed(0,gp_padd))
       {
          global.stage_selection += 1;
          if(global.stage_list[global.stage_selection] = -1)
          {
             global.stage_selection = 0;
          }
       }
       if(keyboard_check_pressed(vk_up) || gamepad_axis_value(0,gp_axislv)<0  || gamepad_button_check_pressed(0,gp_padu))
       {
          global.stage_selection -= 1;
          if(global.stage_selection == -1)
          {
             global.stage_selection = global.stage_count;
          }
       }       
       if(keyboard_check_pressed(vk_enter) || gamepad_button_check_pressed(0,gp_start))
       {
          instance_create(x,y,obj_stage_select_blackfadein)
          obj_stage_select_blackfadein.fadein = true
       }
    }

