-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2018.3
-- Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dense_layer2 is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    input_V_address0 : OUT STD_LOGIC_VECTOR (6 downto 0);
    input_V_ce0 : OUT STD_LOGIC;
    input_V_q0 : IN STD_LOGIC_VECTOR (6 downto 0);
    output_V_address0 : OUT STD_LOGIC_VECTOR (6 downto 0);
    output_V_ce0 : OUT STD_LOGIC;
    output_V_we0 : OUT STD_LOGIC;
    output_V_d0 : OUT STD_LOGIC_VECTOR (6 downto 0) );
end;


architecture behav of dense_layer2 is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state1 : STD_LOGIC_VECTOR (4 downto 0) := "00001";
    constant ap_ST_fsm_state2 : STD_LOGIC_VECTOR (4 downto 0) := "00010";
    constant ap_ST_fsm_state3 : STD_LOGIC_VECTOR (4 downto 0) := "00100";
    constant ap_ST_fsm_pp0_stage0 : STD_LOGIC_VECTOR (4 downto 0) := "01000";
    constant ap_ST_fsm_state7 : STD_LOGIC_VECTOR (4 downto 0) := "10000";
    constant ap_const_boolean_1 : BOOLEAN := true;
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_lv32_1 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv32_2 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000010";
    constant ap_const_lv32_3 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000011";
    constant ap_const_boolean_0 : BOOLEAN := false;
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv7_0 : STD_LOGIC_VECTOR (6 downto 0) := "0000000";
    constant ap_const_lv32_4 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000100";
    constant ap_const_lv7_54 : STD_LOGIC_VECTOR (6 downto 0) := "1010100";
    constant ap_const_lv7_1 : STD_LOGIC_VECTOR (6 downto 0) := "0000001";
    constant ap_const_lv3_0 : STD_LOGIC_VECTOR (2 downto 0) := "000";
    constant ap_const_lv2_3 : STD_LOGIC_VECTOR (1 downto 0) := "11";
    constant ap_const_lv2_0 : STD_LOGIC_VECTOR (1 downto 0) := "00";
    constant ap_const_lv7_78 : STD_LOGIC_VECTOR (6 downto 0) := "1111000";
    constant ap_const_lv32_A : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000001010";
    constant ap_const_lv32_7 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000111";
    constant ap_const_lv8_7F : STD_LOGIC_VECTOR (7 downto 0) := "01111111";
    constant ap_const_lv32_8 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000001000";
    constant ap_const_lv8_80 : STD_LOGIC_VECTOR (7 downto 0) := "10000000";
    constant ap_const_lv8_0 : STD_LOGIC_VECTOR (7 downto 0) := "00000000";

    signal ap_CS_fsm : STD_LOGIC_VECTOR (4 downto 0) := "00001";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_state1 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state1 : signal is "none";
    signal dense_2_biases_V_address0 : STD_LOGIC_VECTOR (6 downto 0);
    signal dense_2_biases_V_ce0 : STD_LOGIC;
    signal dense_2_biases_V_q0 : STD_LOGIC_VECTOR (1 downto 0);
    signal dense_2_weights_V_address0 : STD_LOGIC_VECTOR (13 downto 0);
    signal dense_2_weights_V_ce0 : STD_LOGIC;
    signal dense_2_weights_V_q0 : STD_LOGIC_VECTOR (3 downto 0);
    signal p_Val2_17_reg_146 : STD_LOGIC_VECTOR (7 downto 0);
    signal i_reg_156 : STD_LOGIC_VECTOR (6 downto 0);
    signal p_2_fu_173_p2 : STD_LOGIC_VECTOR (6 downto 0);
    signal p_2_reg_462 : STD_LOGIC_VECTOR (6 downto 0);
    signal ap_CS_fsm_state2 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state2 : signal is "none";
    signal tmp_fu_179_p1 : STD_LOGIC_VECTOR (63 downto 0);
    signal tmp_reg_467 : STD_LOGIC_VECTOR (63 downto 0);
    signal exitcond3_fu_167_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_18_fu_208_p2 : STD_LOGIC_VECTOR (14 downto 0);
    signal tmp_18_reg_477 : STD_LOGIC_VECTOR (14 downto 0);
    signal ap_CS_fsm_state3 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state3 : signal is "none";
    signal p_Val2_23_cast_fu_240_p1 : STD_LOGIC_VECTOR (7 downto 0);
    signal exitcond_fu_244_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal exitcond_reg_487 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_CS_fsm_pp0_stage0 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_pp0_stage0 : signal is "none";
    signal ap_block_state4_pp0_stage0_iter0 : BOOLEAN;
    signal ap_block_state5_pp0_stage0_iter1 : BOOLEAN;
    signal ap_block_state6_pp0_stage0_iter2 : BOOLEAN;
    signal ap_block_pp0_stage0_11001 : BOOLEAN;
    signal exitcond_reg_487_pp0_iter1_reg : STD_LOGIC_VECTOR (0 downto 0);
    signal i_3_fu_250_p2 : STD_LOGIC_VECTOR (6 downto 0);
    signal ap_enable_reg_pp0_iter0 : STD_LOGIC := '0';
    signal r_V_fu_283_p2 : STD_LOGIC_VECTOR (10 downto 0);
    signal r_V_reg_506 : STD_LOGIC_VECTOR (10 downto 0);
    signal tmp_28_reg_511 : STD_LOGIC_VECTOR (6 downto 0);
    signal tmp_29_reg_516 : STD_LOGIC_VECTOR (0 downto 0);
    signal p_0249_3_fu_432_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal ap_enable_reg_pp0_iter2 : STD_LOGIC := '0';
    signal ap_block_pp0_stage0_subdone : BOOLEAN;
    signal ap_condition_pp0_exit_iter0_state4 : STD_LOGIC;
    signal ap_enable_reg_pp0_iter1 : STD_LOGIC := '0';
    signal p_reg_134 : STD_LOGIC_VECTOR (6 downto 0);
    signal ap_CS_fsm_state7 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state7 : signal is "none";
    signal tmp_22_cast_fu_270_p1 : STD_LOGIC_VECTOR (63 downto 0);
    signal ap_block_pp0_stage0 : BOOLEAN;
    signal tmp_13_fu_256_p1 : STD_LOGIC_VECTOR (63 downto 0);
    signal tmp_16_fu_184_p3 : STD_LOGIC_VECTOR (13 downto 0);
    signal tmp_17_fu_196_p3 : STD_LOGIC_VECTOR (9 downto 0);
    signal p_shl_cast_fu_192_p1 : STD_LOGIC_VECTOR (14 downto 0);
    signal p_shl1_cast_fu_204_p1 : STD_LOGIC_VECTOR (14 downto 0);
    signal tmp_25_fu_214_p3 : STD_LOGIC_VECTOR (0 downto 0);
    signal inner_state_V_cast_fu_222_p3 : STD_LOGIC_VECTOR (1 downto 0);
    signal tmp_cast_fu_230_p1 : STD_LOGIC_VECTOR (1 downto 0);
    signal p_Val2_20_fu_234_p2 : STD_LOGIC_VECTOR (1 downto 0);
    signal tmp_13_cast_fu_261_p1 : STD_LOGIC_VECTOR (14 downto 0);
    signal tmp_19_fu_265_p2 : STD_LOGIC_VECTOR (14 downto 0);
    signal r_V_fu_283_p0 : STD_LOGIC_VECTOR (3 downto 0);
    signal r_V_fu_283_p1 : STD_LOGIC_VECTOR (6 downto 0);
    signal tmp_18_cast_fu_317_p1 : STD_LOGIC_VECTOR (7 downto 0);
    signal p_Val2_12_fu_314_p1 : STD_LOGIC_VECTOR (7 downto 0);
    signal p_Val2_13_fu_320_p2 : STD_LOGIC_VECTOR (7 downto 0);
    signal p_Result_s_fu_307_p3 : STD_LOGIC_VECTOR (0 downto 0);
    signal p_Result_9_fu_326_p3 : STD_LOGIC_VECTOR (0 downto 0);
    signal phitmp_fu_334_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal p_Val2_14_fu_342_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal lhs_V_fu_350_p1 : STD_LOGIC_VECTOR (8 downto 0);
    signal rhs_V_fu_354_p1 : STD_LOGIC_VECTOR (8 downto 0);
    signal ret_V_fu_358_p2 : STD_LOGIC_VECTOR (8 downto 0);
    signal inner_state_V_fu_372_p2 : STD_LOGIC_VECTOR (7 downto 0);
    signal p_Result_11_fu_378_p3 : STD_LOGIC_VECTOR (0 downto 0);
    signal p_Result_10_fu_364_p3 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_15_fu_386_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal signbit_i_i_0_not_fu_404_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal brmerge_fu_398_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal underflow_fu_392_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal brmerge12_fu_410_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal p_mux_fu_416_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal p_s_fu_424_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal tmp_11_fu_444_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_26_fu_440_p1 : STD_LOGIC_VECTOR (6 downto 0);
    signal ap_NS_fsm : STD_LOGIC_VECTOR (4 downto 0);
    signal ap_idle_pp0 : STD_LOGIC;
    signal ap_enable_pp0 : STD_LOGIC;
    signal r_V_fu_283_p10 : STD_LOGIC_VECTOR (10 downto 0);

    component dense_layer2_dense_2_biases_V IS
    generic (
        DataWidth : INTEGER;
        AddressRange : INTEGER;
        AddressWidth : INTEGER );
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR (6 downto 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR (1 downto 0) );
    end component;


    component dense_layer2_dense_2_weights_V IS
    generic (
        DataWidth : INTEGER;
        AddressRange : INTEGER;
        AddressWidth : INTEGER );
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR (13 downto 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR (3 downto 0) );
    end component;



begin
    dense_2_biases_V_U : component dense_layer2_dense_2_biases_V
    generic map (
        DataWidth => 2,
        AddressRange => 84,
        AddressWidth => 7)
    port map (
        clk => ap_clk,
        reset => ap_rst,
        address0 => dense_2_biases_V_address0,
        ce0 => dense_2_biases_V_ce0,
        q0 => dense_2_biases_V_q0);

    dense_2_weights_V_U : component dense_layer2_dense_2_weights_V
    generic map (
        DataWidth => 4,
        AddressRange => 10080,
        AddressWidth => 14)
    port map (
        clk => ap_clk,
        reset => ap_rst,
        address0 => dense_2_weights_V_address0,
        ce0 => dense_2_weights_V_ce0,
        q0 => dense_2_weights_V_q0);





    ap_CS_fsm_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_CS_fsm <= ap_ST_fsm_state1;
            else
                ap_CS_fsm <= ap_NS_fsm;
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter0_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter0 <= ap_const_logic_0;
            else
                if (((ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_logic_1 = ap_condition_pp0_exit_iter0_state4) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone))) then 
                    ap_enable_reg_pp0_iter0 <= ap_const_logic_0;
                elsif ((ap_const_logic_1 = ap_CS_fsm_state3)) then 
                    ap_enable_reg_pp0_iter0 <= ap_const_logic_1;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter1_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter1 <= ap_const_logic_0;
            else
                if ((ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) then
                    if ((ap_const_logic_1 = ap_condition_pp0_exit_iter0_state4)) then 
                        ap_enable_reg_pp0_iter1 <= (ap_const_logic_1 xor ap_condition_pp0_exit_iter0_state4);
                    elsif ((ap_const_boolean_1 = ap_const_boolean_1)) then 
                        ap_enable_reg_pp0_iter1 <= ap_enable_reg_pp0_iter0;
                    end if;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter2_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter2 <= ap_const_logic_0;
            else
                if ((ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) then 
                    ap_enable_reg_pp0_iter2 <= ap_enable_reg_pp0_iter1;
                elsif ((ap_const_logic_1 = ap_CS_fsm_state3)) then 
                    ap_enable_reg_pp0_iter2 <= ap_const_logic_0;
                end if; 
            end if;
        end if;
    end process;


    i_reg_156_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (exitcond_fu_244_p2 = ap_const_lv1_0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
                i_reg_156 <= i_3_fu_250_p2;
            elsif ((ap_const_logic_1 = ap_CS_fsm_state3)) then 
                i_reg_156 <= ap_const_lv7_0;
            end if; 
        end if;
    end process;

    p_Val2_17_reg_146_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (exitcond_reg_487_pp0_iter1_reg = ap_const_lv1_0) and (ap_enable_reg_pp0_iter2 = ap_const_logic_1))) then 
                p_Val2_17_reg_146 <= p_0249_3_fu_432_p3;
            elsif ((ap_const_logic_1 = ap_CS_fsm_state3)) then 
                p_Val2_17_reg_146 <= p_Val2_23_cast_fu_240_p1;
            end if; 
        end if;
    end process;

    p_reg_134_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_CS_fsm_state7)) then 
                p_reg_134 <= p_2_reg_462;
            elsif (((ap_const_logic_1 = ap_CS_fsm_state1) and (ap_start = ap_const_logic_1))) then 
                p_reg_134 <= ap_const_lv7_0;
            end if; 
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then
                exitcond_reg_487 <= exitcond_fu_244_p2;
                exitcond_reg_487_pp0_iter1_reg <= exitcond_reg_487;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_CS_fsm_state2)) then
                p_2_reg_462 <= p_2_fu_173_p2;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (exitcond_reg_487 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then
                r_V_reg_506 <= r_V_fu_283_p2;
                tmp_28_reg_511 <= r_V_fu_283_p2(10 downto 4);
                tmp_29_reg_516 <= r_V_fu_283_p2(3 downto 3);
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_CS_fsm_state3)) then
                    tmp_18_reg_477(14 downto 3) <= tmp_18_fu_208_p2(14 downto 3);
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((exitcond3_fu_167_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state2))) then
                    tmp_reg_467(6 downto 0) <= tmp_fu_179_p1(6 downto 0);
            end if;
        end if;
    end process;
    tmp_reg_467(63 downto 7) <= "000000000000000000000000000000000000000000000000000000000";
    tmp_18_reg_477(2 downto 0) <= "000";

    ap_NS_fsm_assign_proc : process (ap_start, ap_CS_fsm, ap_CS_fsm_state1, ap_CS_fsm_state2, exitcond3_fu_167_p2, exitcond_fu_244_p2, ap_enable_reg_pp0_iter0, ap_enable_reg_pp0_iter2, ap_block_pp0_stage0_subdone, ap_enable_reg_pp0_iter1)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state1 => 
                if (((ap_const_logic_1 = ap_CS_fsm_state1) and (ap_start = ap_const_logic_1))) then
                    ap_NS_fsm <= ap_ST_fsm_state2;
                else
                    ap_NS_fsm <= ap_ST_fsm_state1;
                end if;
            when ap_ST_fsm_state2 => 
                if (((exitcond3_fu_167_p2 = ap_const_lv1_1) and (ap_const_logic_1 = ap_CS_fsm_state2))) then
                    ap_NS_fsm <= ap_ST_fsm_state1;
                else
                    ap_NS_fsm <= ap_ST_fsm_state3;
                end if;
            when ap_ST_fsm_state3 => 
                ap_NS_fsm <= ap_ST_fsm_pp0_stage0;
            when ap_ST_fsm_pp0_stage0 => 
                if ((not(((exitcond_fu_244_p2 = ap_const_lv1_1) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_enable_reg_pp0_iter1 = ap_const_logic_0) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone))) and not(((ap_enable_reg_pp0_iter2 = ap_const_logic_1) and (ap_enable_reg_pp0_iter1 = ap_const_logic_0) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone))))) then
                    ap_NS_fsm <= ap_ST_fsm_pp0_stage0;
                elsif ((((ap_enable_reg_pp0_iter2 = ap_const_logic_1) and (ap_enable_reg_pp0_iter1 = ap_const_logic_0) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) or ((exitcond_fu_244_p2 = ap_const_lv1_1) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_enable_reg_pp0_iter1 = ap_const_logic_0) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone)))) then
                    ap_NS_fsm <= ap_ST_fsm_state7;
                else
                    ap_NS_fsm <= ap_ST_fsm_pp0_stage0;
                end if;
            when ap_ST_fsm_state7 => 
                ap_NS_fsm <= ap_ST_fsm_state2;
            when others =>  
                ap_NS_fsm <= "XXXXX";
        end case;
    end process;
    ap_CS_fsm_pp0_stage0 <= ap_CS_fsm(3);
    ap_CS_fsm_state1 <= ap_CS_fsm(0);
    ap_CS_fsm_state2 <= ap_CS_fsm(1);
    ap_CS_fsm_state3 <= ap_CS_fsm(2);
    ap_CS_fsm_state7 <= ap_CS_fsm(4);
        ap_block_pp0_stage0 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_pp0_stage0_11001 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_pp0_stage0_subdone <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_state4_pp0_stage0_iter0 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_state5_pp0_stage0_iter1 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_state6_pp0_stage0_iter2 <= not((ap_const_boolean_1 = ap_const_boolean_1));

    ap_condition_pp0_exit_iter0_state4_assign_proc : process(exitcond_fu_244_p2)
    begin
        if ((exitcond_fu_244_p2 = ap_const_lv1_1)) then 
            ap_condition_pp0_exit_iter0_state4 <= ap_const_logic_1;
        else 
            ap_condition_pp0_exit_iter0_state4 <= ap_const_logic_0;
        end if; 
    end process;


    ap_done_assign_proc : process(ap_start, ap_CS_fsm_state1, ap_CS_fsm_state2, exitcond3_fu_167_p2)
    begin
        if ((((exitcond3_fu_167_p2 = ap_const_lv1_1) and (ap_const_logic_1 = ap_CS_fsm_state2)) or ((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1)))) then 
            ap_done <= ap_const_logic_1;
        else 
            ap_done <= ap_const_logic_0;
        end if; 
    end process;

    ap_enable_pp0 <= (ap_idle_pp0 xor ap_const_logic_1);

    ap_idle_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_idle <= ap_const_logic_1;
        else 
            ap_idle <= ap_const_logic_0;
        end if; 
    end process;


    ap_idle_pp0_assign_proc : process(ap_enable_reg_pp0_iter0, ap_enable_reg_pp0_iter2, ap_enable_reg_pp0_iter1)
    begin
        if (((ap_enable_reg_pp0_iter0 = ap_const_logic_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_0) and (ap_enable_reg_pp0_iter2 = ap_const_logic_0))) then 
            ap_idle_pp0 <= ap_const_logic_1;
        else 
            ap_idle_pp0 <= ap_const_logic_0;
        end if; 
    end process;


    ap_ready_assign_proc : process(ap_CS_fsm_state2, exitcond3_fu_167_p2)
    begin
        if (((exitcond3_fu_167_p2 = ap_const_lv1_1) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
            ap_ready <= ap_const_logic_1;
        else 
            ap_ready <= ap_const_logic_0;
        end if; 
    end process;

    brmerge12_fu_410_p2 <= (signbit_i_i_0_not_fu_404_p2 or p_Result_11_fu_378_p3);
    brmerge_fu_398_p2 <= (p_Result_11_fu_378_p3 xor p_Result_10_fu_364_p3);
    dense_2_biases_V_address0 <= tmp_fu_179_p1(7 - 1 downto 0);

    dense_2_biases_V_ce0_assign_proc : process(ap_CS_fsm_state2)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
            dense_2_biases_V_ce0 <= ap_const_logic_1;
        else 
            dense_2_biases_V_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    dense_2_weights_V_address0 <= tmp_22_cast_fu_270_p1(14 - 1 downto 0);

    dense_2_weights_V_ce0_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_block_pp0_stage0_11001, ap_enable_reg_pp0_iter0)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            dense_2_weights_V_ce0 <= ap_const_logic_1;
        else 
            dense_2_weights_V_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    exitcond3_fu_167_p2 <= "1" when (p_reg_134 = ap_const_lv7_54) else "0";
    exitcond_fu_244_p2 <= "1" when (i_reg_156 = ap_const_lv7_78) else "0";
    i_3_fu_250_p2 <= std_logic_vector(unsigned(i_reg_156) + unsigned(ap_const_lv7_1));
    inner_state_V_cast_fu_222_p3 <= 
        ap_const_lv2_3 when (tmp_25_fu_214_p3(0) = '1') else 
        ap_const_lv2_0;
    inner_state_V_fu_372_p2 <= std_logic_vector(signed(p_Val2_14_fu_342_p3) + signed(p_Val2_17_reg_146));
    input_V_address0 <= tmp_13_fu_256_p1(7 - 1 downto 0);

    input_V_ce0_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_block_pp0_stage0_11001, ap_enable_reg_pp0_iter0)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            input_V_ce0 <= ap_const_logic_1;
        else 
            input_V_ce0 <= ap_const_logic_0;
        end if; 
    end process;

        lhs_V_fu_350_p1 <= std_logic_vector(IEEE.numeric_std.resize(signed(p_Val2_17_reg_146),9));

    output_V_address0 <= tmp_reg_467(7 - 1 downto 0);

    output_V_ce0_assign_proc : process(ap_CS_fsm_state7)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state7)) then 
            output_V_ce0 <= ap_const_logic_1;
        else 
            output_V_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    output_V_d0 <= 
        tmp_26_fu_440_p1 when (tmp_11_fu_444_p2(0) = '1') else 
        ap_const_lv7_0;

    output_V_we0_assign_proc : process(ap_CS_fsm_state7)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state7)) then 
            output_V_we0 <= ap_const_logic_1;
        else 
            output_V_we0 <= ap_const_logic_0;
        end if; 
    end process;

    p_0249_3_fu_432_p3 <= 
        p_mux_fu_416_p3 when (brmerge12_fu_410_p2(0) = '1') else 
        p_s_fu_424_p3;
    p_2_fu_173_p2 <= std_logic_vector(unsigned(p_reg_134) + unsigned(ap_const_lv7_1));
    p_Result_10_fu_364_p3 <= ret_V_fu_358_p2(8 downto 8);
    p_Result_11_fu_378_p3 <= inner_state_V_fu_372_p2(7 downto 7);
    p_Result_9_fu_326_p3 <= p_Val2_13_fu_320_p2(7 downto 7);
    p_Result_s_fu_307_p3 <= r_V_reg_506(10 downto 10);
        p_Val2_12_fu_314_p1 <= std_logic_vector(IEEE.numeric_std.resize(signed(tmp_28_reg_511),8));

    p_Val2_13_fu_320_p2 <= std_logic_vector(unsigned(tmp_18_cast_fu_317_p1) + unsigned(p_Val2_12_fu_314_p1));
    p_Val2_14_fu_342_p3 <= 
        phitmp_fu_334_p3 when (p_Result_9_fu_326_p3(0) = '1') else 
        p_Val2_13_fu_320_p2;
    p_Val2_20_fu_234_p2 <= std_logic_vector(unsigned(inner_state_V_cast_fu_222_p3) + unsigned(tmp_cast_fu_230_p1));
        p_Val2_23_cast_fu_240_p1 <= std_logic_vector(IEEE.numeric_std.resize(signed(p_Val2_20_fu_234_p2),8));

    p_mux_fu_416_p3 <= 
        ap_const_lv8_7F when (brmerge_fu_398_p2(0) = '1') else 
        inner_state_V_fu_372_p2;
    p_s_fu_424_p3 <= 
        ap_const_lv8_80 when (underflow_fu_392_p2(0) = '1') else 
        inner_state_V_fu_372_p2;
    p_shl1_cast_fu_204_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(tmp_17_fu_196_p3),15));
    p_shl_cast_fu_192_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(tmp_16_fu_184_p3),15));
    phitmp_fu_334_p3 <= 
        p_Val2_13_fu_320_p2 when (p_Result_s_fu_307_p3(0) = '1') else 
        ap_const_lv8_7F;
    r_V_fu_283_p0 <= dense_2_weights_V_q0;
    r_V_fu_283_p1 <= r_V_fu_283_p10(7 - 1 downto 0);
    r_V_fu_283_p10 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(input_V_q0),11));
    r_V_fu_283_p2 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(std_logic_vector(signed(r_V_fu_283_p0) * signed('0' &r_V_fu_283_p1))), 11));
    ret_V_fu_358_p2 <= std_logic_vector(signed(lhs_V_fu_350_p1) + signed(rhs_V_fu_354_p1));
        rhs_V_fu_354_p1 <= std_logic_vector(IEEE.numeric_std.resize(signed(p_Val2_14_fu_342_p3),9));

    signbit_i_i_0_not_fu_404_p2 <= (p_Result_10_fu_364_p3 xor ap_const_lv1_1);
    tmp_11_fu_444_p2 <= "1" when (signed(p_Val2_17_reg_146) > signed(ap_const_lv8_0)) else "0";
    tmp_13_cast_fu_261_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(i_reg_156),15));
    tmp_13_fu_256_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(i_reg_156),64));
    tmp_15_fu_386_p2 <= (p_Result_11_fu_378_p3 xor ap_const_lv1_1);
    tmp_16_fu_184_p3 <= (p_reg_134 & ap_const_lv7_0);
    tmp_17_fu_196_p3 <= (p_reg_134 & ap_const_lv3_0);
    tmp_18_cast_fu_317_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(tmp_29_reg_516),8));
    tmp_18_fu_208_p2 <= std_logic_vector(unsigned(p_shl_cast_fu_192_p1) - unsigned(p_shl1_cast_fu_204_p1));
    tmp_19_fu_265_p2 <= std_logic_vector(unsigned(tmp_18_reg_477) + unsigned(tmp_13_cast_fu_261_p1));
        tmp_22_cast_fu_270_p1 <= std_logic_vector(IEEE.numeric_std.resize(signed(tmp_19_fu_265_p2),64));

    tmp_25_fu_214_p3 <= dense_2_biases_V_q0(1 downto 1);
    tmp_26_fu_440_p1 <= p_Val2_17_reg_146(7 - 1 downto 0);
    tmp_cast_fu_230_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(tmp_25_fu_214_p3),2));
    tmp_fu_179_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(p_reg_134),64));
    underflow_fu_392_p2 <= (tmp_15_fu_386_p2 and p_Result_10_fu_364_p3);
end behav;
