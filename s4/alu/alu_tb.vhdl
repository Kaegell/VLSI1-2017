
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     ieee.math_real.all;

entity alu_tb is
  end entity;

architecture arch of alu_tb is
  signal op1      : std_logic_vector(31 downto 0);
  signal op2      : std_logic_vector(31 downto 0);
  signal cin      : std_logic;
  signal cmd      : std_logic_vector(1 downto 0);
  signal res      : std_logic_vector(31 downto 0);
  signal cout     : std_logic;
  signal z        : std_logic;
  signal n        : std_logic;
  signal v        : std_logic;
  signal vdd      : bit;
  signal vss      : bit;
begin

  -- ============================== Entity instanciation ============================== 
  instance:entity work.alu
  port map(op1, op2, cin, cmd, res, cout, z, n, v, vdd, vss);

  -- ============================== Stimuli generation ============================== 
  process
    variable v_op1 : integer;
    variable v_op2 : integer;
    variable v_cmd : integer;
    variable v_cin : integer;
    variable seed1 : positive;
    variable seed2 : positive;
    variable rand  : real;
    variable rmin  : real;
    variable rmax  : real;
  begin
    cmd <= "00";
    rmin := Real(integer'low);
    rmax := Real(integer'high);
    -- Make 5 test loops, each one with a different operation tested
    for i in 0 to 4 loop
      -- Make 10 tests, each one with different random inputs tested
      for j in 0 to 9 loop
        -- Generate the random variables
        uniform(seed1, seed2, rand); -- generate a seed for rand to work
        v_op1 := integer(rmin + rand*(rmax-rmin));
        uniform(seed1, seed2, rand);
        v_op2 := integer(rmin + rand*(rmax-rmin));
        uniform(seed1, seed2, rand);
        v_cin := integer(rand); -- ISN'T IT ALWAYS 0 (TRUNCATURE) ?

        -- Convert variables into real signals
        op1 <= std_logic_vector(to_signed(v_op1, op1'length));
        op2 <= std_logic_vector(to_signed(v_op2, op2'length));
        cin <= std_logic(to_unsigned(v_cin, 1)(0));

        -- Wait for the signals to propagate
        wait for 10 ps; 

        -- ======================== Auto-test the results ===========================
        v_cmd := to_integer(unsigned(cmd));
        assert ( --Test ADDITION
                 (
                   (v_cmd = 0)
                   and
                   (to_integer(signed(res)) = (v_op1 + v_op2 + v_cin))
                 )
                 or v_cmd /= 0
               )
        report "Addition failed";
        assert ( --Test AND operation
                 (
                   (v_cmd = 1)
                   and
                   (to_integer(signed(res)) = to_integer(signed(op1 and op2)))
                 )
                 or v_cmd /= 1
               )
        report "AND failed";
        assert ( --Test OR operation
                 (
                   (v_cmd = 2)
                   and
                   (to_integer(signed(res)) = to_integer(signed(op1 or op2)))
                 )
                 or v_cmd /= 2
               )
        report "OR failed";
        assert ( --Test XOR operation
                 (
                   (v_cmd = 3)
                   and
                   (to_integer(signed(res)) = to_integer(signed(op1 xor op2)))
                 )
                 or v_cmd /= 3
               )
        report "XOR failed";
        -- Test vflag
        assert ( --Test v flag
                 (
                   (v_cmd = 0)
                   and
                   (
                     (
                       ((v_op1 > 0) xor (v_op2 > 0)) -- sgn(op1) != sgn(op2)
                       and
                       v = '0'                       -- there is no overflow
                     )
                     or
                     (
                       ((v_op1 > 0) xor (v_op2 < 0)) -- sgn(op1) == sgn(op2)
                       and                           -- res is of same sign too
                       ((v_op1 > 0) xor (to_integer(signed(res)) < 0)) 
                       and
                       v = '0'                       -- there is no overflow
                     )
                     or
                     (
                       ((v_op1 > 0) xor (v_op2 < 0)) -- sgn(op1) == sgn(op2)
                       and                           -- res is of different sign
                       ((v_op1 > 0) xor (to_integer(signed(res)) > 0))
                       and
                       v = '1'                       -- there is indeed overflow
                     )
                   )
                 )
                 or v_cmd /= 0
               )
        report "Wrong v flag";
        -- Test c flag
        -- ============================ End of auto-test ===========================
      end loop;
      -- Go to the next operation
      cmd <= std_logic_vector(unsigned(cmd) + to_unsigned(1, cmd'length )); 
    end loop;
    wait;
  end process;
end arch;
