library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library kurm;
use kurm.common.all;

entity bit_xor is
    port
    (
        x   :  in word;
        y   :  in std_logic;
        z   : out word
    );
end entity;

architecture behavioral of bit_xor is
begin
    update: process (x,y) is
        variable y_word : word;
    begin
        y_word := (others => y);
        z <= x xor y_word;
    end process;
end architecture;
