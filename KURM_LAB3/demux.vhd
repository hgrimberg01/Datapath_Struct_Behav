library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library kurm;
use kurm.common.all;

entity demux is
    generic
    (
        WIDTH       : natural := 1;
        CONTROL     : natural := 2
    );
    port
    (
        selector    :  in std_logic_vector(CONTROL-1 downto 0);
        input       :  in std_logic_vector(WIDTH-1 downto 0);
        output      : out std_logic_vector(pow2(CONTROL)*WIDTH-1 downto 0)
    );
end entity;

architecture behavioral of demux is
    constant OUTPUTS : natural := pow2(CONTROL);
begin
    demux : process(selector,input) is
    begin
        for i in OUTPUTS-1 downto 0 loop
            if i = conv_integer(selector) then
                output((i+1)*WIDTH-1 downto i*WIDTH) <= input;
            else
                output((i+1)*WIDTH-1 downto i*WIDTH) <= (others => '0');
            end if;
        end loop;
    end process demux;
end architecture;
