LIBRARY IEEE;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Shifter IS
	PORT(shift_lsl	: IN	STD_LOGIC;
		shift_lsr	: IN	STD_LOGIC;
		shift_asr	: IN	STD_LOGIC;
		shift_ror	: IN	STD_LOGIC;
		shift_rrx	: IN	STD_LOGIC;
		shift_val	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
		
		din			: IN	STD_LOGIC_VECTOR (31 DOWNTO 0);
		cin			: IN	STD_LOGIC;
	
		dout		: OUT	STD_LOGIC_VECTOR (31 DOWNTO 0);
		cout		: OUT	STD_LOGIC;

		vdd			: IN BIT;
		vss			: IN BIT);
END ENTITY;

ARCHITECTURE Shifter OF Shifter IS
	SIGNAL dout_sig	: STD_LOGIC_VECTOR (31 DOWNTO 0);
BEGIN
	dout_sig <= STD_LOGIC_VECTOR(SHIFT_LEFT(UNSIGNED(din), TO_INTEGER(UNSIGNED(shift_val))))
				WHEN shift_lsl = '1'
			ELSE
				STD_LOGIC_VECTOR(SHIFT_RIGHT(UNSIGNED(din), TO_INTEGER(UNSIGNED(shift_val))))
				WHEN shift_lsr = '1'
			ELSE
				STD_LOGIC_VECTOR(SHIFT_RIGHT(SIGNED(din), TO_INTEGER(UNSIGNED(shift_val))))
				WHEN shift_asr = '1'
			ELSE
				STD_LOGIC_VECTOR(ROTATE_RIGHT(UNSIGNED(din), TO_INTEGER(UNSIGNED(shift_val))))
				WHEN shift_ror = '1'
			ELSE
				cin & din (31 DOWNTO 1)
				WHEN shift_rrx = '1';
	dout <= dout_sig;
	cout <= dout_sig (0) WHEN shift_rrx = '1';
END ARCHITECTURE;
