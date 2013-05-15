----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:46:17 04/29/2013 
-- Design Name: 
-- Module Name:    ALU_beh - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library kurm;
use kurm.common.all;

entity ALU_beh is
	port( 
			X,Y:in word;
			control: in  std_logic_vector(1 downto 0);
			Z:out word;
			lesser,greater,equalto,overflow,carryout:out std_logic
		);
end entity ALU_beh;

architecture Behavioral of ALU_beh is
	
type sresult is record
	z : word;
	cout : std_logic;
	ovf : std_logic;
end record sresult;

function sadd(x,y:std_logic_vector;c:std_logic) return sresult is
	variable a : sresult;
	variable b : std_logic_vector(2 downto 0);
	begin
	a.z := conv_std_logic_vector(ieee.std_logic_signed.conv_integer(x)+ieee.std_logic_signed.conv_integer(y)+conv_integer(c),16);
	b := a.z(15) & x(15) & y(15);
	case b is
	when "001" => a.cout := '1'; a.ovf := '0';
	when "010" => a.cout := '1'; a.ovf := '0';
	when "011" => a.cout := '1'; a.ovf := '1';
	when "100" => a.cout := '0'; a.ovf := '1';
	when "111" => a.cout := '1'; a.ovf := '0';
	when others => a.cout := '0'; a.ovf := '0';
	end case;
return a;
end sadd;
begin
do_alu: process (X, Y, control)
variable a: sresult; 
variable carryin: std_logic;
	begin
case control is

	when "00" =>
		Carryin := '0';
		a := sadd(X,Y,carryin);
		z <= a.z;
		carryout<= a.cout;
		overflow <= a.ovf;
	when "01" =>
		Carryin := '0';
		a := sadd(X,(not Y)+'1',carryin);
		z <= a.z;
		carryout <= a.cout;
		overflow <= a.ovf;
	when "10" =>
		for n in X'range loop --- (means from n = 0 to 15)
			Z(n) <= X(n) AND Y(n);
		End loop;
		carryout<='0';
		overflow<='0';
	when "11" =>
		For n in X'range loop --- (means from n = 0 to 15)
			Z(n) <= X(n) OR Y(n);
		End loop;
		carryout<='0';
		overflow<='0';
	when others => report "INVALID";
	end case;
	
	if ieee.std_logic_signed.">"(X,Y) then
		greater <= '1';
	else
		greater <= '0';
	end if;
	
	if ieee.std_logic_signed."<"(X,Y) then
		lesser <= '1';
	else
		lesser <= '0';
	end if;
	
	if ieee.std_logic_signed."="(X,Y) then
		equalto <= '1';
	else
		equalto <= '0';
	end if;

end process do_alu ;
end Behavioral;

