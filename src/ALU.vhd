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
    signal w_sum_unsigned : unsigned(8 downto 0);
begin
w_result <= signed(i_A(7) & i_A) + signed(i_B(7) & i_B) when i_op = "000" else
                signed(i_A(7) & i_A) - signed(i_B(7) & i_B) when i_op = "001" else
                (others => '0');
w_sum_unsigned <= unsigned('0' & i_A) + unsigned('0' & i_B) when i_op = "000" else
                      unsigned('0' & i_A) - unsigned('0' & i_B) when i_op = "001" else
                      (others => '0');
        process(i_op, i_A, i_B)
    begin
        case i_op is
            when "000" => o_result <= std_logic_vector(w_result(7 downto 0));
            when "001" => o_result <= std_logic_vector(w_result(7 downto 0));
            when "010" => o_result <= i_A and i_B;
            when "011" => o_result <= i_A or i_B;
            when others => o_result <= (others => '0');
        end case;
    end process;
    o_flags(3) <= w_result(7);
    o_flags(2) <= '1' when w_result(7 downto 0) = "00000000" else '0';
    o_flags(1) <= w_sum_unsigned(8); 
    o_flags(0) <= '1' when (i_op = "000" and ((i_A(7) = i_B(7)) and (w_result(7) /= i_A(7)))) or 
                          (i_op = "001" and ((i_A(7) /= i_B(7)) and (w_result(7) /= i_A(7)))) 
                  else '0';
end Behavioral;
