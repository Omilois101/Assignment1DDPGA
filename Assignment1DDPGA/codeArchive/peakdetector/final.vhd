library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned."+";
use ieee.std_logic_unsigned."-";
use ieee.std_logic_unsigned."=";
use work.common_pack.all;

entity dataConsume is
	port (
	  clk:		in std_logic;
		reset:		in std_logic; -- synchronous reset
		start: in std_logic; -- goes high to signal data transfer
		numWords_bcd: in BCD_ARRAY_TYPE(2 downto 0);
		ctrlIn: in std_logic;
		ctrlOut: out std_logic;
		data: in std_logic_vector(7 downto 0);
		dataReady: out std_logic;
		byte: out std_logic_vector(7 downto 0);
		seqDone: out std_logic;
		maxIndex: out BCD_ARRAY_TYPE(2 downto 0);
		dataResults: out CHAR_ARRAY_TYPE(0 to RESULT_BYTE_NUM-1) -- index 3 holds the peak
	);
end dataConsume;

architecture behav of dataConsume is
  
  --------------Comparator-----------------------------------  
  component comparator is
	  port (
		   data1: in std_logic_vector(7 downto 0);
		   data2: in std_logic_vector(7 downto 0);
		   grtThan: out std_logic;
		   equal: out std_logic
	     );
    end component;
 
  TYPE state_type IS (init,first,second,third,fourth,fifth); 
  SIGNAL curState, nextState: state_type;
  Signal CtrlIn_Reg,CtrlIn_detected:std_logic; 
  SIGNAL bcd_counter: BCD_ARRAY_TYPE(2 DOWNTO 0) := ("0000", "0000", "0000");
  SIGNAL array1: CHAR_ARRAY_TYPE(6 DOWNTO 0) := ("00000000","00000000","00000000","00000000","00000000","00000000","00000000");
  SIGNAL array2: CHAR_ARRAY_TYPE(6 DOWNTO 0) := ("00000000","00000000","00000000","00000000","00000000","00000000","00000000");
  
  
  SIGNAL reg_data: std_logic_vector(7 downto 0);
  
  
  SIGNAL bcd_counter_en: std_logic;
  SIGNAL bcd_counter_reset: std_logic;
  SIGNAL shifter_en: std_logic;
  
  BEGIN
  
  ----------BCD counter----------------------------------------------
  bcd_counter: PROCESS (clk, reset)
    VARIABLE digit1, digit10, digit100 : std_logic_vector(3 DOWNTO 0);
  BEGIN
    IF clk'EVENT AND clk='1' THEN 
      IF reset = '1' or bcd_counter_reset = '1' THEN
        digit1   := "0000";
        digit10  := "0000";
        digit100 := "0000";
        
      ELSIF bcd_counter_en = '1' THEN
        IF digit1 < "1001" THEN        --if count less than 9
          digit1  := digit1 + 1;
        ELSE 
          digit1  := "0000";           --if count >=9, carry out
          digit10 := digit10 + 1;
        END IF;
        
        IF digit10 < "1001" THEN       --if count less than 90
          digit10  := digit10 + 1;
        ELSE 
          digit10  := "0000";          --if count >=90, carry out
          digit100 := digit100 + 1;
        END IF;
      
      END IF;
      
      bcd_counter(0) <= digit1;
      bcd_counter(1) <= digit10;
      bcd_counter(2) <= digit100;
      
    END IF;
      
  END PROCESS;  --counter_bcd
  
  
   ----------Next State Logic----------------------------------------------
  next_state_logic: process(curState,start,bcd_counter,ctrlIn)
    begin
      Case curState is 
        when init =>
          -- This is the initial state where the Comand Processor has its first contact with  the Data Processor
          -- The start signal lets the dataprocessor when to strat the transition.
            if start = '1' then
              nextState <= first;
            else 
              nextState <= init;
            end if;   
        when first =>
          -- This state checks if there is a transition and the setting of a transition in the value of the ctrl signal. 
         ctrlOut <= not ctrlIn;
          if CtrlIn_detected = '0' then 
             nextState <= first;
          else
             nextState <= second;   
          end if;  
        when second =>
          -- The receive data state from the dat generator
          byte <= data; 
          nextState <= third;
        	when third =>
         		    nextState <= fourth;
	             bcd_counter_en <= '0'; 
              if bcd_counter = numWords_bcd then 
                nextState <= fourth;
              else
               if start = '0' then
                  nextState <= second;
                else
                  nextState <= first;
                end if; e
              end if;
        when fourth =>
               nextState <= fifth;
        when fifth =>
              nextState <= init;	      
      end case;
      end process;
      
      
      
 ----------Next State Logic----------------------------------------------     
 two_phase_protocol:process(clk,curState)
    begin 
    if curState = first then
     if rising_edge(clk) then
      CtrlIn_Reg <= ctrlIn;
     end if;
     CtrlIn_detected <= CtrlIn_Reg xor ctrlIn;
    else
     CtrlIn_detected <= ctrlIn; 
    end if;
    end process;
    
 ----------Next State Clock----------------------------------------------     
    next_state_clk: process(clk,reset)
     begin 
       if reset = '0' then 
         curState <= init;
       elsif clk'event and clk ='1' then
         curState <= nextState;
       end if; 
      end process;  
  ----------Output State Clock----------------------------------------------   
      out_clk: process(curState)
    begin
		   dataReady <= '0';
		   seqDone<= '0';
--		   maxIndex <= '0' ;
		 --  dataResults <= '0' ;
		   if curState = fifth then 
		     maxIndex <= Max_index_counter_signal; 
		   elsif curState = sixth then
		     seqDone<= '1';
		   end if; 
    end process;
end behav;
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
