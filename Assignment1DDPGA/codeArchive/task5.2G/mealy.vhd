-- Mealy Machine (mealy.vhd)
-- Asynchronous reset, active low
------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY recog1 IS
PORT(
  x: in STD_ULOGIC;
  clk: in STD_ULOGIC;
  reset: in STD_ULOGIC;
  y: out STD_ULOGIC);
end;

----------------------------------------------------
-- MEALY --
-----------------------------------------------------
ARCHITECTURE arch_mealy OF recog1 IS
  -- State declaration
  TYPE state_type IS (INIT,FIRST,SECOND,THIRD);  -- List your states here 	
  SIGNAL curState, nextState: state_type;
  Signal x_reg:STD_ULOGIC := '0';
BEGIN
  -----------------------------------------------------
  combi_nextState: PROCESS(curState, x_reg)
  BEGIN
    CASE curState IS
      WHEN INIT => 
        IF x_reg='0' THEN 
          nextState <= INIT;
        ELSE
          nextState <= FIRST;
        END IF;
      WHEN FIRST =>
        IF x_reg='0' THEN
          nextState <= SECOND;
        ELSE
          nextState <= FIRST;
        END IF;
      WHEN SECOND =>
        IF x_reg='0' THEN
          nextState <= INIT;
        ELSE
         nextState <= THIRD;         
        END IF;
      WHEN THIRD =>
        IF x_reg ='0' THEN
          nextState <= INIT;
        ELSE
          nextState <= FIRST;
        END IF;      
    END CASE;
  END PROCESS; -- combi_nextState
  combi_out: PROCESS(curState, x_reg)
  BEGIN
    y <= '0'; -- assign default value
    IF curState = THIRD AND x_reg='1' THEN
      y <= '1';
    END IF;
  END PROCESS; -- combi_output
  -----------------------------------------------------
  seq_state: PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      curState <= INIT;
    ELSIF clk'EVENT AND clk='1' THEN
      curState <= nextState;
    END IF;
  END PROCESS; -- seq
  register: PROCESS(clk)
	  BEGIN
	    IF clk'event AND clk='1' THEN
	      x_reg <= x;
	    END IF;
	  END PROCESS;
  -----------------------------------------------------
END; -- arch_mealy  
  
  
----------------------------------------------------
-- MOORE --
-----------------------------------------------------
ARCHITECTURE arch_moore OF recog1 IS
  -- State declaration
  TYPE state_type IS (INIT,FIRST,SECOND,THIRD,FOURTH);  -- List your states here 	
  SIGNAL curState, nextState: state_type;
BEGIN
  -----------------------------------------------------
  combi_nextState: PROCESS(curState, x)
  BEGIN
    CASE curState IS
      WHEN INIT => 
        IF x='0' THEN 
          nextState <= INIT;
        ELSE
          nextState <= FIRST;
        END IF;
        
      WHEN FIRST =>
        IF x='0' THEN
          nextState <= SECOND;
        ELSE
          nextState <= FIRST;
        END IF;
      WHEN SECOND =>
        IF x='0' THEN
          nextState <= INIT;
        ELSE
         nextState <= THIRD;         
        END IF;
      WHEN THIRD =>
        IF x='0' THEN
          nextState <= FOURTH;
        ELSE
          nextState <= FIRST;
        END IF;
      WHEN FOURTH =>
        IF x='0' THEN
          nextState <= INIT;
        ELSE
          nextState <= FIRST;
        END IF;   
    END CASE;
  END PROCESS; -- combi_nextState
  combi_out: PROCESS(curState, x)
  BEGIN
    y <= '0'; -- assign default value
    IF curState = FOURTH THEN
      y <= '1';
    END IF;
  END PROCESS; -- combi_output
  -----------------------------------------------------
  seq_state: PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      curState <= INIT;
    ELSIF clk'EVENT AND clk='1' THEN
      curState <= nextState;
    END IF;
  END PROCESS; -- seq
  
  
  -----------------------------------------------------
END; -- arch_moore  
  
-----------------------------------------------------
  


