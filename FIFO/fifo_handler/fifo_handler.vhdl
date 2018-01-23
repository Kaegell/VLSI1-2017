library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_handler is
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
end entity;

architecture arch of fifo_handler is
  signal already_pushed   : std_logic;
  signal must_push        : std_logic;
  signal must_pop         : std_logic;
  signal can_push         : std_logic;
  signal can_pop          : std_logic;
  signal s_push           : std_logic;
  signal s_pop            : std_logic;

  type state_type is (NoWait, WaitForPush, WaitForPop);
  signal cur_state, next_state : state_type;
begin

  -- =========================== Moore State Machine =============================
  ---- Transition combinatory circuit [ next_state = f(cur_state, inputs) ]
  process(s_push, s_pop, i_pushes)
  begin
    case cur_state is

      -- NoWait
      when NoWait =>
        if (i_pushes = '0') or (i_pushes = '1' and s_push = '1' and s_pop = '1') then
          next_state <= NoWait;
        elsif i_pushes = '1' and s_push = '1' and s_pop = '0' then
          next_state <= WaitForPop;
        else -- i_pushes = '1' and s_push = '0'
          next_state <= WaitForPush;
        end if;

      -- WaitForPush
      when WaitForPush =>
        if s_push = '1' and s_pop = '0' then
          next_state <= WaitForPop;
        elsif s_push = '1' and s_pop = '1' then
          next_state <= NoWait;
        else -- push = '0'
          next_state <= WaitForPush;
        end if;

      -- WaitForPop
      when WaitForPop =>
        if s_pop = '1' then
          next_state <= NoWait;
        else -- pop = '0'
          next_state <= WaitForPop;
        end if;

    end case;
  end process;

  ---- Main D-Latch [ cur_state -> next_state ]
  process (ck)
  begin
    if (rising_edge(ck)) then
      if (reset_n = '0') then
        cur_state <= WaitForPop;
      else
        cur_state <= next_state;
      end if;
    end if;
  end process;

  ---- Output generation [ output = f(cur_state) ]
  process (cur_state)
  begin
    case cur_state is
      when NoWait =>
        already_pushed  <= '0';
        i_stagnant      <= '0';
      when WaitForPush =>
        already_pushed  <= '0';
        i_stagnant      <= '1';
      when WaitForPop =>
        already_pushed  <= '1';
        i_stagnant      <= '1';
    end case;
  end process;

  -- ========================= Outputs ===============================
  can_push  <= not full;
  must_push <= i_pushes and (not already_pushed);
  can_pop   <= not empty;
  must_pop  <= s_push or (not must_push);

  s_pop     <= must_pop and can_pop;
  s_push    <= must_push and can_push;

  push      <= s_push;
  pop       <= s_pop;

end architecture;
