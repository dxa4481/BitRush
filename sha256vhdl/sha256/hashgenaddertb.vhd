--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:25:49 06/02/2013
-- Design Name:   
-- Module Name:   C:/Users/Admin/Documents/GitHub/BitRush/sha256vhdl/sha256/hashgenaddertb.vhd
-- Project Name:  sha256
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: hashgenadder
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
 
ENTITY hashgenaddertb IS
END hashgenaddertb;
 
ARCHITECTURE behavior OF hashgenaddertb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT hashgenadder
    PORT(
         clk : IN  std_logic;
         founcnonce : OUT  std_logic_vector(31 downto 0);
         foundit : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';

 	--Outputs
   signal founcnonce : std_logic_vector(31 downto 0);
   signal foundit : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: hashgenadder PORT MAP (
          clk => clk,
          founcnonce => founcnonce,
          foundit => foundit
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 



END;
