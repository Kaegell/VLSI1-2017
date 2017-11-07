
LIBRARY ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

entity adder_tb is
end entity;

architecture arch of adder_tb is
signal op1      : std_logic_vector(3 downto 0);
signal op2      : std_logic_vector(3 downto 0);
signal result   : std_logic_vector(3 downto 0);
begin

-- Testee instanciation
instance : entity work.adder
port map ( op1    => op1,
           op2    => op2,
           result => result);

-- Stimuli generation
process is
  variable v_op1 : natural;
  variable v_op2 : natural;
begin
  for v_op1 in 0 to 15 loop
    for v_op2 in 0 to 15 loop
      op1 <= std_logic_vector(to_unsigned(v_op1, op1'length));
      op2 <= std_logic_vector(to_unsigned(v_op2, op2'length));
      wait for 10 ns;

      -- Testing validity of the result
      assert to_integer(unsigned(result)) = (v_op1 + v_op2) mod 16
        report "Error : "
        & integer'image(v_op1)
        & " + "
        & integer'image(v_op2)
        & " = "
        & integer'image(to_integer(unsigned(result)));

    end loop;
  end loop;
end process;

end arch;

