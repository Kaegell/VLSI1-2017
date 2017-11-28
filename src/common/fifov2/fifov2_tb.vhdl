
library   ieee;
use       ieee.std_logic_1164.all;
use       ieee.numeric_std.all;
use       ieee.math_real.all;

entity    fifov2_tb is
end entity;

architecture arch of fifov2_tb is

  -- Bool_to_logic()
  function bool_to_logic(x : boolean)
  return std_logic is
  begin
    if x then
      return('1');
    else
      return('0');
    end if;
  end bool_to_logic;

  signal din       : std_logic_vector(71 downto 0);
  signal dout      : std_logic_vector(71 downto 0);

  signal push      : std_logic;
  signal pop       : std_logic;

  signal full      : std_logic;
  signal empty     : std_logic;

  signal reset_n   : std_logic;
  signal ck        : std_logic;
  signal vdd       : std_logic;
  signal vss       : std_logic;

  -- ==================== UUT Declaration ====================
  component fifov2
  port (din       : in  std_logic_vector(71 downto 0);
        dout      : out std_logic_vector(71 downto 0);

        push      : in  std_logic;
        pop       : in  std_logic;

        full      : out std_logic;
        empty     : out std_logic;

        reset_n   : in  std_logic;
        ck        : in  std_logic;
        vdd       : in  std_logic;
        vss       : in  std_logic
      );
  end component;
begin

  -- ==================== UUT Instanciation ====================
  fifov2_inst : fifov2
  port map (
        din       => din,
        dout      => dout,

        push      => push,
        pop       => pop,

        full      => full,
        empty     => empty,

        reset_n   => reset_n,
        ck        => ck,
        vdd       => vdd,
        vss       => vss);

  -- =================== Stimuli generation ===================
 
end architecture;

