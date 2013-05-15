library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library kurm;
use kurm.common.all;

entity mux41 is
    generic
    (
        WIDTH       : natural := 16
    );
    port
    (
        selector    :  in std_logic_vector(1 downto 0);
        input0      :  in std_logic_vector(WIDTH-1 downto 0);
        input1      :  in std_logic_vector(WIDTH-1 downto 0);
        input2      :  in std_logic_vector(WIDTH-1 downto 0);
        input3      :  in std_logic_vector(WIDTH-1 downto 0);
        output      : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity;

architecture structural of mux41 is
    signal input : std_logic_vector(4*WIDTH-1 downto 0);
begin
    input <= input3 & input2 & input1 & input0;

    mux41 : entity kurm.mux
    generic map
    (
        WIDTH       => WIDTH,
        CONTROL     => 2
    )
    port map
    (
        selector    => selector,
        input       => input,
        output      => output
    );
end architecture;
