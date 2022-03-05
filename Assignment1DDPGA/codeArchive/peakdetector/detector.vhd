LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

  TYPE state_type IS (init,first,second,third,fourth,fifth); 
  SIGNAL curState, nextState: state_type;
    


    next_state_logic: process(curState,start,count_sig)
      Case curState is 
        when init =>
            if start = '1' then
              nextState <= first;
            else 
              nextState <= init;
            end if;
        when first =>
        when second =>
        when third =>
              if 
              elsif 
              else
              end if;
        when fourth =>
               nextState <= fifth;
        when fifth =>
              nextState <= init;
      end case;
    
      end process;
  

    next_state_clk: process(clk,reset)
     begin 
       if reset = '0' then 
         curState <= init;
       elsif clk'event and clk ='1' then
         curState <= nextState;
       end if; 
      end process;
    out_clk: process(curState,)
    
      end process;
  
