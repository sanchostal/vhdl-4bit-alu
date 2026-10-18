----------------------------------------------------------------------------------
-- Engineer:    Sanzhar Stalbek
-- Module Name: tb_alu_4bit
-- Description: Exhaustive self-checking testbench verifying all 2,048 input
--              combinations (8 opcodes x 16 A values x 16 B values) in ModelSim.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_alu_4bit is
end tb_alu_4bit;

architecture sim of tb_alu_4bit is
    constant CLK_PERIOD : time := 10 ns; -- 100 MHz Clock

    signal clk     : std_logic := '0';
    signal rst_n   : std_logic := '0';
    signal A       : std_logic_vector(3 downto 0) := (others => '0');
    signal B       : std_logic_vector(3 downto 0) := (others => '0');
    signal opcode  : std_logic_vector(2 downto 0) := (others => '0');
    signal result  : std_logic_vector(3 downto 0);
    signal carry_o : std_logic;
    signal zero_o  : std_logic;

    -- Golden Behavioral Reference Function
    function golden_model(
        a_in  : unsigned(3 downto 0);
        b_in  : unsigned(3 downto 0);
        op_in : std_logic_vector(2 downto 0)
    ) return unsigned is
        variable exp_out : unsigned(4 downto 0);
    begin
        case op_in is
            when "000"  => exp_out := ('0' & a_in) + ('0' & b_in);
            when "001"  => exp_out := ('0' & a_in) - ('0' & b_in);
            when "010"  => exp_out := '0' & (a_in and b_in);
            when "011"  => exp_out := '0' & (a_in or b_in);
            when "100"  => exp_out := '0' & (a_in xor b_in);
            when "101"  => exp_out := '0' & (not a_in);
            when "110"  => exp_out := a_in(3) & a_in(2 downto 0) & '0';
            when "111"  => exp_out := '0' & '0' & a_in(3 downto 1);
            when others => exp_out := (others => '0');
        end case;
        return exp_out;
    end function;

begin

    -- Instantiate Unit Under Test (UUT)
    uut: entity work.alu_4bit
        port map (
            clk     => clk,
            rst_n   => rst_n,
            A       => A,
            B       => B,
            opcode  => opcode,
            result  => result,
            carry_o => carry_o,
            zero_o  => zero_o
        );

    -- 100 MHz Clock Generation
    clk <= not clk after CLK_PERIOD / 2;

    -- Exhaustive Verification Process (2,048 Vectors)
    stim_proc: process
        variable exp_full : unsigned(4 downto 0);
        variable exp_res  : std_logic_vector(3 downto 0);
        variable exp_cout : std_logic;
        variable exp_zero : std_logic;
        variable vec_cnt  : integer := 0;
        variable err_cnt  : integer := 0;
    begin
        rst_n <= '0';
        wait for 20 ns;
        rst_n <= '1';
        wait until rising_edge(clk);

        for op_i in 0 to 7 loop
            for a_i in 0 to 15 loop
                for b_i in 0 to 15 loop
                    -- Drive Inputs
                    opcode <= std_logic_vector(to_unsigned(op_i, 3));
                    A      <= std_logic_vector(to_unsigned(a_i, 4));
                    B      <= std_logic_vector(to_unsigned(b_i, 4));

                    -- Wait 2 clock cycles (Input Register + Output Register latency)
                    wait until rising_edge(clk);
                    wait until rising_edge(clk);
                    wait for 1 ns; -- Settle time after clock edge

                    -- Compute Expected Reference Output
                    exp_full := golden_model(to_unsigned(a_i, 4), to_unsigned(b_i, 4), std_logic_vector(to_unsigned(op_i, 3)));
                    exp_res  := std_logic_vector(exp_full(3 downto 0));
                    exp_cout := exp_full(4);
                    if exp_res = "0000" then
                        exp_zero := '1';
                    else
                        exp_zero := '0';
                    end if;

                    -- Self-Checking Assertions
                    if (result /= exp_res) or (carry_o /= exp_cout) or (zero_o /= exp_zero) then
                        report "MISMATCH at Opcode=" & integer'image(op_i) &
                               " A=" & integer'image(a_i) & " B=" & integer'image(b_i)
                               severity error;
                        err_cnt := err_cnt + 1;
                    end if;

                    vec_cnt := vec_cnt + 1;
                end loop;
            end loop;
        end loop;

        report "==========================================================" severity note;
        report "SIMULATION COMPLETE: Verified " & integer'image(vec_cnt) &
               " vectors with " & integer'image(err_cnt) & " errors." severity note;
        report "==========================================================" severity note;
        wait;
    end process;

end sim;
