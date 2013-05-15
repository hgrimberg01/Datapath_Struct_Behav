library IEEE;
library kurm;
library work;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use kurm.common.all;

library unisim;
use unisim.vcomponents.all;

-------------------------------------------------------------------------------
-- System Entity
-------------------------------------------------------------------------------
entity system is 
    port
    (
        sys_clk :  in std_logic;
        sys_rst :  in std_logic

    );
end entity system;

-------------------------------------------------------------------------------
-- System Architecture
-------------------------------------------------------------------------------
architecture struct of system is

	-- This component description is found in icon_xst_example.vhd
	-- which is generated by chip scope when the icon is generated
    component icon
    port
    (
        control0    : out std_logic_vector(35 downto 0)
    );
    end component;
    
	-- This component description is found in vio_xst_example.vhd
	-- which is generated by chip scope when the vio core is generated
  -------------------------------------------------------------------
  --
  --  VIO core component declaration
  --
  -------------------------------------------------------------------
  component vio
    port
    (
	  control     : in    std_logic_vector(35 downto 0);
      clk         : in    std_logic;
      async_in    : in    std_logic_vector(105 downto 0);
      async_out   : out   std_logic_vector(47 downto 0);
      sync_in     : in    std_logic_vector(1 downto 0);
      sync_out    : out   std_logic_vector(15 downto 0)
    );
  end component;



	-- Include these internal signals for the clock,reset and control 
    signal clk      : std_logic;
    signal clkcsp   : std_logic;
    signal rst      : std_logic;
    signal control  : std_logic_vector(35 downto 0);
    

	-- These signals will be all the signal ports of 
	-- all of the components you are synthesizing
    
	 
	 --reg_file and reg_file_struct signals
	 -- 
	signal A : word;
	signal Add_A : nybble;
	signal B_beh, B_str, C_beh, C_str : word;	
	signal Add_B, Add_C : nybble; 
	signal load : std_logic; 
	signal clear : std_logic;

	 	 
	 --Define ALU behavioral and ALU_struct signals (including control - c which is 2 bits) here
  

	 
begin

    -- Instantiate the kurm clock
    clock_i : entity kurm.clock(mixed)
    port map
    (
        sys_clk => sys_clk,
        sys_rst => sys_rst,
        clk     => clk,
        clk2x   => clkcsp,
        rst     => rst
    );

    -- Instantitate the reg_beh, reg_str, alu_beh, alu_str entities
	-- Example of Instantiating the reg_beh_file 
    Reg_file : entity work.reg_file(Behavioral)
    port map
    ( A, Add_A, B_beh, C_beh,	Add_B, Add_C, load, clear, clk );


    -- Instantiate the regfile_struct here
   

    -- Instantiate the ALU behavorial here
	
	 
    -- Instantiate the ALU_struct here
	 
	 
	 
	 -- Instantiate the Chipscope Pro Integrated Controller
    icon_i : icon
    port map
    (
        control0 => control
    );

    -- Instantiate the Chipscope Pro Virtual I/O
    -- Hook up asynch to asynch inputs and outputs
    -- Hook up synch to synch inputs and outputs
    -- Any unused inputs drive to '0'
    -- Any unused outputs => open
    
    vio_i : vio
    port map
    (
			control                 => control,
			clk                     => clkcsp,
			
			async_in(105 downto 90) => B_beh,
			async_in(89 downto 74)  => C_beh,
			async_in(73 downto 58)  => B_str,
			async_in(57 downto 42)  => C_str,
			async_in(41 downto 26)  => z_beh,
			async_in(25 downto 10)  => z_str,
			async_in(9) => cout_beh, 
			async_in(8) => cout_str,
			async_in(7) => ovrfl_beh,
			async_in(6) => ovrfl_str,
			async_in(5) => lt_beh,
			async_in(4) => lt_str,
			async_in(3) => eq_beh,
			async_in(2) => eq_str,
			async_in(1) => gtr_beh,
			async_in(0) => gtr_str,
			async_out(47 downto 46) => c, -- control input
			async_out(45 downto 30) => x,
			async_out(29 downto 14) => y,
			async_out(13 downto 10) => Add_A,
			async_out(9 downto 6)   => Add_B,
			async_out(5 downto 2)   => Add_C,
			async_out(1)            => load,
			async_out(0)            => clear,

			sync_in(1) => 			clk,
			sync_in(0)             => '0',		  
			sync_out(15 downto 0)  => A -- Input "A"

    );
end architecture struct;