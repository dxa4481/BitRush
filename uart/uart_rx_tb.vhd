--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:49:03 06/11/2013
-- Design Name:   
-- Module Name:   C:/dev/BitRush/uart/uart_rx_tb.vhd
-- Project Name:  bitrushuart
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: uart_rx
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
 
ENTITY uart_rx_tb IS
END uart_rx_tb;
 
ARCHITECTURE behavior OF uart_rx_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart_rx
    PORT(
         i_clk : IN  std_logic;
         i_reset : IN  std_logic;
         i_ce : IN  std_logic;
         i_rx : IN  std_logic;
         o_data : OUT  std_logic_vector(7 downto 0);
         o_dv : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_clk : std_logic := '0';
   signal i_reset : std_logic := '0';
   signal i_ce : std_logic := '0';
   signal i_rx : std_logic := '0';

 	--Outputs
   signal o_data : std_logic_vector(7 downto 0);
   signal o_dv : std_logic;

   -- Clock period definitions
   constant i_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart_rx PORT MAP (
          i_clk => i_clk,
          i_reset => i_reset,
          i_ce => i_ce,
          i_rx => i_rx,
          o_data => o_data,
          o_dv => o_dv
        );

   -- Clock process definitions
   i_clk_process :process
   begin
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for i_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for i_clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;