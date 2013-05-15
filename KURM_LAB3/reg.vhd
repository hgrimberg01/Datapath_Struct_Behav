library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity reg is
    generic
    (
        WIDTH       : natural := 16
    );
    port
    (
        clk         :  in std_logic;
        d           :  in std_logic_vector(WIDTH-1 downto 0);
        le          :  in std_logic;
        set         :  in std_logic;
        clear       :  in std_logic;
        q           : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity;

architecture behavioral of reg is
begin
    reg : process(clk,d,le,set,clear) is
    begin
        if( clear = '1' ) then
            q <= (others => '0');
        elsif( set = '1' ) then
            q <= (others => '1');
        elsif( rising_edge(clk) ) then
            if( le = '1' ) then
                q <= d;
            end if;
        end if;
    end process reg;
end architecture;
