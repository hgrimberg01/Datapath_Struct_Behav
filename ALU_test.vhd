library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library kurm;  
use kurm.common.all;

entity ALU_test is
end ALU_test;

architecture mixed of ALU_test is

   signal x, y, z_beh,z_str : word;
   signal cout_str, lt_str, eq_str, gtr_str, ovrfl_str : std_logic; 
	signal cout_beh, lt_beh, eq_beh, gtr_beh, ovrfl_beh : std_logic; 
   signal ctrl : std_logic_vector(1 downto 0);
   
begin

	ALU_behave: entity work.alu_beh(Behavioral)  -- 1)library name; 2) ALU entity name; 3) architecture name
            port map(  
				control=> ctrl, -- left side is port declared in your ALU entity --
				x => x, 
				y => y, 
				z => z_beh,
				lesser=> lt_beh,
				equalto => eq_beh,
				greater => gtr_beh,
				overflow => ovrfl_beh,
				carryout => cout_beh
				);
				
	ALU_structural: entity work.alu_struct(structural)  -- 1)library name; 2) ALU entity name; 3) architecture name
            port map(  
				control=> ctrl, -- left side is port declared in your ALU entity --
				x => x, 
				y => y, 
				z => z_str,
				lesser=> lt_str,
				equalto => eq_str,
				greater => gtr_str,
				overflow => ovrfl_str,
				carryout => cout_str
				);
				
   test: process is      
   begin
	  -- Initialize two operands --
	  x <= x"0001";
     y <= x"0003" ;
     	
      -- Test addition
      ctrl <= "00"; wait for 50 ns;
		
      -- Test subtraction
      ctrl <= "01"; wait for 50 ns;
      
	  -- Test AND 
      ctrl <= "10"; wait for 50 ns;

	  -- Test OR 
      ctrl <= "11"; wait for 50 ns;
		
		
		
		 -- Initialize two operands --
	  x <= x"7FFF";
     y <= x"8000" ;
     	
      -- Test addition
      ctrl <= "00"; wait for 50 ns;
		
      -- Test subtraction
      ctrl <= "01"; wait for 50 ns;
      
	  -- Test AND 
      ctrl <= "10"; wait for 50 ns;

	  -- Test OR 
      ctrl <= "11"; wait for 50 ns;
		
	
	  x <= x"8000";
     y <= x"7FFF" ;
     	
      -- Test addition
      ctrl <= "00"; wait for 50 ns;
		
      -- Test subtraction
      ctrl <= "01"; wait for 50 ns;
      
	  -- Test AND 
      ctrl <= "10"; wait for 50 ns;

	  -- Test OR 
      ctrl <= "11"; wait for 50 ns;

     x <= x"7777";
     y <= x"7777" ;
     	
      -- Test addition
		--Should cause overflow
      ctrl <= "00"; wait for 50 ns;
		
      -- Test subtraction
      ctrl <= "01"; wait for 50 ns;
      
	  -- Test AND 
      ctrl <= "10"; wait for 50 ns;

	  -- Test OR 
      ctrl <= "11"; wait for 50 ns;			


      wait;
   end process test;

end mixed;

