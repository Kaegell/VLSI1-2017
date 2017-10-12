LIBRARY ieee;
USE ieee.numeric_std.all;
USE ieee.std_logic_1164.all;

ENTITY adder_tb IS
END ENTITY;


ARCHITECTURE bench_arch OF adder_tb IS
	SIGNAL a	:		std_logic_vector (3 downto 0);
	SIGNAL b	:		std_logic_vector (3 downto 0);
	SIGNAL o	:		std_logic_vector (3 downto 0);
	SIGNAL c	:		std_logic;

	COMPONENT adder IS
		PORT (
		i0,i1	:	IN	std_logic_vector (3 downto 0);
		q		:	OUT std_logic_vector (3 downto 0);
		ovf		:	OUT std_logic);
	END COMPONENT;
BEGIN
	ADD1		:	adder PORT MAP(
					i0 =>  a,
					i1 =>  b,
					q  =>  o,
					ovf=> c);
	PROCESS
		VARIABLE str_a : STRING (1 to 2);
		VARIABLE str_b : STRING (1 to 2);
	BEGIN
		REPORT "STARTING TEST BENCH";
		a <= "0000";
		b <= "0000";
		FOR i IN 0 TO 15 LOOP
			FOR j IN 0 TO 15 LOOP
				a <= std_logic_vector(TO_UNSIGNED(i,a'LENGTH));
				b <= std_logic_vector(TO_UNSIGNED(j,b'LENGTH));
				str_a := INTEGER'IMAGE(TO_INTEGER(UNSIGNED(a)));
				str_b := INTEGER'IMAGE(TO_INTEGER(UNSIGNED(b)));
				ASSERT c = '1' REPORT "OVERFLOW " & str_a & " + " & str_b;
				WAIT FOR 5 ns;
			END LOOP;
		END LOOP;
		WAIT;
	END PROCESS;
END bench_arch;
