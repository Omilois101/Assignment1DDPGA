LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.common_pack.all;

entity dataConsume is
	port (
    clk:		in std_logic;
		reset:		in std_logic; 
		start: in std_logic; 
		numWords_bcd: in BCD_ARRAY_TYPE(2 downto 0);
		ctrlIn: in std_logic;
		ctrlOut: out std_logic;
		data: in std_logic_vector(7 downto 0);
		dataReady: out std_logic;
		byte: out std_logic_vector(7 downto 0);
		seqDone: out std_logic;
		maxIndex: out BCD_ARRAY_TYPE(2 downto 0);
		dataResults: out CHAR_ARRAY_TYPE(0 to RESULT_BYTE_NUM-1) -
  	); 
 end dataConsume;
 
architecture behav of dataConsume is 
  TYPE state_type IS (init,first,second,third,fourth,fifth); 
  SIGNAL curState, nextState: state_type;
  Signal CtrlIn_reg, :std_logic; 
     
    next_state_logic: process(curState,start,count_sig*,ctrlIn)
      ctrlOut := '';
      Case curState is 
        when init =>
          -- This is the initial state where the Comand Processor has its first contact with  the Data Processor

            if start = '1' then
              nextState <= first;
            else 
              nextState <= init;
            end if;
            
        when first =>
         if 
      
           
           end if; 
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

    two_phase_protocol:process(clk)
    begin 
     if rising_edge(clk) then
      ctrlIn_reg <= ctrlIn;
    end if;
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
  		ctrlOut <= '0';
		dataReady <= '0';
		seqDone<= '0';
		maxIndex: out BCD_ARRAY_TYPE(2 downto 0);
		dataResults: out CHAR_ARRAY_TYPE(0 to RESULT_BYTE_NUM-1) -
      end process;
end behav; 
