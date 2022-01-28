ENTITY mux IS
  PORT (
    a:IN BIT;
    b:IN BIT;
    address:IN BIT;
    q:OUT BIT
  );
END mux;

ARCHITECTURE dataflow OF mux IS
-- This shows the functionality of the code without the use of gate implementation.
-- It can be useful and preferable because it reduces the length of the code therfore speeding up the running of the code.
-- It avoides errors and glitches produced using the gates in the other architecture.
BEGIN
  q <= a WHEN address = '0' ELSE b;
END dataflow;


ARCHITECTURE gates OF mux IS
-- This is also quite useful but slow in its implentation.
-- It is useful when dealing with a data bit but not dealing with larger bits for both a and b.
SIGNAL int1,int2,int_address: BIT;
BEGIN
  q <= int1 OR int2;
  int1 <= b and address;
  int_address <= NOT address;
  int2 <= int_address AND a;
END gates;

ARCHITECTURE sequential OF mux IS
BEGIN
  select_proc : PROCESS (a,b,address)
 	  BEGIN
	    IF (address = '0') THEN
	            q <= a;
		  ELSIF (address = '1') THEN
		    q <= b;
		  END IF;
  END PROCESS select_proc;
END sequential;

ARCHITECTURE bool OF mux IS
SIGNAL q_out: BIT;  
BEGIN
  q_out <= ((a and (not address))or(b and address));
  q <= q_out;
END bool;