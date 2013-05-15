library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library kurm;
use kurm.common.all;

entity word_or is
    port
    (
        x   :  in word;
        y   :  in word;
        z   : out word
    );
end entity;

architecture behavioral of word_or is
begin
    z <= x or y;
end architecture;
