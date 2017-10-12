LIBRARY IEEE;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Alu IS
	PORT(op1	: IN	STD_LOGIC_VECTOR (31 DOWNTO 0);
		op2		: IN	STD_LOGIC_VECTOR (31 DOWNTO 0);
		cin		: IN	STD_LOGIC;
		
		cmd		: IN	STD_LOGIC_VECTOR (1 DOWNTO 0);

		res		: OUT	STD_LOGIC_VECTOR (31 DOWNTO 0);
		cout	: OUT	STD_LOGIC;
		z		: OUT	STD_LOGIC;
		n		: OUT	STD_LOGIC;
		v		: OUT	STD_LOGIC;

		vdd		: IN	BIT;
		vss		: IN	BIT);
END Alu;

ARCHITECTURE Alu OF Alu IS
	SIGNAL res_sig :	STD_LOGIC_VECTOR (32 DOWNTO 0);
	SIGNAL op1_sig :	STD_LOGIC_VECTOR (32 DOWNTO 0);
	SIGNAL op2_sig :	STD_LOGIC_VECTOR (32 DOWNTO 0);

BEGIN
	op1_sig <= STD_LOGIC_VECTOR (RESIZE(SIGNED(op1), op1_sig'LENGTH));
	op2_sig <= STD_LOGIC_VECTOR (RESIZE(SIGNED(op2), op2_sig'LENGTH));

	res_sig <= STD_LOGIC_VECTOR (SIGNED(op1_sig) + 
			   SIGNED(op2_sig) + (""&cin))			WHEN cmd = "00" ELSE
				op1		AND		op2					WHEN cmd = "01" ELSE
				op1		OR		op2					WHEN cmd = "10" ELSE
				op1		XOR		op2					WHEN cmd = "11";

	cout	<= res_sig (32) WHEN cmd = "00";
	res		<= res_sig (31 DOWNTO 0);
	z		<= '1' WHEN UNSIGNED(res_sig) = 0 ELSE '0';
	n		<= res_sig(31);
	v		<= (NOT(op1_sig(31)) AND NOT(op2_sig(31))) AND res_sig(31);
END Alu;
