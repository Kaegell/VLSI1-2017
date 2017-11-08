
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     ieee.math_real.all;

entity shifter_tb is
  end entity;

architecture arch of shifter_tb is
signal shift_lsl     : std_logic;
signal shift_lsr     : std_logic;
signal shift_asr     : std_logic;
signal shift_ror     : std_logic;
signal shift_rrx     : std_logic;
signal shift_val     : std_logic_vector(4 downto 0);

signal din           : std_logic_vector(31 downto 0);
signal cin           : std_logic;

signal dout          : std_logic_vector(31 downto 0);
signal cout          : std_logic;
signal vdd           : bit;
signal vss           : bit;

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

-- ==================== ENTITY INSTANCIATION ====================
  inst : entity work.shifter
  port map( shift_lsl   => shift_lsl,
            shift_lsr   => shift_lsr,
            shift_asr   => shift_asr,
            shift_ror   => shift_ror,
            shift_rrx   => shift_rrx,
            shift_val   => shift_val,

            din           => din,
            cin           => cin,
            dout          => dout,
            cout          => cout,
            vdd           => vdd,
            vss           => vss);

  -- ================== STIMULI GENERATION ====================
  process
    variable v_lsl : boolean;
    variable v_lsr : boolean;
    variable v_asr : boolean;
    variable v_ror : boolean;
    variable v_rrx : boolean;
    variable v_val : integer;
    variable v_din : integer;
    variable v_cin : integer;

    variable seed1 : positive;
    variable seed2 : positive;
    variable rand  : real;
    variable rmin  : real;
    variable rmax  : real;
  begin
    rmin := Real(integer'low);
    rmax := Real(integer'high);
    for i in 0 to 99 loop
      -- Generale random variables
      uniform(seed1, seed2, rand);
      v_lsl := (i mod 5 = 0);
      v_lsr := (i mod 5 = 1);
      v_asr := (i mod 5 = 2);
      v_ror := (i mod 5 = 3);
      v_rrx := (i mod 5 = 4);
      v_val := integer(rand*15.0);
      v_din := integer(rmin + rand*(rmax-rmin));
      v_cin := integer(rand);

      -- Convert variables into signals
      shift_lsl <= bool_to_logic(v_lsl);
      shift_lsr <= bool_to_logic(v_lsr);
      shift_asr <= bool_to_logic(v_asr);
      shift_ror <= bool_to_logic(v_ror);
      shift_rrx <= bool_to_logic(v_rrx);
      
      shift_val <= std_logic_vector(to_unsigned(v_val, shift_val'length));
      din       <= std_logic_vector(to_signed(v_din, din'length));
      cin       <= std_logic(to_unsigned(v_cin, 1)(0));

      -- Wait for the signal to propagate
      wait for 10 ps;
    end loop;
    wait;
  end process;

end arch;
