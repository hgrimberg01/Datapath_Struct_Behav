library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library kurm;
use kurm.common.all;

entity comparator is
    port
    (
        x           :  in word;
        y           :  in word;

        gt          :  out std_logic;
        eq          :  out std_logic;
        lt          :  out std_logic
    );
end entity;

architecture behavioral of comparator is
begin
    comparator : process(x,y) is
    begin
        if ieee.std_logic_signed.">"(x,y) then
            gt <= '1';
        else
            gt <= '0';
        end if;

        if ieee.std_logic_signed."="(x,y) then
            eq <= '1';
        else
            eq <= '0';
        end if;

        if ieee.std_logic_signed."<"(x,y) then
            lt <= '1';
        else
            lt <= '0';
        end if;
    end process comparator;
end architecture;
