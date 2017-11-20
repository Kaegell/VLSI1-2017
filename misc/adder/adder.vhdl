
-- Master SESI - VLSI - TME3
-- File :       adder.vhdl
-- Author :     Nicolas Phan <nicolas.van.phan@gmail.com>
-- 
-- This entity corresponds to a 4-bit adder
--
--------------------------------------------------------------------------------

-- Library declaration
-- (STD and WORK are known by default)
LIBRARY ieee;
USE     ieee.std_logic_1164.all;
USE     ieee.numeric_std.all;           -- for signed/unsigned operations

-- Entity Declaration
ENTITY adder IS
PORT (
        op1     : in    std_logic_vector(3 downto 0);
        op2     : in    std_logic_vector(3 downto 0);
        result  : out   std_logic_vector(3 downto 0)
);
END ENTITY;

ARCHITECTURE arch OF adder IS
BEGIN
result  <= std_logic_vector(unsigned(op1) + unsigned(op2));
END arch;

