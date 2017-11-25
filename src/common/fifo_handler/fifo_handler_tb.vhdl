
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     ieee.math_real.all;

entity  fifo_handler_tb is
  end entity;

architecture arch of fifo_handler_tb is

  function bool_to_logic(x : boolean)
  return std_logic is
  begin
    if x then
      return('1');
    else
      return('0');
    end if;
  end bool_to_logic;

  -- intra-stage signals
  signal i_pushes      : std_logic;
  signal i_stagnant    : std_logic;

  -- inter-stage i/o
  signal empty         : std_logic;
  signal full          : std_logic;
  signal push          : std_logic;
  signal pop           : std_logic;

  -- global interface
  signal ck					  : std_logic;
  signal reset_n			  : std_logic;
  signal vdd				    : bit;
  signal vss				    : bit;

  -- =================== UUT Declaration ===================================
  component fifo_handler
    port (
           -- intra-stage signals
           i_pushes      : in   std_logic;
           i_stagnant    : out  std_logic;

           -- inter-stage i/o
           empty         : in   std_logic;
           full          : in   std_logic;
           push          : out  std_logic;
           pop           : out  std_logic;

           -- global interface
           ck					  : in    std_logic;
           reset_n			: in    std_logic;
           vdd				  : in    bit;
           vss				  : in    bit);
  end component;
begin

  -- ================ UUT Instanciation ====================================
  fifo_handler_inst : fifo_handler
  port map (
             i_pushes    => i_pushes,
             i_stagnant  => i_stagnant,
             empty       => empty,
             full        => full,
             push        => push,
             pop         => pop,
             ck          => ck,
             reset_n     => reset_n,
             vdd         => vdd,
             vss         => vss);

  -- ================== Stimuli Generation =================================
  -- This process reproduces the inputs from the chronogramms in
  -- doc/chrono_tb_fifo_handler.pdf

  process
    variable v_i_pushes : boolean;
    variable v_empty : boolean;
    variable v_full : boolean;
  begin
    -- =================== Chronogramm 1 : Normal case ====================
    -- Iniialization
    reset_n   <= '0';
    i_pushes  <= '1';
    empty     <= '0';
    full      <= '0';
    ck        <= '0';

    wait for 50 ps;
    ck        <= '0';
    wait for 50 ps;
    ck        <= '1';

    reset_n   <= '1';

    for i in 0 to 30 loop
      -- Assign chronogram values to variables 
      v_i_pushes := (    i = 0
      or  i = 1
      or  i = 2
      or  i = 5
      or  i = 7
      or  i = 8
      or  i = 11
      or  i = 15
      or  i = 16
      or  i = 17
      or  i > 19);
      v_empty := false;
      v_full := false;

      -- Assign variables to signals
      i_pushes  <= bool_to_logic(v_i_pushes);
      empty     <= bool_to_logic(v_empty);
      full      <= bool_to_logic(v_full);
      reset_n   <= '1';

      -- Clock generation
      wait for 50 ps;
      ck  <= '0';
      wait for 50 ps;
      ck  <= '1';
    end loop;

    -- =================== Chronogramm 2 : FIFO out is full ====================
    -- Iniialization
    reset_n   <= '0';
    i_pushes  <= '1';
    empty     <= '0';
    full      <= '0';
    ck        <= '0';

    wait for 50 ps;
    ck        <= '0';
    wait for 50 ps;
    ck        <= '1';

    reset_n   <= '1';

    for i in 0 to 30 loop
      -- Assign chronogram values to variables
      v_i_pushes := true;
      v_empty := false;
      v_full := (i > 2 and i < 13);

      -- Assign variables to signals
      i_pushes  <= bool_to_logic(v_i_pushes);
      empty     <= bool_to_logic(v_empty);
      full      <= bool_to_logic(v_full);
      reset_n   <= '1';

      -- Clock generation
      wait for 50 ps;
      ck  <= '0';
      wait for 50 ps;
      ck  <= '1';
    end loop;

    -- =================== Chronogramm 3 : FIFO in is empty ====================
    -- Iniialization
    reset_n   <= '0';
    i_pushes  <= '1';
    empty     <= '0';
    full      <= '0';
    ck        <= '0';

    wait for 50 ps;
    ck        <= '0';
    wait for 50 ps;
    ck        <= '1';

    reset_n   <= '1';

    for i in 0 to 30 loop
      -- Assign chronogram values to variables
      v_i_pushes := true;
      v_empty := (i > 3 and i < 15);
      v_full := false;

      -- Assign variables to signals
      i_pushes  <= bool_to_logic(v_i_pushes);
      empty     <= bool_to_logic(v_empty);
      full      <= bool_to_logic(v_full);
      reset_n   <= '1';

      -- Clock generation
      wait for 50 ps;
      ck  <= '0';
      wait for 50 ps;
      ck  <= '1';
    end loop;

    -- =================== Chronogramm 4 : Yet another case of FIFO out full ===============
    -- Iniialization
    reset_n   <= '0';
    i_pushes  <= '1';
    empty     <= '0';
    full      <= '0';
    ck        <= '0';

    wait for 50 ps;
    ck        <= '0';
    wait for 50 ps;
    ck        <= '1';

    reset_n   <= '1';

    for i in 0 to 30 loop
      -- Assign chronogram values to variables
      v_i_pushes := ( i = 0
      or i = 1
      or i = 2
      or i = 5
      or i = 6
      or i = 1
      or (i > 9 and i < 18));
      v_empty := false;
      v_full := (i > 10 and i < 17);

      -- Assign variables to signals
      i_pushes  <= bool_to_logic(v_i_pushes);
      empty     <= bool_to_logic(v_empty);
      full      <= bool_to_logic(v_full);
      reset_n   <= '1';

      -- Clock generation
      wait for 50 ps;
      ck  <= '0';
      wait for 50 ps;
      ck  <= '1';
    end loop;

    wait;
  end process;

end arch;

