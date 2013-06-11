--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:17:14 06/11/2013
-- Design Name:   
-- Module Name:   C:/dev/BitRush/uart/uart_tx_tb.vhd
-- Project Name:  bitrushuart
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: uart_tx
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
 
ENTITY uart_tx_tb IS
END uart_tx_tb;
 
ARCHITECTURE behavior OF uart_tx_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart_tx
    PORT(
         i_clk : IN  std_logic;
         i_reset : IN  std_logic;
         i_ce : IN  std_logic;
         i_data : IN  std_logic_vector(7 downto 0);
         i_dv : IN  std_logic;
         o_tx : OUT  std_logic;
         o_busy : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_clk : std_logic := '0';
   signal i_reset : std_logic := '0';
   signal i_ce : std_logic := '0';
   signal i_data : std_logic_vector(7 downto 0) := (others => '0');
   signal i_dv : std_logic := '0';

 	--Outputs
   signal o_tx : std_logic;
   signal o_busy : std_logic;

   -- Clock period definitions
   constant i_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart_tx PORT MAP (
          i_clk => i_clk,
          i_reset => i_reset,
          i_ce => i_ce,
          i_data => i_data,
          i_dv => i_dv,
          o_tx => o_tx,
          o_busy => o_busy
        );

	-- CE decode
   i_ce_process :process
		variable ce_count : integer range 0 to 31;
   begin
		if( ce_count = 31 ) then
			ce_count := 0;
			i_ce <= '1';
		else
			ce_count := ce_count + 1;
			i_ce <= '0';
		end if;
		
		wait for i_clk_period;
		
   end process;

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
      --wait for 100 ns;	

		i_reset <= '1';
		i_data <= (others => '0');

      wait for i_clk_period*10;

		i_reset <= '0';
		
		wait for i_clk_period*2;
		
		i_data <= X"B4";
		
		wait for i_clk_period*1;
		
		i_dv <= '1';
		
		wait until o_busy = '1';
		
		i_data <= X"FF";
		i_dv <= '0';
		
		wait until o_busy = '0';
		
		i_data <= X"7D";
		i_dv <= '1';
		
		wait until o_busy = '1';
		
		i_data <= X"00";
		i_dv <= '0';
		
      wait;
   end process;

END;
