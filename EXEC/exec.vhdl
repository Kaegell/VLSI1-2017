LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Exec IS
    PORT (
             -- DECOD Interface
             -- -- synchronization
             dec2exe_empty	: IN	STD_LOGIC;
             exe_pop			: OUT	STD_LOGIC;

             -- -- operands
             dec_op1			: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
             dec_op2			: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
             dec_exe_dest	: IN STD_LOGIC_VECTOR (3 DOWNTO 0); 
             dec_exe_wb		: IN STD_LOGIC;
             dec_flag_wb		: IN STD_LOGIC;

             -- DEC2MEM interface
             dec_mem_data	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
             dec_mem_dest	: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
             dec_pre_index 	: IN STD_LOGIC;

             -- -- Memory format flags
             dec_mem_lw		: IN STD_LOGIC;
             dec_mem_lb		: IN STD_LOGIC;
             dec_mem_sw		: IN STD_LOGIC;
             dec_mem_sb		: IN STD_LOGIC;

             -- Shifter commands
             dec_shift_lsl	: IN STD_LOGIC;
             dec_shift_lsr	: IN STD_LOGIC;
             dec_shift_asr	: IN STD_LOGIC;
             dec_shift_ror	: IN STD_LOGIC;
             dec_shift_rrx	: IN STD_LOGIC;
             dec_shift_val	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
             dec_cy			: IN STD_LOGIC;

             -- Alu operand selection
             dec_comp_op1	: IN STD_LOGIC;
             dec_comp_op2	: IN STD_LOGIC;
             dec_alu_cy 		: IN STD_LOGIC;

             -- Alu command
             dec_alu_cmd		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);

             -- Exe bypass to decod
             exe_res			: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
             exe_c			: OUT STD_LOGIC;
             exe_v			: OUT STD_LOGIC;
             exe_n			: OUT STD_LOGIC;
             exe_z			: OUT STD_LOGIC;

             exe_dest		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
             exe_wb			: OUT STD_LOGIC; -- Write To Register
             exe_flag_wb		: OUT STD_LOGIC; -- CSPR modifiy

             -- MEM Interface

             exe_mem_adr		: INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
             exe_mem_data	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
             exe_mem_dest	: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

             exe_mem_lw		: OUT STD_LOGIC;
             exe_mem_lb		: OUT STD_LOGIC;
             exe_mem_sw		: OUT STD_LOGIC;
             exe_mem_sb		: OUT STD_LOGIC;

             exe2mem_empty	: OUT STD_LOGIC;
             mem_pop			: IN STD_LOGIC;

             -- global interface
             ck					: in Std_logic;
             reset_n			: in Std_logic;
             vdd				: in bit;
             vss				: in bit);
END ENTITY;

Architecture Exec OF Exec IS
    SIGNAL alu_op1_sig	: STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL alu_op2_sig	: STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL shift_op2_sig: STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL shifter_cout_sig : STD_LOGIC;
    SIGNAL alu_cout_sig     : STD_LOGIC;
    SIGNAL alu_res     : STD_LOGIC_VECTOR(31 DOWNTO 0);

    signal memory_access : std_logic;
    signal i_pushes : std_logic;        -- Indicates if the current instruction
                                        -- needs to push into the FIFO
    signal i_stagnant : std_logic;      -- Indicates if the current instruction
                                        -- has been here for more than one cycle
    signal exe2mem_push : std_logic;    -- Push command for the EXE FIFO
    signal exe2mem_full : std_logic;

    COMPONENT Alu
        PORT (
                 -- Data in
                 op1			: in Std_Logic_Vector(31 downto 0);
                 op2			: in Std_Logic_Vector(31 downto 0);
                 cin			: in Std_Logic;

                 -- Command(s)
                 cmd			: in Std_Logic_Vector(1 downto 0);

                 -- Data out
                 res			: out Std_Logic_Vector(31 downto 0);
                 cout		: out Std_Logic;
                 z			: out Std_Logic;
                 n			: out Std_Logic;
                 v			: out Std_Logic;

                 vdd			: in bit;
                 vss			: in bit);
    END COMPONENT;

    COMPONENT Shifter
        PORT (
                 -- Commands
                 shift_lsl	: IN	STD_LOGIC;
                 shift_lsr	: IN	STD_LOGIC;
                 shift_asr	: IN	STD_LOGIC;
                 shift_ror	: IN	STD_LOGIC;
                 shift_rrx	: IN	STD_LOGIC;
                 shift_val	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);

                 -- Data in/out
                 din			: IN	STD_LOGIC_VECTOR (31 DOWNTO 0);
                 cin			: IN	STD_LOGIC;

                 dout		: OUT	STD_LOGIC_VECTOR (31 DOWNTO 0);
                 cout		: OUT	STD_LOGIC;

                 -- Voltage representation
                 vdd			: IN BIT;
                 vss			: IN BIT);
    END COMPONENT;

    COMPONENT fifo_72b
        PORT (
                 din			: IN STD_LOGIC_VECTOR (71 DOWNTO 0);
                 dout		: OUT STD_LOGIC_VECTOR (71 DOWNTO 0);

                 -- commands
                 push		: IN STD_LOGIC;
                 pop			: IN STD_LOGIC;

                 -- flags
                 full		: OUT STD_LOGIC;
                 empty		: OUT STD_LOGIC;

                 reset_n		: IN STD_LOGIC;
                 ck			: IN STD_LOGIC;

                 -- Voltage representation
                 vdd			: IN BIT;
                 vss			: IN BIT);
    END COMPONENT;

    component fifov2
      generic ( CAPACITY  : integer := 5;
                LENGTH    : integer := 72
              );
      port (din       : in  std_logic_vector((LENGTH - 1) downto 0);
            dout      : out std_logic_vector((LENGTH - 1) downto 0);

            push      : in  std_logic;
            pop       : in  std_logic;

            full      : out std_logic;
            empty     : out std_logic;

            reset_n   : in  std_logic;
            ck        : in  std_logic;
            vdd       : in  bit;
            vss       : in  bit
          );
    end component;

    component fifo_handler
      port (
         -- intra-stage signals
             i_pushes      : in   std_logic;
             i_stagnant    : out  std_logic;

         -- inter-stage i/o
             empty         : in   std_logic;
             full          : in   std_logic;
             push          : out  std_logic;
             pop           : out  std_logic;

         -- global interface
             ck					  : in    std_logic;
             reset_n			: in    std_logic;
             vdd				  : in    bit;
             vss				  : in    bit);
    end component;

BEGIN

    --  Component instantiation.
    shifter_inst : Shifter
    PORT MAP (
                 shift_lsl	=> dec_shift_lsl,
                 shift_lsr	=> dec_shift_lsr,
                 shift_asr	=> dec_shift_asr,
                 shift_ror	=> dec_shift_ror,
                 shift_rrx	=> dec_shift_rrx,
                 shift_val	=> dec_shift_val,

                 din			=> dec_op2,
                 cin			=> dec_cy,
                 cout       => shifter_cout_sig,

                 dout		=> shift_op2_sig,

                 vdd => vdd,
                 vss => vss);

    alu_inst : Alu
    PORT MAP (
                 op1		=> alu_op1_sig,
                 op2		=> alu_op2_sig,
                 cin		=> dec_alu_cy,

                 cmd		=> dec_alu_cmd,

                 res		=> alu_res,
                 cout	=> alu_cout_sig,
                 z		=> exe_z,
                 n		=> exe_n,
                 v		=> exe_v,

                 vss		=> vss,
                 vdd		=> vdd);

    -- FIFO handling
    exec2mem : fifo_72b
    PORT MAP (
    din(71)				=> dec_mem_lw,
    din(70)				=> dec_mem_lb,
    din(69)				=> dec_mem_sw,
    din(68)				=> dec_mem_sb,

    din(67 downto 64)	=> dec_mem_dest,
    din(63 downto 32)	=> dec_mem_data,
    din(31 downto 0)	=> exe_mem_adr,

    dout(71)			=> exe_mem_lw,
    dout(70)			=> exe_mem_lb,
    dout(69)	 		=> exe_mem_sw,
    dout(68)	 		=> exe_mem_sb,

    dout(67 downto 64)	=> exe_mem_dest,
    dout(63 downto 32)	=> exe_mem_data,
    dout(31 downto 0)	=> exe_mem_adr,


    push				=> exe2mem_push,
    pop					=> mem_pop,

    empty				=> exe2mem_empty,
    full				=> exe2mem_full,

    reset_n				=> reset_n,
    ck					=> ck,
    vdd					=> vdd,
    vss					=> vss);

    --fifo_handler_inst : fifo_handler
    --port map (
    --i_pushes      => i_pushes,
    --i_stagnant    => i_stagnant,
    --empty         => dec2exe_empty,
    --full          => exe2mem_full,
    --push          => exe2mem_push,
    --pop           => exe_pop,
    --ck            => ck,
    --reset_n       => reset_n,
    --vdd           => vdd,
    --vss           => vss);
    -- end of FIFO handling

    memory_access <= dec_mem_lw or dec_mem_lb or dec_mem_sw or dec_mem_sb;
    -- we pop if (1) the FIFO is not empty
    -- and (2) if we have nothing left to push
    -- (2) : in other words if we had nothing to push (i.e. there was no memory access to launch)
    -- or if we are going to push
    exe_pop <=  (not dec2exe_empty) and (not memory_access or exe2mem_push);
    -- we push if there's a memory access to launch and if the FIFO is not full
    exe2mem_push <= memory_access and not exe2mem_full;

    exe_dest <= dec_exe_dest;
    exe_wb <= dec_exe_wb;
    exe_flag_wb <= dec_flag_wb;
    exe_res <= alu_res;

    WITH dec_comp_op1 SELECT
        alu_op1_sig <= NOT dec_op1 WHEN '1',
                   dec_op1 WHEN '0',
                   x"00000000" WHEN others;

    WITH dec_comp_op2 SELECT
        alu_op2_sig <= NOT dec_op2 WHEN '1',
                   dec_op2 WHEN '0',
                   x"00000000" WHEN others;

    WITH dec_alu_cmd SELECT
        exe_c <= alu_cout_sig WHEN "00",
                 shifter_cout_sig WHEN others;

    WITH dec_pre_index SELECT
        exe_mem_adr <= alu_res WHEN '0',
                       dec_op1 WHEN '1',
                       x"FFFFFFFF" WHEN others;
    exe_mem_data <= dec_mem_data;
    exe_mem_dest <= dec_mem_dest;
    exe_mem_lw <= dec_mem_lw;
    exe_mem_lb <= dec_mem_lb;
    exe_mem_sw <= dec_mem_sw;
    exe_mem_sb <= dec_mem_sb;
END ARCHITECTURE;
