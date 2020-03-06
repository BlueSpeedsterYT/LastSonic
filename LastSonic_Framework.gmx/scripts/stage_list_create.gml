/// stage_list_create();
 // Creates a list of stages.
 
    j = 0;
    for(i=0; i<1000; i+=1)
    { 
        if(room_exists(i) == true)
        {
           var stage_check;
           stage_check = room_get_name(i);
           if(string_pos("_Act", stage_check) != 0)
           { 
              global.stage_list[j] = i;
              j+=1;
           }
        }
        else
        {
           global.stage_count     = j-1;
           global.stage_selection = 0;
           return i;
        }
    } 
    
    


