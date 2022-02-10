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
  signal counter_sig : integer; 
  signal en_counter,rest_counter: bit := '0';
  Signal x_reg:STD_ULOGIC := '0';
Begin 
  
  comb_nextstate: process(curState,x_reg,counter_sig)
  BEGIN
      CASE curState IS
         WHEN resets =>
            if x_reg = '0' then
              nextState <= zero_state;
            else
               nextState <= resets; 
            end if;
        
         WHEN zero_state => 
            if x_reg= '0' then 
                nextState <= zero_state;
                if counter_sig < 14 then 
                    en_counter <= '1';
                end if;
            end if;
            if x_reg= '1' then 
                 if counter_sig = 14 then 
                    nextState <= one_state;
                  ELSE 
                    nextState <= resets; 
                    rest_counter <= '1';
                  end if;
            end if;
      
         WHEN one_state =>
            if x_reg= '1' then 
                nextState <= one_state;
                if counter_sig < 16 then 
                  en_counter <= '1';
               end if;
            end if;
            if x_reg= '1' then 
                if counter_sig = 16 then 
                    nextState <= out_state;
                ELSE 
                    nextState <= resets; 
                    rest_counter <= '1';
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

   counter:process(reset,en_counter,rest_counter, clk)
      begin
         if reset = '0' or rest_counter = '1'then 
           counter_sig <= 0; 
          elsif clk'event and clk = '1' then 
             if en_counter = '1' then
                counter_sig <= counter_sig + 1;
             end if;
         end if;
      end process; 

   registers: process(clk)
	    BEGIN
	      IF clk'event AND clk='1' THEN
	        x_reg <= x;
	      END IF;
	    END PROCESS;
 
END myArch;

