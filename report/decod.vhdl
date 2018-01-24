library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

-- =============================================================================
-- == @@ ==========  ENTITY DECLARATION  =======================================
-- =============================================================================
entity decod is
	port(
	-- Exec operands
			dec_op1			  : out std_logic_vector(31 downto 0);
			dec_op2			  : out std_logic_vector(31 downto 0);
			dec_exe_dest	: out std_logic_vector(3 downto 0);
			dec_exe_wb		: out std_logic;
			dec_flag_wb		: out std_logic;

	-- Decod to mem via EXEC
			dec_mem_data	: out std_logic_vector(31 downto 0);
			dec_mem_dest	: out std_logic_vector(3 downto 0);
			dec_pre_index : out std_logic;

			dec_mem_lw		: out std_logic;
			dec_mem_lb		: out std_logic;
			dec_mem_sw		: out std_logic;
			dec_mem_sb		: out std_logic;

	-- Shifter command
			dec_shift_lsl	: out std_logic;
			dec_shift_lsr	: out std_logic;
			dec_shift_asr	: out std_logic;
			dec_shift_ror	: out std_logic;
			dec_shift_rrx	: out std_logic;
			dec_shift_val	: out std_logic_vector(4 downto 0);
			dec_cy			  : out std_logic;

	-- Alu operand selection
			dec_comp_op1	: out std_logic;
			dec_comp_op2	: out std_logic;
			dec_alu_cy 		: out std_logic;

	-- Exec Synchro
			dec2exe_empty	: out std_logic;
			exe_pop			  : in  std_logic;

	-- Alu command
			dec_alu_cmd		: out std_logic_vector(1 downto 0);

	-- EXE write back to REG
			exe_res			  : in  std_logic_vector(31 downto 0);

			exe_c				  : in std_logic;
			exe_v				  : in std_logic;
			exe_n				  : in std_logic;
			exe_z				  : in std_logic;

			exe_dest			: in std_logic_vector(3 downto 0);
			exe_wb			  : in std_logic;
			exe_flag_wb		: in std_logic;

	-- IFC interface
			dec_pc			  : out std_logic_vector(31 downto 0);
			if_ir				  : in  std_logic_vector(31 downto 0);

	-- IFC synchro
			dec2if_empty	: out std_logic;
			if_pop			  : in  std_logic;

			if2dec_empty	: in  std_logic;
			dec_pop			  : out std_logic;

	-- Mem Write back to reg
			mem_res			  : in std_logic_vector(31 downto 0);
			mem_dest			: in std_logic_vector(3 downto 0);
			mem_wb			  : in std_logic;
			
	-- global interface
			ck					  : in std_logic;
			reset_n			  : in std_logic;
			vdd				    : in bit;
			vss				    : in bit);
end decod;

architecture behavior of decod is

-- =============================================================================
-- == @@ ==========  COMPONENT DECLARATION  ====================================
-- =============================================================================

------------------------- REG --------------------------------------------------
component reg
	port(
	-- Write Port 1 prioritaire
		wdata1		  : in  std_logic_vector(31 downto 0);
		wadr1			  : in  std_logic_vector(3 downto 0);
		wen1			  : in  std_logic;

	-- Write Port 2 non prioritaire
		wdata2		  : in  std_logic_vector(31 downto 0);
		wadr2			  : in  std_logic_vector(3 downto 0);
		wen2			  : in  std_logic;

	-- Write CSPR Port
		wcry			  : in  std_logic;
		wzero			  : in  std_logic;
		wneg			  : in  std_logic;
		wovr			  : in  std_logic;
		cspr_wb		  : in  std_logic;
		
	-- Read Port 1 32 bits
		reg_rd1		  : out std_logic_vector(31 downto 0);
		radr1			  : in  std_logic_vector(3 downto 0);
		reg_v1		  : out std_logic;
		reg_wb1		  : out std_logic;

	-- Read Port 2 32 bits
		reg_rd2		  : out std_logic_vector(31 downto 0);
		radr2			  : in  std_logic_vector(3 downto 0);
		reg_v2		  : out std_logic;
		reg_wb2		  : out std_logic;

	-- Read Port 3 32 bits
		reg_rd3		  : out std_logic_vector(31 downto 0);
		radr3			  : in  std_logic_vector(3 downto 0);
		reg_v3		  : out std_logic;
		reg_wb3		  : out std_logic;

	-- read CSPR Port
		reg_cry		  : out std_logic;
		reg_zero	  : out std_logic;
		reg_neg		  : out std_logic;
		reg_cznv	  : out std_logic;
		reg_ovr		  : out std_logic;
		reg_vv		  : out std_logic;
		
	-- Invalidate Port 
		inval_adr1  : in  std_logic_vector(3 downto 0);
		inval1		  : in  std_logic;

		inval_adr2	: in  std_logic_vector(3 downto 0);
		inval2		  : in  std_logic;

		inval_czn	  : in  std_logic;
		inval_ovr	  : in  std_logic;

	-- PC
		reg_pc		  : out std_logic_vector(31 downto 0);
		reg_pcv		  : out std_logic;
		inc_pc		  : in  std_logic;
	
	-- global interface
		ck				  : in  std_logic;
		reset_n		  : in  std_logic;
		vdd			    : in  bit;
		vss			    : in  bit);
end component;

------------------------- FIFO 127b --------------------------------------------
component fifo_127b
  port(
		din		  : in  std_logic_vector(126 downto 0);
		dout		: out std_logic_vector(126 downto 0);

		push		: in  std_logic;
		pop		  : in  std_logic;

		full		: out std_logic;
		empty		: out std_logic;

		reset_n	: in  std_logic;
		ck			: in  std_logic;
		vdd		  : in  bit;
		vss		  : in  bit
	);
end component;

------------------------- FIFO v2 ----------------------------------------------
component fifov2
  generic(
    LENGTH    : integer;
    CAPACITY  : integer
    );
	port(
		din		  : in  std_logic_vector(126 downto 0);
		dout		: out std_logic_vector(126 downto 0);

		push		: in  std_logic;
		pop		  : in  std_logic;

		full		: out std_logic;
		empty		: out std_logic;

		reset_n	: in  std_logic;
		ck			: in  std_logic;
		vdd		  : in  bit;
		vss		  : in  bit
	);
end component;

------------------------- FIFO 32b ---------------------------------------------
component fifo_32b
	port(
		din		  : in  std_logic_vector(31 downto 0);
		dout		: out std_logic_vector(31 downto 0);

		push		: in  std_logic;
		pop		  : in  std_logic;

		full		: out std_logic;
		empty		: out std_logic;

		reset_n	: in  std_logic;
		ck			: in  std_logic;
		vdd		  : in  bit;
		vss		  : in  bit
	);
end component;

-- =============================================================================
-- == @@ ==========  SIGNAL DECLARATION  =======================================
-- =============================================================================

------------------------- Predicate --------------------------------------------
signal cond		: std_logic;
signal condv	: std_logic;

------------------------- Instruction decoding ---------------------------------
signal regop_t  : std_logic;
signal mult_t   : std_logic;
signal swap_t   : std_logic;
signal trans_t  : std_logic;
signal mtrans_t : std_logic;
signal branch_t : std_logic;

signal and_i  : std_logic;
signal eor_i  : std_logic;
signal sub_i  : std_logic;
signal rsb_i  : std_logic;
signal add_i  : std_logic;
signal adc_i  : std_logic;
signal sbc_i  : std_logic;
signal rsc_i  : std_logic;
signal tst_i  : std_logic;
signal teq_i  : std_logic;
signal cmp_i  : std_logic;
signal cmn_i  : std_logic;
signal orr_i  : std_logic;
signal mov_i  : std_logic;
signal bic_i  : std_logic;
signal mvn_i  : std_logic;

signal mul_i  : std_logic;
signal mla_i  : std_logic;

signal ldr_i  : std_logic;
signal str_i  : std_logic;
signal ldrb_i : std_logic;
signal strb_i : std_logic;

signal ldm_i  : std_logic;
signal stm_i  : std_logic;

signal b_i    : std_logic;
signal bl_i   : std_logic;

signal blink  : std_logic;  -- branch and link

------------------------- Operands Reading -------------------------------------
signal radr1    : std_logic_vector(3 downto 0);
signal rdata1   : std_logic_vector(31 downto 0);
signal rvalid1  : std_logic;
signal reg_wb1  : std_logic;

signal radr2    : std_logic_vector(3 downto 0);
signal rdata2   : std_logic_vector(31 downto 0);
signal rvalid2  : std_logic;
signal reg_wb2  : std_logic;

signal radr3    : std_logic_vector(3 downto 0);
signal rdata3   : std_logic_vector(31 downto 0);
signal rvalid3  : std_logic;
signal reg_wb3  : std_logic;

signal operv	  : std_logic;

------------------------- Flags and PC reading ---------------------------------
-- Flags
signal cry	    : std_logic;
signal zero	    : std_logic;
signal neg	    : std_logic;
signal ovr	    : std_logic;

-- PC
signal reg_pc   : std_logic_vector(31 downto 0);
signal reg_pcv  : std_logic;
signal inc_pc   : std_logic;

------------------------- Invalidation -----------------------------------------
signal inval_exe_adr  : std_logic_vector(3 downto 0);
signal inval_exe      : std_logic;

signal inval_mem_adr  : std_logic_vector(3 downto 0);
signal inval_mem      : std_logic;

signal reg_cznv       : std_logic;
signal reg_vv         : std_logic;

signal inval_czn      : std_logic;
signal inval_ovr      : std_logic;

------------------------- FIFO -------------------------------------------------
signal dec2if_full    : Std_Logic;
signal dec2if_push    : Std_Logic;

signal dec2exe_full   : Std_Logic;
signal dec2exe_push   : Std_Logic;

signal if2dec_pop     : Std_Logic;

------------------------- EXE --------------------------------------------------
-- Operands
signal op1			      : std_logic_vector(31 downto 0);
signal op2			      : std_logic_vector(31 downto 0);
signal alu_dest	      : std_logic_vector(3 downto 0);
signal offset32	      : std_logic_vector(31 downto 0);
-- ALU command
signal alu_cmd		    : std_logic_vector(1 downto 0);
signal alu_cy 		    : std_logic;
-- Inverter command
signal comp_op1	      : std_logic;
signal comp_op2	      : std_logic;
-- Shifter command
signal shift_lsl	    : std_logic;
signal shift_lsr	    : std_logic;
signal shift_asr	    : std_logic;
signal shift_ror	    : std_logic;
signal shift_rrx	    : std_logic;
signal shift_val	    : std_logic_vector(4 downto 0);
signal shift_is_zero  : std_logic;
signal cy			        : std_logic;
-- Writeback
signal alu_wb		      : std_logic;
signal flag_wb		    : std_logic;

------------------------- MEM --------------------------------------------------
signal mem_data   : std_logic_vector(31 downto 0);
signal ld_dest		: std_logic_vector(3 downto 0);
signal pre_index 	: std_logic;

signal mem_lw		  : std_logic;
signal mem_lb		  : std_logic;
signal mem_sw		  : std_logic;
signal mem_sb		  : std_logic;

------------------------- Multiple Transferts ----------------------------------
signal mtrans_shift       : std_logic;

signal mtrans_mask_shift  : std_logic_vector(15 downto 0);
signal mtrans_mask        : std_logic_vector(15 downto 0);
signal mtrans_list        : std_logic_vector(15 downto 0);
signal mtrans_1un         : std_logic;
signal mtrans_loop_adr    : std_logic;
signal mtrans_nbr         : std_logic_vector(4 downto 0);
signal mtrans_rd          : std_logic_vector(3 downto 0);

------------------------- Finite State Machine ---------------------------------
type    state_type is (FETCH, RUN, BRANCH, LINK, MTRANS, UNDEFINED);
signal  cur_state, next_state : state_type;
signal  debug_state : Std_Logic_Vector(3 downto 0) := X"0";

begin

-- =============================================================================
-- == @@ ==========  ENTITY INSTANCIATION  =====================================
-- =============================================================================

------------------------- DEC to EXE -------------------------------------------
	dec2exec : fifo_127b
	port map (
          din(126)            => pre_index,
					din(125)	          => alu_wb,
					din(124)	          => flag_wb,
					din(123 downto 92)  => op1,
					din(91 downto 60)	  => op2,
					din(59 downto 56)	  => alu_dest,

					din(55 downto 24)	  => rdata3,
					din(23 downto 20)	  => ld_dest,
					din(19)	            => mem_lw,
					din(18)	            => mem_lb,
					din(17)	            => mem_sw,
					din(16)	            => mem_sb,

					din(15)	            => shift_lsl,
					din(14)	            => shift_lsr,
					din(13)	            => shift_asr,
					din(12)	            => shift_ror,
					din(11)	            => shift_rrx,
					din(10 downto 6)	  => shift_val,
					din(5)	            => cry,

					din(4)	            => comp_op1,
					din(3)	            => comp_op2,
					din(2)	            => alu_cy,

					din(1 downto 0)	    => alu_cmd,

					dout(126)	          => dec_pre_index,
					dout(125)	          => dec_exe_wb,
					dout(124)	          => dec_flag_wb,
					dout(123 downto 92) => dec_op1,
					dout(91 downto 60)	=> dec_op2,
					dout(59 downto 56)	=> dec_exe_dest,

					dout(55 downto 24)	=> dec_mem_data,
					dout(23 downto 20)	=> dec_mem_dest,
					dout(19)	          => dec_mem_lw,
					dout(18)	          => dec_mem_lb,
					dout(17)	          => dec_mem_sw,
					dout(16)	          => dec_mem_sb,

					dout(15)	          => dec_shift_lsl,
					dout(14)	          => dec_shift_lsr,
					dout(13)	          => dec_shift_asr,
					dout(12)	          => dec_shift_ror,
					dout(11)	          => dec_shift_rrx,
					dout(10 downto 6)	  => dec_shift_val,
					dout(5)	            => dec_cy,

					dout(4)	            => dec_comp_op1,
					dout(3)	            => dec_comp_op2,
					dout(2)	            => dec_alu_cy,

					dout(1 downto 0)	  => dec_alu_cmd,

					push		            => dec2exe_push,
					pop		              => exe_pop,

					empty		            => dec2exe_empty,
					full		            => dec2exe_full,

					reset_n	            => reset_n,
					ck			            => ck,
					vdd		              => vdd,
					vss		              => vss);

------------------------- DEC to IF --------------------------------------------
	dec2if : fifo_32b
	port map (
          din     => reg_pc,
					dout    => dec_pc,

					push	  => dec2if_push,
					pop		  => if_pop,

					empty	  => dec2if_empty,
					full		=> dec2if_full,

					reset_n	=> reset_n,
					ck			=> ck,
					vdd		  => vdd,
					vss		  => vss);

------------------------- REG --------------------------------------------------
	reg_inst  : reg
	port map(
          wdata1		  => exe_res,
					wadr1			  => exe_dest,
					wen1			  => exe_wb,
                                          
					wdata2		  => mem_res,
					wadr2			  => mem_dest,
					wen2			  => mem_wb,
                                          
					wcry			  => exe_c,
					wzero			  => exe_z,
					wneg			  => exe_n,
					wovr			  => exe_v,
					cspr_wb		  => exe_flag_wb,
					               
					reg_rd1		  => rdata1,
					radr1			  => radr1,
					reg_v1		  => rvalid1,
          reg_wb1     => reg_wb1,
                                          
					reg_rd2		  => rdata2,
					radr2			  => radr2,
					reg_v2		  => rvalid2,
          reg_wb2     => reg_wb2,
                                          
					reg_rd3		  => rdata3,
					radr3			  => radr3,
					reg_v3		  => rvalid3,
          reg_wb3     => reg_wb3,
                                          
					reg_cry		  => cry,
					reg_zero    => zero,
					reg_neg		  => neg,
					reg_ovr		  => ovr,
					               
					reg_cznv	  => reg_cznv,
					reg_vv		  => reg_vv,
                                          
					inval_adr1	=> inval_exe_adr,
					inval1		  => inval_exe,
                                          
					inval_adr2	=> inval_mem_adr,
					inval2		  => inval_mem,
                                          
					inval_czn	  => inval_czn,
					inval_ovr	  => inval_ovr,
                                          
					reg_pc		  => reg_pc,
					reg_pcv		  => reg_pcv,
					inc_pc		  => inc_pc,
				                              
					ck				  => ck,
					reset_n		  => reset_n,
					vdd			    => vdd,
					vss			    => vss);

-- =============================================================================
-- == @@ ==========  PREDICATE CONTROL =========================================
-- =============================================================================

------------------------- Predicate retrieving ---------------------------------
    cond <= '1' when
        (if_ir(31 downto 28) = X"0" and   zero = '1'                    ) or
        (if_ir(31 downto 28) = X"1" and   zero = '0'                    ) or
        (if_ir(31 downto 28) = X"2" and   cry  = '1'                    ) or
        (if_ir(31 downto 28) = X"3" and   cry  = '0'                    ) or
        (if_ir(31 downto 28) = X"4" and   neg  = '1'                    ) or
        (if_ir(31 downto 28) = X"5" and   neg  = '0'                    ) or
        (if_ir(31 downto 28) = X"6" and   ovr  = '1'                    ) or
        (if_ir(31 downto 28) = X"7" and   ovr  = '0'                    ) or
        (if_ir(31 downto 28) = X"8" and   cry  = '1'  and zero = '0'    ) or
        (if_ir(31 downto 28) = X"9" and   cry  = '0'  and zero = '1'    ) or
        (if_ir(31 downto 28) = X"A" and   neg  = ovr                    ) or
        (if_ir(31 downto 28) = X"B" and   neg /= ovr                    ) or
        (if_ir(31 downto 28) = X"C" and   zero = '0'  and (neg = ovr)   ) or
        (if_ir(31 downto 28) = X"D" and  (zero = '1'  or  (neg /= ovr)) ) or
        (if_ir(31 downto 28) = X"E") else '0';

------------------------- Predicate validity -----------------------------------
    -- condv = "the 'cond' signal is valid" and 'cond' is valid when
    -- all the flags it uses are valid, i.e. cond = FOO and all the flags
    -- influencing FOO are valid
    condv   <= '1'		                when if_ir(31 downto 28) = X"E"
          else reg_cznv and reg_vv    when if_ir(31 downto 28) = X"A"
                                        or if_ir(31 downto 28) = X"B"
                                        or if_ir(31 downto 28) = X"C"
                                        or if_ir(31 downto 28) = X"D"
          else reg_vv                 when if_ir(31 downto 28) = X"6"
                                        or if_ir(31 downto 28) = X"7"
		      else reg_cznv;

-- =============================================================================
-- == @@ ==========  INSTRUCTION DECODING  =====================================
-- =============================================================================

------------------------- Instruction Type Decoding ----------------------------
  regop_t    <= '1'   when  if_ir(27 downto 26) = "00" and
                            mult_t = '0' and
                            swap_t = '0'
           else '0';
  mult_t     <= '1'   when  if_ir(27 downto 22) = "000000" and
                            if_ir(7 downto 4) = "1001"
           else '0';
  swap_t     <= '1'   when  if_ir(27 downto 23) = "00010" and
                            if_ir(11 downto 4) = "00001001"
           else '0';
  trans_t    <= '1'   when  if_ir(27 downto 26) = "01" and not (
                              if_ir(25) = '1' and
                              if_ir(4) = '1' )
           else '0';
  mtrans_t   <= '1'   when if_ir(27 downto 25) = "100"
           else '0';
  branch_t   <= '1'   when if_ir(27 downto 25) = "101"
           else '0';

------------------------- Instruction Decoding ---------------------------------
  ----- Regop Instructions
	and_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"0" else '0';
	eor_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"1" else '0';
	sub_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"2" else '0';
	rsb_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"3" else '0';
	add_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"4" else '0';
	adc_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"5" else '0';
	sbc_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"6" else '0';
	rsc_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"7" else '0';
	tst_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"8" else '0';
	teq_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"9" else '0';
	cmp_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"A" else '0';
	cmn_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"B" else '0';
	orr_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"C" else '0';
	mov_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"D" else '0';
	bic_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"E" else '0';
	mvn_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"F" else '0';

  ----- Trans Instruction
  ldr_i     <= '1'    when trans_t = '1' and if_ir(20) = '1' and
                           if_ir(22) = '0'
          else '0';

  ldrb_i    <= '1'    when trans_t = '1' and if_ir(20) = '1' and
                           if_ir(22) = '1'
          else '0';

  str_i     <= '1'    when trans_t = '1' and if_ir(20) = '0' and
                           if_ir(22) = '0'
          else '0';

  strb_i    <= '1'    when trans_t = '1' and if_ir(20) = '0' and
                           if_ir(22) = '1'
          else '0';

  ----- Mtrans Instruction

  ----- Branch Instruction

-- =============================================================================
-- == @@ ==========  EXE  ======================================================
-- =============================================================================

------------------------- Operands ---------------------------------------------
	op1  <= reg_pc       when branch_t = '1'                    else
          X"00000000"  when regop_t = '1' and                 
                            (mov_i = '1' or mvn_i = '1')      else
          rdata1;

  op2  <= offset32                         when branch_t = '1'      else
          X"000000" & if_ir(7 downto 0)    when regop_t  = '1' and
                                                if_ir(25) = '1'     else
          rdata2;

  -- Offset32 is the 24-bit offset given in a branch,
  -- expanded into a 32-bit word.
  -- According to the doc, the 24-bit offset of a branch
  -- must be left-shifted by 2 bits and sign-extended to 32-bits
  offset32(25 downto 0)   <= if_ir(23 downto 0) & "00"; -- left shift
  offset32(31 downto 26)  <= (others => if_ir(23));     -- sign extent

  alu_dest    <= X"F"                   when branch_t = '1'    else
                 if_ir(15 downto 12);


------------------------- ALU Command ------------------------------------------

	alu_cmd <= "11" when eor_i='1' or teq_i='1'                else -- ALU-XOR
             "10" when orr_i='1' or mov_i='1' or mvn_i='1'   else -- ALU-OR
             "01" when and_i='1' or tst_i='1' or bic_i='1'   else -- ALU-AND
				     "00";                                                -- ALU-ADD

  alu_cy  <= '1'    when sub_i = '1'
                      or rsb_i = '1'
                      or cmp_i = '1'      else
             exe_c  when adc_i = '1'      
                      or sbc_i = '1'
                      or rsc_i = '1'      else
             '0';

------------------------- Inverters command ------------------------------------

  comp_op1  <= '1'    when rsb_i = '1'
                        or rsc_i = '1'
          else '0';

  comp_op2  <= '1'    when sub_i = '1'
                        or sbc_i = '1'
                        or cmp_i = '1'
                        or bic_i = '1'
                        or mvn_i = '1'
          else '0';

------------------------- Shifter command --------------------------------------

  shift_is_zero <= '1'    when
    (regop_t = '1')                           -- Instruction is a regop
    and ( (                                   -- and
        (if_ir(25) = '0')                     -- -- op2 is register
        and ( (                               -- -- and 
            (if_ir(4)='0')                    -- -- -- shift is immediate
            and                               -- -- -- and
            (if_ir(11 downto 7)="00000") )    -- -- -- shift immediate = 0
          or (                                -- -- or
            (if_ir(4)='1')                    -- -- -- shift is register
            and                               -- -- -- and
            (rdata3=x"00000000") ) ) )        -- -- -- register value = 0
      or (                                    -- or
        (if_ir(4)='1')                        -- -- op2 is immediate
        and                                   -- -- and
        (if_ir(11 downto 8)="0000") ) )       -- -- immediate = 0
    else '0';

  shift_lsl <= '1' when if_ir(25) = '0' and if_ir(6 downto 5) = "00" else '0';
  shift_lsr <= '1' when if_ir(25) = '0' and if_ir(6 downto 5) = "01" else '0';
  shift_asr <= '1' when if_ir(25) = '0' and if_ir(6 downto 5) = "10" else '0';
  shift_rrx <= '1' when if_ir(25) = '0' and if_ir(6 downto 5) = "11"
                        and shift_is_zero = '1'                      else '0';
  shift_ror <= '1' when if_ir(25) = '1' or (if_ir(25) = '0'
                        and if_ir(6 downto 5) = "11"
                        and shift_is_zero = '0')                     else '0';
                  
	shift_val <= "00010"                  when branch_t = '1' else
               -- op2 is imm
               if_ir(11 downto 8) & '0' when regop_t='1' and if_ir(25)='1' else
               -- op2 is reg, shift is imm
               if_ir(11 downto 7)       when regop_t='1' and if_ir(25)='0'
                                             and if_ir(4)='0' else 
               -- op2 is reg, shift is reg
               rdata3(4 downto 0)       when regop_t='1' and if_ir(25)='0'
                                             and if_ir(4)='1' else 
               "00000";

------------------------- Writeback --------------------------------------------

  alu_wb	 <= '1' when (regop_t = '1' and if_ir(24 downto 21) = X"0")   --AND
                    or (regop_t = '1' and if_ir(24 downto 21) = X"1")   --EOR
                    or (regop_t = '1' and if_ir(24 downto 21) = X"2")   --SUB
                    or (regop_t = '1' and if_ir(24 downto 21) = X"3")   --RSB
                    or (regop_t = '1' and if_ir(24 downto 21) = X"4")   --ADD
                    or (regop_t = '1' and if_ir(24 downto 21) = X"5")   --ADC
                    or (regop_t = '1' and if_ir(24 downto 21) = X"6")   --SBC
                    or (regop_t = '1' and if_ir(24 downto 21) = X"7")   --RSC
                    or (regop_t = '1' and if_ir(24 downto 21) = X"C")   --ORR
                    or (regop_t = '1' and if_ir(24 downto 21) = X"D")   --MOV
                    or (regop_t = '1' and if_ir(24 downto 21) = X"E")   --BIC
                    or (regop_t = '1' and if_ir(24 downto 21) = X"F")   --MNV
         else '0';

  flag_wb	<=  '1' when (regop_t = '1' and if_ir(24 downto 21) = X"8") --TST
                    or (regop_t = '1' and if_ir(24 downto 21) = X"9") --TEQ
                    or (regop_t = '1' and if_ir(24 downto 21) = X"A") --CMP
                    or (regop_t = '1' and if_ir(24 downto 21) = X"B") --CMN
         else if_ir(20);

-- =============================================================================
-- == @@ ==========  MEM  ======================================================
-- =============================================================================

  ----- Destination register
  ld_dest <= if_ir(15 downto 12);

  ----- Options
  pre_index <=if_ir(24);

  ----- Data
  mem_data <= x"00000000" when trans_t='0' else x"00000000";

  ----- Operation type
	mem_lw <= ldr_i;
	mem_lb <= ldrb_i;
	mem_sw <= str_i;
	mem_sb <= strb_i;

-- =============================================================================
-- == @@ ==========  Operands  =================================================
-- =============================================================================

------------------------- Operand retrieving -----------------------------------
  -- radr1 = Rn
  radr1 <= if_ir(15 downto 12) when mult_t = '1' else
           if_ir(19 downto 16);
				
  -- radr2 = Rm
  radr2 <= if_ir(3 downto 0);

  -- radr3 = Rs for regop and mult, Rd otherwise
  radr3 <= if_ir(11 downto  8) when regop_t = '1' or mult_t = '1' else
           if_ir(15 downto 12);

------------------------- Operand Validity -------------------------------------
  -- Operands are valid when :
  ----- for regops :
  ----- Rn is valid
  ----- and Rm is valid or unused
  ----- and Rs is valid or unused
  -----
  ----- an instruction can be executed only when read registers are deemed valid 
  ----- We can consider a register valid even when its validity bit is 0,
  ----- that happens when an instruction reads and writes a same register :
  ----- it invalidates it but even once it gets written back,
  ----- since the invalidation supersedes in REG we'll never see
  ----- its validity bit going to 1,
  ----- (this is a situation of signal ingored hence never received)
  ----- In order not to get stuck, watch the reg_wb bits :
  ----- operands are valid when validity bit = 1
  ----- OR WHEN IT'S BEEN WRITTEN BACK LAST CYCLE
  ----- AND GOT INVALIDATED BACK BY THE CURRENT INSTRUCTION

  operv  <= '1'   when regop_t = '1'
                   and ( rvalid1 = '1' or reg_wb1 = '1')
                   and ( rvalid2 = '1' or reg_wb2 = '1' or if_ir(25) = '1')   
                   and ( rvalid3 = '1' or reg_wb3 = '1'
                                       or (if_ir(25) = '1'   
                                       or if_ir(4) = '1'))
       else '1'   when regop_t = '0'
			 else '0';

-- =============================================================================
-- == @@ ==========  Invalidation  =============================================
-- =============================================================================

------------------------- Registers Invalidation -------------------------------
  -- The destination register is always Rd
  inval_exe_adr <=  if_ir(19 downto 16)   when mult_t = '1'        else
                 -- else  x"F"                  when branch_t = '1'
                 -- (we'll take care of branches later...)
                    if_ir(15 downto 12);

  inval_exe     <=  '1' when ( regop_t = '1' and
                        not (teq_i='1' or tst_i='1' or cmp_i='1' or cmn_i='1') )
                        else 
                        -- or
                        -- branch_t = '1'
                        -- (we'll take care of branches later...)
                    '0';

  inval_mem_adr <=  if_ir(15 downto 12)   when trans_t = '1'         else
                    mtrans_rd;

  inval_mem     <= '1'  when trans_t = '1' and (ldr_i='1' or ldrb_i='1') else
                   '0';

------------------------- Flags Invalidation -----------------------------------
  inval_czn     <= '1'  when regop_t = '1' and
                        (teq_i='1' or tst_i='1' or cmp_i='1' or cmn_i='1') else
                   if_ir(20);  -- S flag
			

  inval_ovr     <= if_ir(20)   when regop_t = '1' and not(
                               teq_i='1' or tst_i='1' or cmp_i='1' or cmn_i='1')
             else  '0';

-- =============================================================================
-- == @@ ==========  Multiple Transferts  ======================================
-- =============================================================================

  ----- Mtrans reg list
	process (ck)
	begin
		if (rising_edge(ck)) then
		--....
		end if;
	end process;

	mtrans_mask_shift <= X"FFFE" when if_ir(0) = '1' and mtrans_mask(0) = '1' else
								X"FFFC" when if_ir(1) = '1' and mtrans_mask(1) = '1' else
								X"FFF8" when if_ir(2) = '1' and mtrans_mask(2) = '1' else
								X"FFF0" when if_ir(3) = '1' and mtrans_mask(3) = '1' else
								X"FFE0" when if_ir(4) = '1' and mtrans_mask(4) = '1' else
								X"FFC0" when if_ir(5) = '1' and mtrans_mask(5) = '1' else
								X"FF80" when if_ir(6) = '1' and mtrans_mask(6) = '1' else
								X"FF00" when if_ir(7) = '1' and mtrans_mask(7) = '1' else
								X"FE00" when if_ir(8) = '1' and mtrans_mask(8) = '1' else
								X"FC00" when if_ir(9) = '1' and mtrans_mask(9) = '1' else
								X"F800" when if_ir(10) = '1' and mtrans_mask(10) = '1' else
								X"F000" when if_ir(11) = '1' and mtrans_mask(11) = '1' else
								X"E000" when if_ir(12) = '1' and mtrans_mask(12) = '1' else
								X"C000" when if_ir(13) = '1' and mtrans_mask(13) = '1' else
								X"8000" when if_ir(14) = '1' and mtrans_mask(14) = '1' else
								X"0000";

	mtrans_list <= if_ir(15 downto 0) and mtrans_mask;

	process (mtrans_list)
	begin
	end process;

	mtrans_1un <= '1' when mtrans_nbr = "00001" else '0';


	mtrans_rd <=	X"0" when mtrans_list(0) = '1' else
						X"1" when mtrans_list(1) = '1' else
						X"2" when mtrans_list(2) = '1' else
						X"3" when mtrans_list(3) = '1' else
						X"4" when mtrans_list(4) = '1' else
						X"5" when mtrans_list(5) = '1' else
						X"6" when mtrans_list(6) = '1' else
						X"7" when mtrans_list(7) = '1' else
						X"8" when mtrans_list(8) = '1' else
						X"9" when mtrans_list(9) = '1' else
						X"A" when mtrans_list(10) = '1' else
						X"B" when mtrans_list(11) = '1' else
						X"C" when mtrans_list(12) = '1' else
						X"D" when mtrans_list(13) = '1' else
						X"E" when mtrans_list(14) = '1' else
						X"F";

-- =============================================================================
-- == @@ ==========  Finite State Machine  =====================================
-- =============================================================================

------------------------- Register process -------------------------------------
  process (ck)
  begin

  if (rising_edge(ck)) then
	  if (reset_n = '0') then
		  cur_state <= FETCH;
	  else
		  cur_state <= next_state;
	  end if;
  end if;
  
  end process;

------------------------- Combinatory process ----------------------------------
  --state machine process.
  process (cur_state, dec2if_full, cond, condv, operv, dec2exe_full,
           if2dec_empty, reg_pcv, bl_i, branch_t, and_i, eor_i, sub_i, rsb_i,
           add_i, adc_i, sbc_i, rsc_i, orr_i, mov_i, bic_i, mvn_i, ldr_i,
           ldrb_i, ldm_i, stm_i, if_ir, mtrans_rd, mtrans_mask_shift)
  begin
      case cur_state is

          ---------------------- FETCH --------------------
          when FETCH =>
              debug_state <= X"1";
              dec2if_push <= '0';
              if2dec_pop <= '0';
              dec2exe_push <= '0';
              blink <= '0';
              mtrans_shift <= '0';
              mtrans_loop_adr <= '0';
  
              if dec2if_full = '0' and reg_pcv = '1' then -- if not(T1)
                  next_state <= RUN;
              else
                  next_state <= FETCH;
              end if;

          ---------------------- RUN ----------------------
          when RUN =>
              --if dec2if_full = '0' then
                  --dec2if_push <= '1';
              --end if;
              dec2if_push <= not dec2if_full;
  
              -- If FIFOs are stuck or some metadata is invalid
              if if2dec_empty = '1' or dec2exe_full = '1' or condv = '0' then
                  if2dec_pop <= '1';
                  next_state <= RUN;
                  debug_state <= X"2";
  
              -- If the predicate is false, throw away the instruction
              elsif cond = '0' then
                  if2dec_pop <= '1';
                  dec2exe_push <= '0';
                  next_state <= RUN;
                  debug_state <= X"3";
  
              -- If the predicate is true...
              elsif cond = '1' then
                  -- If operands are valid, launch the instruction in EXE
                  if (operv = '1') then
                      if2dec_pop <= '1';
                      dec2exe_push <= '1';
                      next_state <= RUN;
                      debug_state <= X"4";
                  -- If operands are not valid, hold still, wait for write back
                  else
                      if2dec_pop <= '0';
                      dec2exe_push <= '0';
                      next_state <= RUN;
                      debug_state <= X"5";
                  end if;
              end if;
  
          ---------------------- Default state ------------
          when others =>
              debug_state <= X"0";
              if2dec_pop <= '0';
              dec2if_push <= '0';
              dec2exe_push <= '0';
              next_state <= UNDEFINED;
      end case;
  end process;

-- =============================================================================
-- == @@ ==========  Others  ===================================================
-- =============================================================================

  inc_pc <= dec2if_push;
  dec_pop <= if2dec_pop;

end Behavior;
