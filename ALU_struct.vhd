library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library kurm;
use kurm.common.all;


entity ALU_struct is
	port( 
			X,Y:in word;
			control: in  std_logic_vector(1 downto 0);
			Z:out word;
			lesser,greater,equalto,overflow,carryout:out std_logic
		); 
end entity ALU_struct;
 
architecture structural of ALU_struct is

	-- 2. Declare any internal signal needed in your design 
	--    Recall that these internal signals will be mainly used to
    --	  connect functional components 
	 
	signal z_add,z_sub,z_or,z_and,noty:word; 
	signal ovf_add,ovf_sub:std_logic;
	signal cout_add,cout_sub:std_logic;
	signal ovf_sub_fix,ovf_add_fix,cout_add_fix,cout_sub_fix,cout_out,ovf_out:std_logic_vector(0 downto 0);
	
	
	

begin 
	
	 
	-- 3. For addition, may use 'adder'
	STRUCT_ADD: entity kurm.adder port map (X,Y,z_add,'0',cout_add,ovf_add);
	
	STRUCT_XNOR:entity kurm.bit_xor(behavioral) port map(y,'1',notY);
	
	-- 4. For subtraction, may use 'adder' as well
	--    hint: 'a - b' is equiavalent to 'a + not b' with 
	--    'carry in bit 1' 
	--    To know where to put this bit, read 'adder' code
	
   SUBTRACT: entity kurm.adder(behavioral) port map (x,notY,z_sub,'1',cout_sub,ovf_sub);
	
	-- 5. For AND and OR, search your kurm library to see if there are any components to use. Try to specify as few behaviors as possible and use as many components as possible. 
	
	STRUCT_OR:entity kurm.word_or(behavioral) port map(x,y,z_or);
	
	STRUCT_AND:entity kurm.word_and(behavioral) port map(x,y,z_and);
	
	-- 6. For comparison, may use 'comparator'
	
	-- 7. To allocate resources, may use 'mux41' (since we have 4 operations determined by 'ctrl')
	
	STRUCT_COMP:entity kurm.comparator(behavioral) port map(x,y,greater,equalto,lesser);
	
	mux1: entity kurm.mux41(structural)
	generic map (16) 
	port map (control, z_add, z_sub, z_and, z_or, z);
	

	
	ovf_sub_fix(0) <= ovf_sub;
	ovf_add_fix(0) <= ovf_add;
	cout_sub_fix(0) <= cout_sub;
	cout_add_fix(0) <= cout_add;
	mux2: entity kurm.mux41(structural)
	generic map (1) 
	port map (control, ovf_add_fix,ovf_sub_fix, "0", "0",ovf_out);
	
	mux3: entity kurm.mux41(structural)
	generic map (1) 
	port map (control, cout_add_fix, cout_sub_fix, "0", "0",cout_out);
	
	overflow <= ovf_out(0);
	carryout <= cout_out(0);
	
end structural;
