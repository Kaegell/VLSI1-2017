LIBRARY IEEE;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY adder_tb IS
END ENTITY;


ARCHITECTURE adder_tb OF adder_tb IS
	SIGNAL i0	:		STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL i1	:		STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL q	:		STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL ovf	:		STD_LOGIC;

	COMPONENT Adder IS
		PORT (
		i0,i1	:	IN	STD_LOGIC_VECTOR (3 DOWNTO 0);
		q		:	OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		ovf		:	OUT STD_LOGIC);
	END COMPONENT;
BEGIN
	ADD1		:	Adder PORT MAP(
					i0 => i0,
					i1 => i1,
					q  => q,
					ovf=> ovf);
	PROCESS
	BEGIN
		REPORT "STARTING TEST BENCH";
		i0 <= "0000";
		i1 <= "0000";
		WAIT FOR 5 ns;
		FOR i IN 0 TO 15 LOOP
			FOR j IN 0 TO 15 LOOP
				REPORT "/********** IT" & INTEGER'IMAGE(i+j) & "*********/";
				i0 <= STD_LOGIC_VECTOR(TO_UNSIGNED(i,i0'LENGTH));
				i1 <= STD_LOGIC_VECTOR(TO_UNSIGNED(j,i1'LENGTH));
				REPORT "i0 = " & INTEGER'IMAGE(TO_INTEGER(UNSIGNED(i0)));
				REPORT "i1 = " & INTEGER'IMAGE(TO_INTEGER(UNSIGNED(i1)));
				ASSERT ovf = '0' REPORT "OVERFLOW ";
				WAIT FOR 5 ns;
			END LOOP;
		END LOOP;
		WAIT;
	END PROCESS;
END adder_tb;
