library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_4bit is
    Port (
        clk     : in   std_logic;
        rst_n   : in   std_logic;
        A       : in   std_logic_vector(3 downto 0);
        B       : in   std_logic_vector(3 downto 0);
        opcode  : in   std_logic_vector(2 downto 0);
        result  : out std_logic_vector(3 downto 0);
        carry_o : out std_logic;
        zero_o  : out std_logic
    );
end alu_4bit;

architecture Behavioral of alu_4bit is
    signal a_reg, b_reg : unsigned(3 downto 0);
    signal op_reg       : std_logic_vector(2 downto 0);
    signal alu_out      : unsigned(4 downto 0);
begin

    -- Combinational 8-Operation ALU
    process(a_reg, b_reg, op_reg)
    begin
        alu_out <= (others => '0');
        case op_reg is
            when "000" => alu_out <= ('0' & a_reg) + ('0' & b_reg); -- ADD
            when "001" => alu_out <= ('0' & a_reg) - ('0' & b_reg); -- SUB
            when "010" => alu_out <= '0' & (a_reg and b_reg);       -- AND
            when "011" => alu_out <= '0' & (a_reg or b_reg);        -- OR
            when "100" => alu_out <= '0' & (a_reg xor b_reg);       -- XOR
            when "101" => alu_out <= '0' & (not a_reg);             -- NOT A
            when "110" => alu_out <= a_reg(3) & a_reg(2 downto 0) & '0'; -- Shift Left
            when "111" => alu_out <= '0' & '0' & a_reg(3 downto 1);      -- Shift Right
            when others => alu_out <= (others => '0');
        end case;
    end process;

    -- Synchronous Registers clocked at 100 MHz
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            a_reg   <= (others => '0');
            b_reg   <= (others => '0');
            op_reg  <= (others => '0');
            result  <= (others => '0');
            carry_o <= '0';
            zero_o  <= '0';
        elsif rising_edge(clk) then
            a_reg   <= unsigned(A);
            b_reg   <= unsigned(B);
            op_reg  <= opcode;
            result  <= std_logic_vector(alu_out(3 downto 0));
            carry_o <= alu_out(4);
            if alu_out(3 downto 0) = "0000" then
                zero_o <= '1';
            else
                zero_o <= '0';
            end if;
        end if;
    end process;

end Behavioral;
