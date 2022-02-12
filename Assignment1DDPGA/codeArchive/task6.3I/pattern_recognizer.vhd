--------------------------------------------
-- Implementation of a Pattern Detector
-- 
--------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY recog2 IS
PORT(
      X: in	bit;
      CLK: in	bit;
      RESET: in	bit;
      Y: out		bit);
end;

ARCHITECTURE myArch of recog2 is 
--------------------------------------------------------------------
-- This architecture us assuming that there is no overlapping or 
-- and there is a reseting of signal after the output has been asserted.
-- meaning previous iput variables after output assertion will not be read. 
---------------------------------------------------------------------------
  TYPE state_type IS (resets,zero_state,one_state,out_state);
  signal curState,nextState: state_type;
  signal zero_counter_sig,one_counter_sig : integer range 1 to 32 ; 
  signal en_counter,en_one_counter,rest_counter,rest_one_counter: bit ;
  Signal x_reg: bit := '0';
Begin 
  
  comb_nextstate: process(curState,x_reg,zero_counter_sig,one_counter_sig)
  BEGIN
      en_counter <= '0';
      en_one_counter <='0';
      rest_counter <= '0';
      rest_one_counter <='0';
      CASE curState IS
         WHEN resets =>
            rest_counter <= '1';
            rest_one_counter <='1';
            if x_reg = '0' then
              nextState <= zero_state;
            else
              nextState <= resets;
            end if;
        
         WHEN zero_state => 
          if x_reg= '0' then 
                nextState <= zero_state;
                if zero_counter_sig < 16 then 
                  en_counter <= '1';           
                end if;
          else  
                if zero_counter_sig = 15 then  
                nextState <= one_state;  
                else
                  nextState <= resets;              
                end if;                                  
          end if;
      
         WHEN one_state =>
            if x_reg= '1' then 
               nextState <= one_state;
               if one_counter_sig < 18 then 
                  en_one_counter <= '1';                                                
               end if;
            else
              if one_counter_sig = 17 then
                  nextState <= out_state; 
              else
                  nextState <= resets;  
              end if;      
            end if;
       
        WHEN out_state =>
             nextState <= resets; 
      end case;  
  end process;

  comb_out:process(curState)
     begin 
       y <= '0';  
       IF curState = out_state THEN
          y <= '1';
       END IF;
     end process;

  SEQ_STATE: PROCESS (clk , reset)
   BEGIN
     if reset = '0' then 
         curState <= resets;
      elsif clk'event and clk = '1' then 
         curState <= nextState;
     END IF;    
   END process;

   zero_counter:process(reset,en_counter,rest_counter, clk)
      begin
         if reset = '0' or rest_counter = '1'then 
           zero_counter_sig <= 1; 
          elsif clk'event and clk = '1' then 
             if en_counter = '1' then
                zero_counter_sig <= zero_counter_sig + 1;
             else 
               zero_counter_sig <= zero_counter_sig;
             end if;
         end if;
      end process; 

  
	one_counter:process(reset,en_counter,rest_counter, clk)
      begin
         if reset = '0' or rest_one_counter = '1'then 
          one_counter_sig <= 1; 
          elsif clk'event and clk = '1' then 
             if en_one_counter = '1' then
               one_counter_sig <= one_counter_sig + 1;
             else 
               one_counter_sig <= one_counter_sig;
             end if;
         end if;
      end process; 

  process(clk)
	    BEGIN
	      IF clk'event AND clk='1' THEN
	        x_reg <= x;
	      END IF;
	    END PROCESS;
 
END myArch;




