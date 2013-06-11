--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:05:03 06/11/2013
-- Design Name:   
-- Module Name:   C:/dev/BitRush/uart/uart_top_tb.vhd
-- Project Name:  bitrushuart
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: uart_top
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY uart_top_tb IS
END uart_top_tb;
 
ARCHITECTURE behavior OF uart_top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart_top
    PORT(
         i_clk : IN  std_logic;
         i_reset : IN  std_logic;
         o_tx : OUT  std_logic;
         o_tx_busy : OUT  std_logic;
         i_tx_data : IN  std_logic_vector(7 downto 0);
         i_tx_dv : IN  std_logic;
         i_rx : IN  std_logic;
         o_rx_data : OUT  std_logic_vector(7 downto 0);
         o_rx_dv : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_clk : std_logic := '0';
   signal i_reset : std_logic := '0';
   signal i_tx_data : std_logic_vector(7 downto 0) := (others => '0');
   signal i_tx_dv : std_logic := '0';
   signal i_rx : std_logic := '0';

 	--Outputs
   signal o_tx : std_logic;
   signal o_tx_busy : std_logic;
   signal o_rx_data : std_logic_vector(7 downto 0);
   signal o_rx_dv : std_logic;

   -- Clock period definitions
   constant i_clk_period : time := 10 ns; -- 100mhz
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart_top PORT MAP (
          i_clk => i_clk,
          i_reset => i_reset,
          o_tx => o_tx,
          o_tx_busy => o_tx_busy,
          i_tx_data => i_tx_data,
          i_tx_dv => i_tx_dv,
          i_rx => i_rx,
          o_rx_data => o_rx_data,
          o_rx_dv => o_rx_dv
        );

   -- Clock process definitions
   i_clk_process :process
   begin
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for i_clk_period/2;
   end process;
 
	-- link tx and rx together
	i_rx <= o_tx;

   -- Stimulus process
   stim_proc: process
   begin		
      
		-- hold in reset
		i_reset <= '1';
		i_tx_dv <= '0';
		i_tx_data <= X"00";

      wait for i_clk_period*50;

		-- pull out of reset
		i_reset <= '0';
		
		wait for i_clk_period*50;

      i_tx_data <= X"A4";
		i_tx_dv <= '1';
		
		wait until o_tx_busy = '1';
		
		i_tx_data <= X"00";
		i_tx_dv <= '0';

      wait;
   end process;

END;
