library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library kurm;
use kurm.common.all;


entity RegFile_struct is
     port (A:in word;
	        clk,load,clear:in STD_LOGIC;
	        B,C:out word;
			  Add_A,Add_B,Add_C:in nybble
	  );
end entity RegFile_struct;


architecture structural of RegFile_struct  is

type regs is array(0 to 15) of word;  
signal R: regs; -- Similar to Behavioral model, now R is the register array in Register File. 
signal le: word;

begin

	
	   RegF: for i in 0 to 15 generate 
		begin
			Reg:entity kurm.reg(behavioral)
			port map (clk, A, le(i),'0', clear,R(i));
	   end generate RegF;
		
        demux_reg:entity kurm.demux416(structural)
		port map(
        selector   =>Add_A,
        input      =>load,
        output0     =>le(0),
        output1    => le(1),
        output2    => le(2),
        output3    => le(3),
        output4    => le(4),
        output5    => le(5),
        output6    => le(6),
        output7    => le(7),
        output8    => le(8),
        output9    => le(9),
        output10   => le(10),
        output11   => le(11),
        output12   => le(12),
        output13   => le(13),
        output14   => le(14),
        output15   => le(15)
    );


	 
	mux_reg:entity kurm.mux161(structural)

	port map(      selector   =>  Add_B,
        input0 =>     x"0000",
        input1  =>    x"0001",
        input2  =>    R(2),
        input3  =>    R(3),
        input4  =>    R(4),
        input5  =>    R(5),
        input6  =>    R(6),
        input7  =>    R(7),
        input8  =>    R(8),
        input9  =>    R(9),
        input10  =>   R(10),
        input11  =>   R(11),
        input12 =>    R(12),
        input13  =>   R(13),
        input14 =>    R(14),
        input15  =>   R(15),
        output => B
		  );
		  
	mux_reg2:entity kurm.mux161(structural)
	
	port map(      selector   =>  Add_C,
        input0 =>     x"0000",
        input1  =>    x"0001",
        input2  =>    R(2),
        input3  =>    R(3),
        input4  =>    R(4),
        input5  =>    R(5),
        input6  =>    R(6),
        input7  =>    R(7),
        input8  =>    R(8),
        input9  =>    R(9),
        input10  =>   R(10),
        input11  =>   R(11),
        input12 =>    R(12),
        input13  =>   R(13),
        input14 =>    R(14),
        input15  =>   R(15),
        output => C
		  );  
		  

end  structural;

