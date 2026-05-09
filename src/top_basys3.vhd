--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
    port(
        clk     :   in std_logic; 
        sw      :   in std_logic_vector(7 downto 0); 
        btnU    :   in std_logic; 
        btnC    :   in std_logic; 
        btnL  : in std_logic;
        led :   out std_logic_vector(15 downto 0);
        seg :   out std_logic_vector(6 downto 0);
        an  :   out std_logic_vector(3 downto 0)
    );
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
    signal w_cycle : std_logic_vector(3 downto 0);
    signal w_flags : std_logic_vector(3 downto 0);
    signal w_result : std_logic_vector(7 downto 0);
    signal f_regA : std_logic_vector(7 downto 0);
    signal f_regB : std_logic_vector(7 downto 0);
    signal w_display_val : std_logic_vector(7 downto 0);
    signal f_btnC_reg : std_logic_vector(1 downto 0);
    signal w_btnC_edge : std_logic;
    signal w_sign: std_logic;
    
    signal w_hund, w_tens, w_ones: std_logic_vector(3 downto 0);
    signal w_mux_o: std_logic_vector(3 downto 0);
    signal w_digit3: std_logic_vector(3 downto 0);
    signal w_clk_tdm: std_logic;
    signal w_unused_an: std_logic_vector(3 downto 0);
    
begin
    process(clk)
    begin
        if rising_edge(clk) then
            f_btnC_reg <= f_btnC_reg(0) & btnC;
        end if;
    end process;
    w_btnC_edge <= f_btnC_reg(0) and not f_btnC_reg(1);
    process(clk) 
    begin
        if rising_edge(clk) then
            if btnU = '1' then
                f_regA <= (others => '0');
                f_regB <= (others => '0');
            elsif w_cycle = "0010" then 
                f_regA <= sw; -- Load Operand A from switches
            elsif w_cycle = "0100" then 
                f_regB <= sw; -- Load Operand B from switches
            end if;
        end if;
    end process;
    w_display_val <= (others => '0') when w_cycle = "0001" else
                     f_regA          when w_cycle = "0010" else
                     f_regB          when w_cycle = "0100" else
                     w_result;

    -- 4. Port Maps
    u_fsm: entity work.controller_fsm
        port map(
            clk     => clk,
            i_reset => btnU,
            i_adv   => w_btnC_edge,
            o_cycle => w_cycle
        );

    u_alu: entity work.ALU 
        port map(
            i_A      => f_regA,
            i_B      => f_regB,
            i_op     => sw(2 downto 0),
            o_result => w_result,
            o_flags  => w_flags
        );

    u_twos_comp: entity work.twoscomp_decimal
        port map(
            i_bin  => w_display_val, 
            o_sign => w_sign,
            o_hund => w_hund,
            o_tens => w_tens,
            o_ones => w_ones
        );

    u_clk_div: entity work.clock_divider
        generic map (k_DIV => 250000)
        port map(
            i_clk   => clk,
            i_reset => btnL,
            o_clk   => w_clk_tdm
        );
    w_digit3 <= "1111" when w_sign = '1' else "0000";

    u_tdm: entity work.TDM4
        generic map (k_WIDTH => 4)
        port map(
            i_clk   => w_clk_tdm,
            i_reset => '0',
            i_D3    => w_digit3,
            i_D2    => w_hund,
            i_D1    => w_tens,
            i_D0    => w_ones,
            o_data  => w_mux_o, 
            o_sel   => an
        );

    u_decoder : entity work.sevenseg_decoder
        port map (
            i_Hex   => w_mux_o,
            o_seg_n => seg,    
            An      => w_unused_an,    
            btnC    => '1'
        );    
    led(3 downto 0) <= w_cycle;
    led(15 downto 12) <= w_flags;

end top_basys3_arch;