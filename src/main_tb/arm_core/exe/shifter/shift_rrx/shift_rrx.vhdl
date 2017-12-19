
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

entity shift_rrx is
  port( din           : in std_logic_vector(31 downto 0);
        cin           : in std_logic;

        dout          : out std_logic_vector(31 downto 0);
        cout          : out std_logic);
end shift_rrx;

architecture arch of shift_rrx is

begin
  dout  <= cin & din(31 downto 1);
  cout  <= din(0);
end arch;

