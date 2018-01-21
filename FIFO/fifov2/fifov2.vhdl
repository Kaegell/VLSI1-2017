
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

entity fifov2 is
  generic ( CAPACITY  : integer := 5;
            LENGTH    : integer := 72
      );
  port (din       : in  std_logic_vector((LENGTH - 1) downto 0);
        dout      : out std_logic_vector((LENGTH - 1) downto 0);

        push      : in  std_logic;
        pop       : in  std_logic;

        full      : out std_logic;
        empty     : out std_logic;

        reset_n   : in  std_logic;
        ck        : in  std_logic;
        vdd       : in  bit;
        vss       : in  bit
      );
end fifov2;

architecture arch of fifov2 is
  type arr is array ((CAPACITY - 1) downto 0)
  of std_logic_vector((LENGTH - 1) downto 0);
  signal fifo : arr;
  signal s_head : std_logic_vector(3 downto 0);
  signal s_tail : std_logic_vector(3 downto 0);
  signal s_size : std_logic_vector(3 downto 0);
  signal old_din : std_logic_vector((LENGTH - 1) downto 0);
  signal old_push : std_logic;
  signal old_pop : std_logic;

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
  variable head : integer range 0 to (CAPACITY - 1);
  variable tail : integer range 0 to (CAPACITY - 1);
  variable size : integer range 0 to CAPACITY;
begin
  if (rising_edge(ck)) then

    old_push <= push;
    old_pop <= pop;
    old_din <= din;

    -- === INITIALIZATION ===
    if (reset_n = '0') then
      -- Reset circular array pointers
      head := 0;
      tail := 0;
      size := 0;
      -- Reset the whole array
      for k in 0 to (CAPACITY - 1) loop
        fifo(k) <= (others => '0');
      end loop;
      -- Reset output
    else
      -- Process core : running the FIFO

      -- === PUSH ===
      if (old_push = '1') then
        fifo(head) <= old_din;
        if (head < CAPACITY - 1) then
          head := (head + 1);
        else
          head := 0;
        end if;
        size := size + 1;
      end if;

      -- === POP ===
      if (old_pop = '1') then
        if (tail < CAPACITY - 1) then
          tail := (tail + 1);
        else
          tail := 0;
        end if;
        size := size - 1;
      end if;
    end if;
    -- === Outputs ===
    s_head <= std_logic_vector(to_unsigned(head, s_head'length));
    s_tail <= std_logic_vector(to_unsigned(tail, s_tail'length));
    s_size <= std_logic_vector(to_unsigned(size, s_size'length));

  end if;
end process;

dout <= fifo(to_integer(unsigned(s_tail)));
    -- We consider the FIFO full if we can't push
    -- In other words, if after a hypothetical push,
    -- the case pointed by the tail would be overwritten
full <= bool_to_logic(s_size = std_logic_vector(
        to_unsigned(CAPACITY, s_size'length)) and pop = '0');
    -- We consider the FIFO empty if we can't pop
    -- In other words, if after a hypothetical pop,
    -- the tail would point to an empty slot
empty <= bool_to_logic(s_size = "0000" or (s_size = "0001" and push = '0'));
end arch;
