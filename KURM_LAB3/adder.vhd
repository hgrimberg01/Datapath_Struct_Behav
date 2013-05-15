library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library kurm;
use kurm.common.all;

entity adder is
    port
    (
        x           :  in word;
        y           :  in word;
        z           : out word;

        cin         :  in std_logic;
        cout        : out std_logic;
        ovf         : out std_logic
    );
end entity;

architecture behavioral of adder is
    type sresult is record
        z    : word;
        cout : std_logic;
        ovf  : std_logic;
    end record sresult;

    function sadd(x,y:std_logic_vector;c:std_logic) return sresult is
        variable a  : sresult;
        variable b  : std_logic_vector(2 downto 0);
    begin
        a.z := conv_std_logic_vector(ieee.std_logic_signed.conv_integer(x)+ieee.std_logic_signed.conv_integer(y)+conv_integer(c),16);
        b  := a.z(15) & x(15) & y(15);
        case b is
            when "001"  => a.cout := '1'; a.ovf := '0';
            when "010"  => a.cout := '1'; a.ovf := '0';
            when "011"  => a.cout := '1'; a.ovf := '1';
            when "100"  => a.cout := '0'; a.ovf := '1';
            when "111"  => a.cout := '1'; a.ovf := '0';
            when others => a.cout := '0'; a.ovf := '0';
        end case;

        return a;
    end sadd;
begin
    adder : process(x,y,cin) is
        variable a : sresult;
    begin
        a    := sadd(x,y,cin);
        z    <= a.z;
        cout <= a.cout;
        ovf  <= a.ovf;
    end process adder;
end architecture;
