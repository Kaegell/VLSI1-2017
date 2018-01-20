library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg is
    port(
        -- Write Port 1 prioritaire
            wdata1		: in Std_Logic_Vector(31 downto 0);
            wadr1			: in Std_Logic_Vector(3 downto 0);
            wen1			: in Std_Logic;

        -- Write Port 2 non prioritaire
            wdata2		: in Std_Logic_Vector(31 downto 0);
            wadr2			: in Std_Logic_Vector(3 downto 0);
            wen2			: in Std_Logic;

        -- Write CSPR Port
            wcry			: in Std_Logic;
            wzero			: in Std_Logic;
            wneg			: in Std_Logic;
            wovr			: in Std_Logic;
            cspr_wb		: in Std_Logic;

        -- Read Port 1 32 bits
            reg_rd1		: out Std_Logic_Vector(31 downto 0);
            radr1			: in Std_Logic_Vector(3 downto 0);
            reg_v1		: out Std_Logic;

        -- Read Port 2 32 bits
            reg_rd2		: out Std_Logic_Vector(31 downto 0);
            radr2			: in Std_Logic_Vector(3 downto 0);
            reg_v2		: out Std_Logic;

        -- Read Port 3 32 bits
            reg_rd3		: out Std_Logic_Vector(31 downto 0);
            radr3			: in Std_Logic_Vector(3 downto 0);
            reg_v3		: out Std_Logic;

        -- read CSPR Port
            reg_cry		: out Std_Logic;
            reg_zero		: out Std_Logic;
            reg_neg		: out Std_Logic;
            reg_cznv		: out Std_Logic;
            reg_ovr		: out Std_Logic;
            reg_vv		: out Std_Logic;

        -- Invalidate Port 
            inval_adr1	: in Std_Logic_Vector(3 downto 0);
            inval1		: in Std_Logic;

            inval_adr2	: in Std_Logic_Vector(3 downto 0);
            inval2		: in Std_Logic;

            inval_czn	: in Std_Logic;
            inval_ovr	: in Std_Logic;

        -- PC
            reg_pc		: out Std_Logic_Vector(31 downto 0);
            reg_pcv		: out Std_Logic;
            inc_pc		: in Std_Logic;

        -- global interface
            ck				: in Std_Logic;
            reset_n		: in Std_Logic;
            vdd			: in bit;
            vss			: in bit);
end Reg;

architecture Reg of Reg is
    type REG_array is array (0 to 15) of std_logic_vector (31 downto 0);
    signal registers : REG_array;
    signal inval_regs: std_logic_vector (0 to 15);
    signal cry_sig : std_logic;
    signal zero_sig : std_logic;
    signal neg_sig : std_logic;
    signal ovr_sig : std_logic;
    signal r0  : std_logic_vector (31 downto 0);
    signal r1  : std_logic_vector (31 downto 0);
    signal r2  : std_logic_vector (31 downto 0);
    signal r3  : std_logic_vector (31 downto 0);
    signal r4  : std_logic_vector (31 downto 0);
    signal r5  : std_logic_vector (31 downto 0);
    signal r6  : std_logic_vector (31 downto 0);
    signal r7  : std_logic_vector (31 downto 0);
    signal r8  : std_logic_vector (31 downto 0);
    signal r9  : std_logic_vector (31 downto 0);
    signal r10 : std_logic_vector (31 downto 0);
    signal r11 : std_logic_vector (31 downto 0);
    signal r12 : std_logic_vector (31 downto 0);
    signal r13 : std_logic_vector (31 downto 0);
    signal r14 : std_logic_vector (31 downto 0);
    signal r15 : std_logic_vector (31 downto 0);
begin
    process(ck)
    begin
        -- Invalidate all registers when reset (asynchronously)
        if reset_n = '0' then
            inval_regs(0 to 15) <= (others => '0');
            -- Registers init.
            registers(15) <= X"00000000";
            reg_pcv   <= '1';
            reg_cry   <= '0';
            reg_zero  <= '1';
            reg_neg   <= '0';
            reg_ovr   <= '0';
            reg_cznv  <= '0';
            reg_vv    <= '1';
            for i in 0 to 14 loop
              registers(i) <= x"00000000";
            end loop;

        elsif rising_edge(ck) then

            -- =================================  INVALIDATION  ===================================
            -- --------------------------------------------------
            -- | inval1  |  wen1  ||  valid1(t)   | invalid1(t) |
            -- |---------|--------||--------------|-------------|
            -- |      0  |     0  ||  valid1(t-1) | invalid1(t) |
            -- |      0  |     1  ||            1 |           0 |
            -- |      1  |     0  ||            0 |           1 |
            -- |      1  |     1  ||            0 |           1 |
            -- --------------------------------------------------

            -- Invalidate registers (from DECOD)
            if (inval1 = '1' or wen1 = '1')
            then
              inval_regs(to_integer(unsigned(inval_adr1))) <= inval1;
            end if;

            if (inval2 = '1' or wen2 = '1')
            then
              inval_regs(to_integer(unsigned(inval_adr2))) <= inval2;
            end if;

            -- ======================================  PC  ========================================
            -- PC increment operator
            -- if inval_regs(15) = '1' and inc_pc = '1' then
            if inc_pc = '1' then
                registers(15) <= std_logic_vector(to_unsigned(to_integer(unsigned(registers(15))) + 4, 32));
                --inval_regs(15) <= '0';
            --else
                --pc_sig <= unsigned(registers(15));
            end if;

            -- =====================================  READ  =======================================
            -- PC setup and remapping to output
            reg_pcv <= not inval_regs(15);

            -- Rd1 writeback
            reg_rd1 <= registers(to_integer(unsigned(radr1))); 
            reg_v1 <= not inval_regs(to_integer(unsigned(radr1)));

            -- Rd2 writeback
            reg_rd2 <= registers(to_integer(unsigned(radr2))); 
            reg_v2 <= not inval_regs(to_integer(unsigned(radr2)));

            -- Rd3 writeback
            reg_rd3 <= registers(to_integer(unsigned(radr3))); 
            reg_v3 <= not inval_regs(to_integer(unsigned(radr3)));

            -- =====================================  WRITE  ======================================
            -- EXE and MEM can both write back in REG at the same time,
            -- but if they both want to write the same register,
            -- we take EXE's value, EXE is prioritary.

            -- EXE writeback
            if wen1 = '1'                           -- if EXE wants to write back
            then
              registers(to_integer(unsigned(wadr1))) <= wdata1;
            end if;

            if wen2 = '1' and not (wadr1 = wadr2)   -- If MEM wants to write back
            then
              registers(to_integer(unsigned(wadr2))) <= wdata2;
            end if;

            -- EXEC/MEM Write-back priority handling
            -- (if writeback from EXEC, ignore writeback
            -- from MEM)
            --if wen1 = '1' and wadr1 = wadr2 and
            --inval_regs(to_integer(unsigned(wadr1))) = '1'
            --then
                --registers(to_integer(unsigned(wadr1))) <= wdata1;
                --inval_regs(to_integer(unsigned(wadr1))) <= '0';
            --else
                ---- Handle EXEC/MEM Write-back as usual
                ---- (check invalidity register for each Rd)
                --if wen1 = '1' and
                --inval_regs(to_integer(unsigned(wadr1))) = '1'
                --then
                    --registers(to_integer(unsigned(wadr1))) <= wdata2;
                    --inval_regs(to_integer(unsigned(wadr1))) <= '0';
                --elsif wen2 = '1' and
                --inval_regs(to_integer(unsigned(wadr2))) = '1'
                --then
                    --registers(to_integer(unsigned(wadr2))) <= wdata2;
                    --inval_regs(to_integer(unsigned(wadr2))) <= '0';
                --end if;
            --end if;

            -- CSPR Flags Update
            -- C,Z,N updated when logical operations
            -- V updated when arithmetical operation
            -- (cf. DECOD description)
            if inval_czn = '1' then
                reg_cry <= wcry;
                reg_zero <= wzero;
                reg_neg <= wneg;
            end if;
            if inval_ovr <= '1' then
                reg_ovr <= wovr;
            end if;
        end if;
    end process;
    reg_pc <= registers(15);

    -- Assign register array to signals, in order to be able to see the registers in gtkwave
    r0 <= registers(0);
    r1 <= registers(1);
    r2 <= registers(2);
    r3 <= registers(3);
    r4 <= registers(4);
    r5 <= registers(5);
    r6 <= registers(6);
    r7 <= registers(7);
    r8 <= registers(8);
    r9 <= registers(9);
    r10 <= registers(10);
    r11 <= registers(11);
    r12 <= registers(12);
    r13 <= registers(13);
    r14 <= registers(14);
    r15 <= registers(15);
end architecture;
