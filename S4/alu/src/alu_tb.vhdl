LIBRARY IEEE;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.MATH_REAL.ALL;

ENTITY alu_tb IS
END ENTITY;


ARCHITECTURE alu_tb OF alu_tb IS
	SIGNAL op1	:		STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL op2	:		STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL cin	:		STD_LOGIC;
	SIGNAL cmd	:		STD_LOGIC_VECTOR (1 DOWNTO 0);
	
	SIGNAL res	:		STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL cout :		STD_LOGIC;
	SIGNAL z	:		STD_LOGIC;
	SIGNAL n	:		STD_LOGIC;
	SIGNAL v	:		STD_LOGIC;


	COMPONENT Alu IS
		PORT(
			op1	: IN	STD_LOGIC_VECTOR (31 DOWNTO 0);
			op2	: IN	STD_LOGIC_VECTOR (31 DOWNTO 0);
			cin	: IN	STD_LOGIC;
			
			cmd	: IN	STD_LOGIC_VECTOR (1 DOWNTO 0);

			res	: OUT	STD_LOGIC_VECTOR (31 DOWNTO 0);
			cout: OUT	STD_LOGIC;
			z	: OUT	STD_LOGIC;
			n	: OUT	STD_LOGIC;
			v	: OUT	STD_LOGIC;

			vdd	: IN	BIT;
			vss	: IN	BIT);
	END COMPONENT;
BEGIN
	ALU1		:	Alu PORT MAP(
					op1 => op1,
					op2 => op2,
					cin => cin,
					cmd => cmd,
					res => res,
					cout=> cout,
					z	=> z,
					n	=> n,
					v	=> v,
					vdd => '1',
					vss => '0');
	PROCESS
		VARIABLE seed1, seed2	: POSITIVE;
		VARIABLE rand			: REAL;
		VARIABLE randu			: INTEGER;
	BEGIN
		REPORT "STARTING TEST BENCH";
		cmd <= "00";
		cin <= '0';
		WAIT FOR 5 ns;

		UNIFORM(seed1, seed2, rand);
		randu := INTEGER(TRUNC(rand*4096.0));
		op1 <= STD_LOGIC_VECTOR(TO_UNSIGNED(randu,op1'LENGTH));
		WAIT FOR 5 ns;

		UNIFORM(seed1, seed2, rand);
		randu := INTEGER(TRUNC(rand*4096.0));
		op2 <= STD_LOGIC_VECTOR(TO_UNSIGNED(randu,op2'LENGTH));
		WAIT FOR 5 ns;
		REPORT "/******** OPERATORS ********/";
		REPORT "op1 = " & INTEGER'IMAGE(TO_INTEGER(UNSIGNED(op1)));
		REPORT "op2 = " & INTEGER'IMAGE(TO_INTEGER(UNSIGNED(op2)));
		REPORT "cin = " & STD_LOGIC'IMAGE(cin);
		FOR i IN 0 TO 3 LOOP
			cmd <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, cmd'LENGTH));
			WAIT FOR 10 ns;
			REPORT "/*** CMD = " & INTEGER'IMAGE(TO_INTEGER(UNSIGNED(cmd))) & "***/";
			REPORT "res = " & INTEGER'IMAGE(TO_INTEGER(UNSIGNED(res)));
			REPORT "cout= " & STD_LOGIC'IMAGE(cout); 
			REPORT "z = " & STD_LOGIC'IMAGE(z);
			REPORT "n = " & STD_LOGIC'IMAGE(n);
			REPORT "v = " & STD_LOGIC'IMAGE(v);
		END LOOP;
		WAIT;
	END PROCESS;
END ARCHITECTURE;
