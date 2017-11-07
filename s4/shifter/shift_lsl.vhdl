
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

entity shift_lsl is
  port( din           : in std_logic_vector(31 downto 0);
        cin           : in std_logic;
        shift_val     : in std_logic_vector(4 downto 0);
        
        dout          : out std_logic_vector(31 downto 0);
        cout          : out std_logic);
end shift_lsl;

architecture arch of shift_lsl is
signal stageI   : std_logic_vector(32 downto 0);
signal stage1   : std_logic_vector(32 downto 0);
signal stage2   : std_logic_vector(32 downto 0);
signal stage3   : std_logic_vector(32 downto 0);
signal stage4   : std_logic_vector(32 downto 0);
signal stageF   : std_logic_vector(32 downto 0);

begin
  stageI <= cin & din;

  stage1 <= stageI(16 downto 0) & x"0000" when (shift_val(4) = '1') else stageI;
  stage2 <= stage1(24 downto 0) & x"00"   when (shift_val(3) = '1') else stage1;
  stage3 <= stage2(28 downto 0) & "0000"  when (shift_val(2) = '1') else stage2;
  stage4 <= stage3(30 downto 0) & "00"    when (shift_val(1) = '1') else stage3;
  stageF <= stage4(31 downto 0) & '0'     when (shift_val(0) = '1') else stage4;
  
  dout   <= stageF(31 downto 0);
  cout   <= stageF(32);
end arch;

