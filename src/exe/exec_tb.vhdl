
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     ieee.math_real.all;

entity  exec_tb is
end entity;

architecture arch of exec_tb is
    -- DECOD Interface
    -- -- synchronization
    signal dec2exe_empty	: std_logic;
    signal exe_pop		: std_logic;
    
    -- -- operands
    signal dec_op1		: std_logic_vector (31 downto 0);
    signal dec_op2		: std_logic_vector (31 downto 0);
    signal dec_exe_dest	        : std_logic_vector (3 downto 0); 
    signal dec_exe_wb		: std_logic;
    signal dec_flag_wb		: std_logic;
    
    -- dec2mem interface
    signal dec_mem_data	        : std_logic_vector (31 downto 0);
    signal dec_mem_dest	        : std_logic_vector (3 downto 0);
    signal dec_pre_index 	: std_logic;
    
    -- -- memory format flags
    signal dec_mem_lw		: std_logic;
    signal dec_mem_lb		: std_logic;
    signal dec_mem_sw		: std_logic;
    signal dec_mem_sb		: std_logic;
    
    -- shifter commands
    signal dec_shift_lsl	: std_logic;
    signal dec_shift_lsr	: std_logic;
    signal dec_shift_asr	: std_logic;
    signal dec_shift_ror	: std_logic;
    signal dec_shift_rrx	: std_logic;
    signal dec_shift_val	: std_logic_vector (4 downto 0);
    signal dec_cy		: std_logic;
    
    -- alu operand selection
    signal dec_comp_op1	        : std_logic;
    signal dec_comp_op2	        : std_logic;
    signal dec_alu_cy 		: std_logic;
    
    -- alu command
    signal dec_alu_cmd		: std_logic_vector (1 downto 0);
    
    -- exe bypass to decod
    signal exe_res		: std_logic_vector(31 downto 0);
    signal exe_c		: std_logic;
    signal exe_v		: std_logic;
    signal exe_n		: std_logic;
    signal exe_z		: std_logic;
    
    signal exe_dest		: std_logic_vector (3 downto 0);
    signal exe_wb		: std_logic; -- write to register
    signal exe_flag_wb		: std_logic; -- cspr modifiy
    
    -- mem interface
    signal exe_mem_adr		: std_logic_vector(31 downto 0);
    signal exe_mem_data	        : std_logic_vector(31 downto 0);
    signal exe_mem_dest	        : std_logic_vector(3 downto 0);
    
    signal exe_mem_lw		: std_logic;
    signal exe_mem_lb		: std_logic;
    signal exe_mem_sw		: std_logic;
    signal exe_mem_sb		: std_logic;
    
    signal exe2mem_empty	: std_logic;
    signal exe2mem_full	        : std_logic;
    signal exe_push		: std_logic;
    signal mem_pop		: std_logic;
    
    -- global interface
    signal ck			: std_logic;
    signal reset_n		: std_logic;
    signal vdd			: bit;
    signal vss			: bit;

    -- =================== UUT Declaration ===================================
    component exec
    port (
    -- decod interface
    -- -- synchronization
             dec2exe_empty	: in	std_logic;
             exe_pop		: out	std_logic;

    -- -- operands
             dec_op1		: in std_logic_vector (31 downto 0);
             dec_op2		: in std_logic_vector (31 downto 0);
             dec_exe_dest	: in std_logic_vector (3 downto 0); 
             dec_exe_wb		: in std_logic;
             dec_flag_wb	: in std_logic;

    -- dec2mem interface
             dec_mem_data	: in std_logic_vector (31 downto 0);
             dec_mem_dest	: in std_logic_vector (3 downto 0);
             dec_pre_index 	: in std_logic;

    -- -- memory format flags
             dec_mem_lw		: in std_logic;
             dec_mem_lb		: in std_logic;
             dec_mem_sw		: in std_logic;
             dec_mem_sb		: in std_logic;

    -- shifter commands
             dec_shift_lsl	: in std_logic;
             dec_shift_lsr	: in std_logic;
             dec_shift_asr	: in std_logic;
             dec_shift_ror	: in std_logic;
             dec_shift_rrx	: in std_logic;
             dec_shift_val	: in std_logic_vector (4 downto 0);
             dec_cy		: in std_logic;

    -- alu operand selection
             dec_comp_op1	: in std_logic;
             dec_comp_op2	: in std_logic;
             dec_alu_cy 	: in std_logic;

    -- alu command
             dec_alu_cmd	: in std_logic_vector (1 downto 0);

    -- exe bypass to decod
             exe_res		: out std_logic_vector(31 downto 0);
             exe_c		: out std_logic;
             exe_v		: out std_logic;
             exe_n		: out std_logic;
             exe_z		: out std_logic;

             exe_dest		: out std_logic_vector (3 downto 0);
             exe_wb		: out std_logic; -- write to register
             exe_flag_wb	: out std_logic; -- cspr modifiy

    -- mem interface

             exe_mem_adr	: inout std_logic_vector(31 downto 0);
             exe_mem_data	: out std_logic_vector(31 downto 0);
             exe_mem_dest	: out std_logic_vector(3 downto 0);

             exe_mem_lw		: out std_logic;
             exe_mem_lb		: out std_logic;
             exe_mem_sw		: out std_logic;
             exe_mem_sb		: out std_logic;

             exe2mem_empty	: out std_logic;
             exe2mem_full	: out std_logic;
             exe_push		: in std_logic;
             mem_pop		: in std_logic;

    -- global interface
             ck			: in std_logic;
             reset_n		: in std_logic;
             vdd		: in bit;
             vss		: in bit);
    end component;
begin

    -- ================ UUT Instanciation ====================================
    exec_inst : exec
    port map (
    dec2exe_empty   => dec2exe_empty,
    exe_pop         => exe_pop,
    dec_op1         => dec_op1,
    dec_op2         => dec_op2,
    dec_exe_dest    => dec_exe_dest,
    dec_exe_wb      => dec_exe_wb,
    dec_flag_wb     => dec_flag_wb,
    dec_mem_data    => dec_mem_data,
    dec_mem_dest    => dec_mem_dest,
    dec_pre_index   => dec_pre_index,
    dec_mem_lw      => dec_mem_lw,
    dec_mem_lb      => dec_mem_lb,
    dec_mem_sw      => dec_mem_sw,
    dec_mem_sb      => dec_mem_sb,
    dec_shift_lsl   => dec_shift_lsl,
    dec_shift_lsr   => dec_shift_lsr,
    dec_shift_asr   => dec_shift_asr,
    dec_shift_ror   => dec_shift_ror,
    dec_shift_rrx   => dec_shift_rrx,
    dec_shift_val   => dec_shift_val,
    dec_cy          => dec_cy,
    dec_comp_op1    => dec_comp_op1,
    dec_comp_op2    => dec_comp_op2,
    dec_alu_cy      => dec_alu_cy,
    dec_alu_cmd     => dec_alu_cmd,
    exe_res         => exe_res,
    exe_c           => exe_c,
    exe_v           => exe_v,
    exe_n           => exe_n,
    exe_z           => exe_z,
    exe_dest        => exe_dest,
    exe_wb          => exe_wb,
    exe_flag_wb     => exe_flag_wb,
    exe_mem_adr     => exe_mem_adr,
    exe_mem_data    => exe_mem_data,
    exe_mem_dest    => exe_mem_dest,
    exe_mem_lw      => exe_mem_lw,
    exe_mem_lb      => exe_mem_lb,
    exe_mem_sw      => exe_mem_sw,
    exe_mem_sb      => exe_mem_sb,
    exe2mem_empty   => exe2mem_empty,
    exe2mem_full    => exe2mem_full,
    exe_push        => exe_push,
    mem_pop         => mem_pop,
    ck              => ck,
    reset_n         => reset_n,
    vdd             => vdd,
    vss             => vss);

    -- ================== stimuli generation =================================

end arch;

