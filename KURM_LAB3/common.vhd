library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

package common is
    -- The word type is a 16-bit value with the most significant bit at bit
    -- index 15 and the least significant bit at bit index 0.
    subtype word is std_logic_vector(15 downto 0);

    -- The byte type is a 8-bit value with the most significant bit at bit
    -- index 7 and the least significant bit at bit index 0.
    subtype byte is std_logic_vector(7 downto 0);

    -- The nibble type is a 4-bit value with the most significant bit at bit
    -- index 3 and the least significant bit at bit index 0.
    subtype nibble is std_logic_vector(3 downto 0);
    subtype nybble is std_logic_vector(3 downto 0);

    -- The word2int function will convert a word value into an integer.
    function word2int( n : in word ) return integer;
    function byte2int( n : in byte ) return integer;
    function nibble2int( n : in nybble ) return integer;
    function nybble2int( n : in nybble ) return integer;

    -- Sign extend a std_logic_vector
    function signextend( v : in std_logic_vector ) return word;

    -- The log2 function will calculate the log base to of a natural number.
    -- This function can be used to determine the minimum number of bits
    -- which are required to represent the given natural number.
    function log2( n : in natural ) return positive;

    -- The pow2 function will calculate the value of 2 to the power n, where
    -- n is the function parameter. This function can be used to determine
    -- the maximum natural number that can be represented by n bits.
    function pow2( n : in natural ) return positive;

    -- The ispow2 function will determine if a natural number is a power of
    -- two. This function is often most useful for checking the values of
    -- generics using the VHDL assert/report functionality.
    function ispow2( n : in natural ) return boolean;
	 
	 function zero( n : in natural ) return std_logic_vector;
	 function one( n : in natural ) return std_logic_vector;
	 function setbit( n : in natural; b : in natural ) return std_logic_vector;
end package common;

package body common is
    function signextend( v : in std_logic_vector ) return word is
        variable r : word; 
    begin
        r := (others => v(v'left));
        r( v'high downto v'low ) := v;
        return r;
    end function signextend;

    function word2int( n : in word ) return integer is
    begin
        return conv_integer(n);
    end function word2int;

    function byte2int( n : in byte ) return integer is
    begin
        return conv_integer(n);
    end function byte2int;

    function nibble2int( n : in nybble ) return integer is
    begin
        return conv_integer(n);
    end function nibble2int;

    function nybble2int( n : in nybble ) return integer is
    begin
        return conv_integer(n);
    end function nybble2int;

    function zero( n : in natural ) return std_logic_vector is
	     variable o : std_logic_vector(n-1 downto 0);
    begin
	     o(n-1 downto 0) := (others => '0');
		  return o;
	 end function zero;
	 
	 function one( n : in natural ) return std_logic_vector is
	 begin
	     return setbit( n, 0 );
	 end function one;
	 
	 function setbit( n : in natural; b : in natural ) return std_logic_vector is
        variable o : std_logic_vector(n-1 downto 0);
	 begin
	     if( b < n-1 ) then
		      o(n-1 downto b+1) := (others => '0');
		  end if;
		  
		  if( b > 0 ) then
		      o(b-1 downto 0) := (others => '0');
		  end if;

		  o(b) := '1';
		  return o;
	 end function setbit;
	 
    -- Calculate the log base 2 of some natural number. This function can be
    -- used to determine the minimum number of bits needed to represent the
    -- given natural number.
    function log2( n : in natural ) return positive is
    begin
        if n <= 2 then
            return 1;
        else
            return 1 + log2(n/2);
        end if;
    end function log2;

    -- Calculate the 2 to the power n. This function can be used to determine
    -- the maximum natural number which is representable by a given number
    -- of bits.
    function pow2( n : in natural ) return positive is
    begin
        if n = 0 then
            return 1;
        else
            return 2 * pow2( n - 1 );
        end if;
    end function pow2;

    -- Determine if a number is exactly a power of two. This can be used
    -- to check that generics are input as power of two (if that is what
    -- is wanted).
    function ispow2( n : in natural ) return boolean is
        variable l : positive;
        variable p : positive;
    begin
        if( n = 1 ) then
            return true;
        end if;

        if( (n mod 2) = 1 or n = 0) then
            return false;
        end if;

        return ispow2( n / 2 );
    end function ispow2;
end package body common;
