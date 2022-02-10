--------------------------------------------
-- Implementation of a Pattern Detector
--------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pat_detector IS
PORT(
  x: in STD_ULOGIC;
  clk: in STD_ULOGIC;
  reset: in STD_ULOGIC;
  y: out STD_ULOGIC);
end;

ARCHITECTURE arch_ pat_detector for pat_detector is 
TYPE state_type IS (s0,s1,s2)
signal curState,nextState : std_Ulogic 
signal counter_sig : integer; 
component(
);
begin 
  
comb_nextstate: process()
   BEGIN
    CASE curState IS
      WHEN so => 
      WHEN s1 =>
      WHEN s2 =>
    end case;  
end process;

comb_out:process()
    begin 
      y <= '0';  
    IF curState = 's2' THEN
      y <= '1';
    END IF;
end process;

SEQ_STATE: PROCESS (clk , curState)
  if reset = '0' then 
    curState = s0;
  else if clk'event and clk = '1'then 
    curState = nextState;
end if;    

counter:process(counter_sig, clk)
begin
  if reset = '0' then 
     counter_sig <= 0; 
 else if clk'event and clk = '1' then 
      counter_sig <= counter + 1;
 end if;
end process; 

END process; 
END arch_ pat_detector;
