library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library kurm;
use kurm.common.all;

entity mux is
    generic
    (
        WIDTH       : natural := 16;
        CONTROL     : natural := 2
    );
    port
    (
        selector    :  in std_logic_vector(CONTROL-1 downto 0);
        input       :  in std_logic_vector(pow2(CONTROL)*WIDTH-1 downto 0);
        output      : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity;

architecture behavioral of mux is
    constant INPUTS : natural := pow2(CONTROL);
begin
    mux : process(selector,input) is
    begin
        for i in INPUTS-1 downto 0 loop
            if i = conv_integer(selector) then
                output <= input((i+1)*WIDTH-1 downto i*WIDTH);
            end if;
        end loop;
    end process mux;
end architecture;
