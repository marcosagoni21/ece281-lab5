----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is
    signal w_result : signed(8 downto 0);
    signal w_op_A : signed(8 downto 0);
    signal w_op_B : signed(8 downto 0);
begin
    w_op_A <= signed(i_A(7) & i_A);
    w_op_B <= signed(i_B(7) & i_B);
    process(i_op, w_op_A, w_op_B, i_A, i_B)
    begin
        case i_op is
            when "000" =>
            w_result <= w_op_A + w_op_B;
            when "001" =>
            w_result <= w_op_A - w_op_B;
            when "010" =>
            w_result <= '0' & (signed(i_A) and signed(i_B));
            when "011" => 
            w_result <= '0' & (signed(i_A) or signed(i_B));
            when others =>
            w_result <= (others => '0');
           end case;
           end process;
           o_result <= std_logic_vector(w_result(7 downto 0));
           o_flags(2) <= '1' when w_result(7 downto 0) = "00000000" else '0';
           o_flags(3) <= w_result(7);
           process(i_op, w_result)
           begin
           if i_op = "001" then
           o_flags(1) <= not w_result(8);
           else
           o_flags(1) <= w_result(8);
           end if;
           end process;
           o_flags(0) <= '1' when (i_op = "000" and ((i_A(7) = i_B(7)) and (w_result(7) /=i_A(7) ))) or (i_op = "001" and ((i_A(7) /= i_B(7)) and (w_result(7) /= i_A(7)))) else '0';
end Behavioral;
