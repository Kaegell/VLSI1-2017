
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

entity alu is
    port ( op1      : in std_logic_vector(31 downto 0);
           op2      : in std_logic_vector(31 downto 0);
           cin      : in std_logic;

           cmd      : in std_logic_vector(1 downto 0);

           res      : out std_logic_vector(31 downto 0);
           cout     : out std_logic;
           z        : out std_logic;
           n        : out std_logic;
           v        : out std_logic;

           vdd      : in bit;
           vss      : in bit);
end alu;

architecture arch of alu is
signal res_add  : std_logic_vector(32 downto 0);
signal res_and  : std_logic_vector(31 downto 0);
signal res_or   : std_logic_vector(31 downto 0);
signal res_xor  : std_logic_vector(31 downto 0);
signal sig_res  : std_logic_vector(31 downto 0);
begin

res_add <= std_logic_vector(unsigned('0'&op1) + unsigned('0'&op2)
           + unsigned'("0000000000000000000000000000000"&cin));
res_and <= op1 AND op2;
res_or  <= op1 OR op2;
res_xor <= op1 XOR op2;

with cmd select
sig_res <= res_add(31 downto 0) when "00",
           res_and              when "01",
           res_or               when "10",
           res_xor              when "11",
           x"00000000"          when others;

cout <= res_add(32);
-- There is a signed overflow if
-- the two operand are of same sign
-- and result of different sign
v    <= (op1(31) and op2(31) and not res_add(31))
        or
        ((not op1(31)) and (not op2(31)) and res_add(31));
res  <= sig_res;
n    <= sig_res(31);
with sig_res select
z    <= '1'  when x"00000000",
        '0'  when others;
end arch;

