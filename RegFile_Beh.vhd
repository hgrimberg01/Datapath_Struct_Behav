library IEEE;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

library kurm;
use kurm.common.all;

entity RegFile is
     port (A:in word;
	        clk,load,clear:in STD_LOGIC;
	        B,C:out word;
			  Add_A,Add_B,Add_C:in nybble
	  );
end entity RegFile;


architecture Behavioral of RegFile is

type regs is array(0 to 15) of word;
 
begin 
	
	update: process (clk,load,clear,A,Add_A,Add_B,Add_C)-- 3. include input ports in this sensitiy list

	 
	 --nybble to natural number
		function nybble2nat (bv: nybble) return natural is
			variable tmp: natural := 0;
			begin
				for i in bv'high downto bv'low loop
					tmp := tmp * 2;
					if bv(i) = '1' then
						tmp := tmp + 1;
					end if;
				end loop;
			return tmp;
		end function nybble2nat;
    
	variable R: regs;  
	
	begin
		
		if(clear = '1') then
			for i in 2 to 15 loop
				R(i) := x"0000"; 
			end loop;	
			R(0) := x"0000";
			R(1) := x"0001";
		elsif (load='1' and clk='1' and clk'event) then
			R(nybble2nat(Add_A)) := A;
			R(0) := x"0000";
			R(1) := x"0001";
		end if;
				
		B <= R(nybble2nat(Add_B));
		C <= R(nybble2nat(Add_C));
	end process update; 
	
end Behavioral;

