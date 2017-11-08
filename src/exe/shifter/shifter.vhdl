
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

entity shifter is
  port( shift_lsl     : in std_logic;
        shift_lsr     : in std_logic;
        shift_asr     : in std_logic;
        shift_ror     : in std_logic;
        shift_rrx     : in std_logic;
        shift_val     : in std_logic_vector(4 downto 0);

        din           : in std_logic_vector(31 downto 0);
        cin           : in std_logic;
        
        dout          : out std_logic_vector(31 downto 0);
        cout          : out std_logic;

        vdd           : in bit;
        vss           : in bit);
end shifter;

architecture arch of shifter is
signal sel      : std_logic_vector(4 downto 0);
signal lsl_dout : std_logic_vector(31 downto 0);
signal lsr_dout : std_logic_vector(31 downto 0);
signal asr_dout : std_logic_vector(31 downto 0);
signal ror_dout : std_logic_vector(31 downto 0);
signal rrx_dout : std_logic_vector(31 downto 0);
signal lsl_cout : std_logic;
signal lsr_cout : std_logic;
signal asr_cout : std_logic;
signal ror_cout : std_logic;
signal rrx_cout : std_logic;
begin

  inst_lsl : entity work.shift_lsl
  port map(din, cin, shift_val, lsl_dout, lsl_cout);

  inst_lsr : entity work.shift_lsr
  port map(din, cin, shift_val, lsr_dout, lsr_cout);

  inst_asr : entity work.shift_asr
  port map(din, cin, shift_val, asr_dout, asr_cout);

  inst_ror : entity work.shift_ror
  port map(din, cin, shift_val, ror_dout, ror_cout);

  inst_rrx : entity work.shift_rrx
  port map(din, cin, rrx_dout, rrx_cout);

  sel   <= shift_rrx & shift_ror & shift_asr & shift_lsr & shift_lsl;

  with sel select
  dout  <= lsl_dout  when "00001",
           lsr_dout  when "00010",
           asr_dout  when "00100",
           ror_dout  when "01000",
           rrx_dout  when "10000",
           x"00000000" when others;

  with sel select
  cout  <= lsl_cout  when "00001",
           lsr_cout  when "00010",
           asr_cout  when "00100",
           ror_cout  when "01000",
           rrx_cout  when "10000",
           '0'       when others;

end arch;

