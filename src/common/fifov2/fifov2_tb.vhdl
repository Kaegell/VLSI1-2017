
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

  signal debug_head : std_logic_vector(3 downto 0);
  signal debug_tail : std_logic_vector(3 downto 0);
  signal debug_size : std_logic_vector(3 downto 0);

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

        debug_head : out std_logic_vector(3 downto 0);
        debug_tail : out std_logic_vector(3 downto 0);
        debug_size : out std_logic_vector(3 downto 0);

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

        debug_head => debug_head,
        debug_tail => debug_tail,
        debug_size => debug_size,

        reset_n   => reset_n,
        ck        => ck,
        vdd       => vdd,
        vss       => vss);

  -- =================== Stimuli generation ===================
  process
    variable v_din :  integer := 0;
    variable v_push : boolean := false;
    variable v_pop :  boolean := false;
  begin
    -- ================ Chronogramm 1 ================
    -- Clock cycle
    reset_n <= '0';
    push <= '0';
    pop <= '0';
    wait for 50 ps;
    ck <= '0';
    wait for 50 ps;
    ck <= '1';
    --wait for 50 ps;
    --ck <= '0';
    --wait for 50 ps;
    --ck <= '1';
    reset_n <= '1';

    for i in 0 to 20 loop
      -- Generate variable values
      v_din := 10 + i;
      v_push := (i = 1
      or i = 2
      or i = 3
      or i = 5
      or i = 8
      or i = 9
      or i = 14
      or i = 15
      or i = 16
      or i = 17);
      v_pop := (i = 3
      or i = 4
      or i = 6
      or i = 9
      or i = 10
      or i = 15
      or i = 16);

      -- Assign variables to signals
      din <= std_logic_vector(to_unsigned(v_din, din'length));
      push <= bool_to_logic(v_push);
      pop <= bool_to_logic(v_pop);

      assert false report "cycle";

      -- Clock cycle
      wait for 50 ps;
      ck <= '0';
      wait for 50 ps;
      ck <= '1';
    end loop;

    -- ================ Chronogramm 2 ================
    -- Clock cycle
    reset_n <= '0';
    push <= '0';
    pop <= '0';
    wait for 50 ps;
    ck <= '0';
    wait for 50 ps;
    ck <= '1';
    --wait for 50 ps;
    --ck <= '0';
    --wait for 50 ps;
    --ck <= '1';
    reset_n <= '1';

    for i in 0 to 20 loop
      -- Generate variable values
      v_din := 10 + i;
      v_push := ( (i > 1 and i < 13) );
      v_pop := ( (i > 2 and i < 9)
      or (i > 14 and i < 19));

      -- Assign variables to signals
      din <= std_logic_vector(to_unsigned(v_din, din'length));
      push <= bool_to_logic(v_push);
      pop <= bool_to_logic(v_pop);

      assert false report "cycle";

      -- Clock cycle
      wait for 50 ps;
      ck <= '0';
      wait for 50 ps;
      ck <= '1';
    end loop;
    wait;
  end process;

end arch;

