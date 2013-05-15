library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library kurm;
use kurm.common.all;

entity reg_file_test is
end reg_file_test;

architecture mixed of reg_file_test is
	signal Add_A, Add_B, Add_C : nybble; 
	signal A : word;
	signal Bbeh, Cbeh : word;  -- declare output for behavioral model 
	signal Bstr, Cstr : word;  -- declare output for structural model 
	signal load, clear, clk: std_logic;
	
begin


	RegFile_beh : entity work.RegFile(Behavioral)  -- 1.Connect to behavioral model 
   port map( A=>A,B=>Bbeh,C=>Cbeh,Add_A=>Add_A,Add_B=>Add_B,Add_C=>Add_C,load=>load,clear=>clear,clk=>clk);
	
	RegFile_str : entity work.RegFile_struct(structural)   -- 2.Connect to structural model 
   port map( A=>A,B=>Bstr,C=>Cstr,Add_A=>Add_A,Add_B=>Add_B,Add_C=>Add_C,load=>load,clear=>clear,clk=>clk);
	
	
	test : process   -- 3. a process to specify input values 
	begin 
	
    	-- Initialize input data and address 
		--Start by using B for output of interest
		A <= x"0004";
		Add_A <= x"3";
		Add_B <= x"3";
		Add_C <= x"1";
	
		-- Test clear function 
		clear <= '1'; load <= '0'; wait for 20 ns;
		clear <= '0'; load <= '0'; wait for 20 ns;
		

		-- Test load function 
		clear <= '0'; load <= '1'; wait for 20 ns;
		clear <= '0'; load <= '0'; wait for 20 ns;
		
		--Test Register C load
		A <=x"0007"; Add_A <=x"4"; Add_C <=x"4"; wait for 20 ns;
		clear <= '0'; load <= '1'; wait for 20 ns;
		clear <= '0'; load <= '0'; wait for 20 ns;
		
		--Try to put garbage into first and second registers. Should remain 0 and 1 respectively.
		
		A<=x"1337";  Add_A<=x"0"; Add_B <=x"0"; Add_C<=x"1";wait for 20 ns;
		clear <= '0'; load <= '1'; wait for 20 ns;
		clear <= '0'; load <= '0'; wait for 20 ns;
		Add_A <=x"1";
		clear <= '0'; load <= '1'; wait for 20 ns;
		clear <= '0'; load <= '0'; wait for 20 ns;
		
		
		wait ;
	end process test;
	
	
	clock : process is  -- a process to generate clock signal
	begin
		for i in 0 to 8 loop
			clk <= '0';
			wait for 5 ns;
			clk <= '1';
			wait for 5 ns;
		end loop;
	end process clock;	
	
	
end architecture mixed;