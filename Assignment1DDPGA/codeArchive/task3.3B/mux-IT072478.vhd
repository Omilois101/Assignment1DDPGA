ENTITY mux IS
  PORT (
    a:IN BIT;
    b:IN BIT;
    address:IN BIT;
    q:OUT BIT
  );
END mux;

ENTITY andgate IS
  PORT (
    a:IN BIT;
    b:IN BIT;
    q:OUT BIT
  );
END mux;

ENTITY orgate IS
  PORT (
    a:IN BIT;
    b:IN BIT;
    q:OUT BIT
  );
END mux;

-- One entity, two separate architectures.
-- The architecture of choice can be bound to the entity 
-- at the time of instantiation in the testbench.

ARCHITECTURE structural OF mux IS
component andgate
    port(  a:IN BIT;
           b:IN BIT;
            q:OUT BIT);   
end component andgate

component orgate
    port(  a:IN BIT;
           b:IN BIT;
           q:OUT BIT);   
end component orgate

signal  : BIT;

BEGIN
  
  
  
END structural;

ARCHITECTURE dataflow OF mux IS
BEGIN
  q <= a WHEN address = '0' ELSE b;
END dataflow;


ARCHITECTURE gates OF mux IS
  SIGNAL int1,int2,int_address: BIT;
BEGIN
  q <= int1 OR int2;
  int1 <= b and address;
  int_address <= NOT address;
  int2 <= int_address AND a;
END gates;

ARCHITECTURE dataflow OF mux IS
BEGIN
  q <= a WHEN address = '0' ELSE b;
END dataflow;