-------------------------------------------------------------------------------
-- File:    kurm/memory.vhd
-- Author:  Wesley Peck
-- Date:    1 January 2008
-- Desc:    This file contains the definition of the KURM memory controller.
--          This memory controller makes use of a simple protocol and uses
--          a block ram backed memory store. The memory controller is a
--          dual ported controller which is capable of performing a read
--          or write on both ports each clock cycle.
--
--          In order to use the memory initialization and memory dumping
--          functions you must set values for the generic INPUT and OUTPUT.
--          The INPUT generic names a file in the filesystem for use as the
--          initial values for the memory. The generic OUTPUT names a file
--          in the filesystem to which the contents of the memory are dumped
--          when dump signal is strobed.
--
--          The two files INPUT and OUTPUT have the same format for the
--          contents. The format depends on the generic SIZE which defines
--          the number of bytes available in the memory. The format on the
--          INPUT and OUTPUT files is as follows:
--              1). Each line defines a memory location
--              2). Memory locations start from 0 and go through SIZE-1
--              3). Each line must be exactly 16-bits
--              4). There must be exactly SIZE lines in the file
--
--          For example, the following declares memory location 0 to have
--          the value 0, the memory location 1 to have the value 1, etc.
--          In this example, size is 256:
--              0000000000000000
--              0000000000000001
--              0000000000000010
--              0000000000000011
--              0000000000000100
--              ...
--              0000000011111110
--              0000000011111111
-------------------------------------------------------------------------------
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

library kurm;
use kurm.common.all;

entity memory is
    generic
    (
        SIZE        : natural   := 256;
        SPEED       : time      := 5 ns;
        SIMULATE    : boolean   := true;
        INPUT       : string    := "";
        OUTPUT      : string    := ""
    );
    port
    (
        clk         :  in std_logic;

        datain1     :  in word          := (others => '0');
        datain2     :  in word          := (others => '0');

        dataout1    : out word          := (others => '0');
        dataout2    : out word          := (others => '0');

        ready1      : out std_logic     := '0';
        ready2      : out std_logic     := '0';

        address1    :  in word          := (others => '0');
        address2    :  in word          := (others => '0');

        rd1         :  in std_logic     := '0';
        rd2         :  in std_logic     := '0';

        wr1         :  in std_logic     := '0';
        wr2         :  in std_logic     := '0';

        dump        : in std_logic      := '0'
    );
end entity memory;

architecture behavioral of memory is
    type memory is array(0 to SIZE/2-1) of byte;

    impure function initram(path : in string; low : in boolean ) return memory is
        file     ramfile    : text is in path;
        variable ramline    : line;
        variable input      : bit_vector( datain1'range );
        variable ram        : memory;
    begin
        if( path'length = 0 ) then
            return ram;
        end if;

        for row in memory'range loop
            readline( ramfile, ramline );
            read( ramline, input );
            if( low ) then
                ram(row) := to_stdlogicvector(input(7 downto 0));
            else
                ram(row) := to_stdlogicvector(input(15 downto 8));
            end if;
        end loop;
        return ram;
    end function;

    procedure dumpram(path : in string; low : in memory; high : in memory ) is
        file     output  : text open WRITE_MODE is path;
        variable ramline : line;
        variable value   : bit_vector( datain1'range );
    begin
        for row in memory'range loop
            value := to_bitvector(high(row)) & to_bitvector(low(row));
            write( ramline, value );
            writeline( output, ramline );
        end loop;
    end procedure;

    signal sel1         : std_logic;
    signal sel2         : std_logic;

    signal raddr1_low   : word;
    signal raddr1_high  : word;
    signal raddr2_low   : word;
    signal raddr2_high  : word;

    signal addr1_low    : word;
    signal addr1_high   : word;
    signal addr2_low    : word;
    signal addr2_high   : word;

    signal dout1_low    : byte;
    signal dout1_high   : byte;
    signal dout2_low    : byte;
    signal dout2_high   : byte;

    signal din1_low     : byte;
    signal din1_high    : byte;
    signal din2_low     : byte;
    signal din2_high    : byte;

    shared variable store_low   : memory := initram(INPUT,true);
    shared variable store_high  : memory := initram(INPUT,false);
begin
    assert  SIZE rem 2 = 0
        report "The size of the memory is not an even number. This is probably not what you want. To fix this warning find the entity instantiation for the memory and change the generic parameter SIZE to be an even number."
        severity warning;

    addr1_low   <= ("0" & address1(15 downto 1));
    addr1_high  <= ("0" & address1(15 downto 1)) + address1(0);
    addr2_low   <= ("0" & address2(15 downto 1));
    addr2_high  <= ("0" & address2(15 downto 1)) + address1(0);

    dout1_low   <= store_low( conv_integer(raddr1_low) );
    dout1_high  <= store_high( conv_integer(raddr1_high) );

    dout2_low   <= store_low( conv_integer(raddr2_low) );
    dout2_high  <= store_high( conv_integer(raddr2_high) );

    dataout1    <= dout1_high&dout1_low when sel1='0' else dout1_low&dout1_high;
    dataout2    <= dout2_high&dout2_low when sel2='0' else dout2_low&dout2_high;

    din1_low    <= datain1(7 downto 0) when address1(0)='0' else datain1(15 downto 8);
    din1_high   <= datain1(15 downto 8) when address1(0)='0' else datain1(7 downto 0);
    din2_low    <= datain2(7 downto 0) when address2(0)='0' else datain2(15 downto 8);
    din2_high   <= datain2(15 downto 8) when address2(0)='0' else datain2(7 downto 0);

    memory_porta : process( clk ) is
    begin
        if( rising_edge(clk) ) then
            ready1 <= '0';
            if( wr1 = '1' or rd1 = '1' ) then
                if( wr1 = '1' ) then
                    store_low( conv_integer(addr1_low) )    := din1_low;
                    store_high( conv_integer(addr1_high) )  := din1_high;
                end if;

                ready1  <= '1';
                raddr1_low <= addr1_low;
                raddr1_high <= addr1_high;
                sel1    <= address1(0);
            end if;
        end if;
    end process memory_porta;

    memory_portb : process( clk ) is
    begin
        if( rising_edge(clk) ) then
            ready2 <= '0';
            if( wr2 = '1' or rd2 = '1' ) then
                if( wr2 = '1' ) then
                    store_low( conv_integer(addr2_low) )    := din2_low;
                    store_high( conv_integer(addr2_high) )  := din2_high;
                end if;

                ready2  <= '1';
                raddr2_low <= addr2_low;
                raddr2_high <= addr2_high;
                sel2    <= address2(0);
            end if;
        end if;
    end process memory_portb;

    simulating : if( SIMULATE = true ) generate
        dump_ram : process(dump) is
        begin
            if( rising_edge(dump) ) then
                dumpram( OUTPUT, store_low, store_high );
            end if;
        end process dump_ram;
    end generate simulating;
end architecture behavioral;
