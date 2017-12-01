
library ieee;
use     ieee.std_logic_1164.all;

entity fifov2 is
  generic ( SIZE  : integer := 5
      );
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
end fifov2;

architecture arch of fifov2 is
  type arr is array (0 to (SIZE - 1)) of std_logic_vector(71 downto 0);
  signal fifo : arr;

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

begin

process (ck)
  variable head : integer;
  variable tail : integer;
  variable size : integer;
begin
  if (rising_edge(ck)) then

    -- === INITIALIZATION ===
    if (reset_n = '0') then
      -- Reset circular array pointers
      head := 0;
      tail := 0;
      size := 0;
      -- Reset the whole array
      for i in 0 to (SIZE - 1) loop
        fifo(i) <= (others => '0');
      end loop;
      -- Reset output
      full <= '0';
      empty <= '1';
    else
      -- Process core : running the FIFO

      -- === PUSH ===
      if (push = '1') then
        fifo(head) <= din;
        head := (head + 1) mod SIZE;
        size := size + 1;
      end if;

      -- === POP ===
      if (pop = '1') then
        tail := (tail + 1) mod SIZE; 
        size := size - 1;
      end if;

      -- === Outputs ===
      dout <= fifo(tail);
      full <= bool_to_logic(size = SIZE);
      -- We consider the FIFO empty if we can't pop
      -- In other words, if after a hypothetical pop,
      -- the tail would point to an empty slot
      empty <= bool_to_logic((size = 0) or (size = 1 and push = '0'));
    end if;
  end if;
end process;
end architecture;
