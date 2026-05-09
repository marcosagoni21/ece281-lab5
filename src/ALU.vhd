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
begin
process(i_op, i_A, i_B)
        variable v_result : signed(8 downto 0);
        variable v_sum_unsigned : unsigned(8 downto 0);
    begin
        if i_op = "000" then 
            v_result := signed(i_A(7) & i_A) + signed(i_B(7) & i_B);
            v_sum_unsigned := unsigned('0' & i_A) + unsigned('0' & i_B);
        elsif i_op = "001" then 
            v_result := signed(i_A(7) & i_A) - signed(i_B(7) & i_B);
            if unsigned(i_A) >= unsigned(i_B) then
                v_sum_unsigned := "100000000";
            else
                v_sum_unsigned := "000000000"; 
            end if;
        else
            v_result := (others => '0');
            v_sum_unsigned := (others => '0');
        end if;
        case i_op is
            when "000" | "001" => o_result <= std_logic_vector(v_result(7 downto 0));
            when "010"         => o_result <= i_A and i_B;
            when "011"         => o_result <= i_A or i_B;
            when others        => o_result <= (others => '0');
        end case;
        o_flags(3) <= v_result(7); 
        if v_result(7 downto 0) = "00000000" then 
            o_flags(2) <= '1';
        else
            o_flags(2) <= '0';
        end if;
        o_flags(1) <= v_sum_unsigned(8); 
        if (i_op = "000" and ((i_A(7) = i_B(7)) and (v_result(7) /= i_A(7)))) or 
           (i_op = "001" and ((i_A(7) /= i_B(7)) and (v_result(7) /= i_A(7)))) then
            o_flags(0) <= '1'; 
        else
            o_flags(0) <= '0';
        end if;
    end process;
end Behavioral;