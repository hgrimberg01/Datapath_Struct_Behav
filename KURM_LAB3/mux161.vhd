library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library kurm;
use kurm.common.all;

entity mux161 is
    generic
    (
        WIDTH       : natural := 16
    );
    port
    (
        selector    :  in std_logic_vector(3 downto 0);
        input0      :  in std_logic_vector(WIDTH-1 downto 0);
        input1      :  in std_logic_vector(WIDTH-1 downto 0);
        input2      :  in std_logic_vector(WIDTH-1 downto 0);
        input3      :  in std_logic_vector(WIDTH-1 downto 0);
        input4      :  in std_logic_vector(WIDTH-1 downto 0);
        input5      :  in std_logic_vector(WIDTH-1 downto 0);
        input6      :  in std_logic_vector(WIDTH-1 downto 0);
        input7      :  in std_logic_vector(WIDTH-1 downto 0);
        input8      :  in std_logic_vector(WIDTH-1 downto 0);
        input9      :  in std_logic_vector(WIDTH-1 downto 0);
        input10     :  in std_logic_vector(WIDTH-1 downto 0);
        input11     :  in std_logic_vector(WIDTH-1 downto 0);
        input12     :  in std_logic_vector(WIDTH-1 downto 0);
        input13     :  in std_logic_vector(WIDTH-1 downto 0);
        input14     :  in std_logic_vector(WIDTH-1 downto 0);
        input15     :  in std_logic_vector(WIDTH-1 downto 0);
        output      : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity;

architecture structural of mux161 is
    signal input : std_logic_vector(16*WIDTH-1 downto 0);
begin
    input <= input15 & input14 & input13 & input12 &
             input11 & input10 & input9  & input8  &
             input7  & input6  & input5  & input4  &
             input3  & input2  & input1  & input0;

    mux161 : entity kurm.mux
    generic map
    (
        WIDTH       => WIDTH,
        CONTROL     => 4
    )
    port map
    (
        selector    => selector,
        input       => input,
        output      => output
    );
end architecture;
