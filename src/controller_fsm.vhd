----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:42:49 PM
-- Design Name: 
-- Module Name: controller_fsm - FSM
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller_fsm is
    Port ( 
    clk : in STD_LOGIC;
    i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;

architecture FSM of controller_fsm is
    type state_type is (S0, S1, S2, S3);
    signal f_state, f_state_next : state_type;
begin
    process(clk)
    begin
        if rising_edge(clk) then
        if i_reset = '1' then
        f_state <=S0;
        elsif i_adv = '1' then
        f_state <=f_state_next;
        end if;
        end if;
        end process;
        process (f_state)
        begin
        case f_state is
        when S0 => f_state_next <=S1;
        when S1 => f_state_next <=S2;
        when S2 => f_state_next <= S3;
        when S3 => f_state_next <= S0;
        end case;
        end process;
        with f_state select
        o_cycle <= "0001" when S0,
        "0010" when S1,
        "0100" when S2,
        "1000" when S3;

end FSM;
