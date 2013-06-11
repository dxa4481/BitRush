----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:01:31 06/11/2013 
-- Design Name: 
-- Module Name:    uart_top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_top is
    Port ( i_clk : in  STD_LOGIC;
           i_reset : in  STD_LOGIC;
           
			  o_tx : out  STD_LOGIC;
			  o_tx_busy : out  STD_LOGIC;
           i_tx_data : in  STD_LOGIC_VECTOR (7 downto 0);
           i_tx_dv : in  STD_LOGIC;
           
			  i_rx : in  STD_LOGIC;
			  o_rx_data : out  STD_LOGIC_VECTOR (7 downto 0);
           o_rx_dv : out  STD_LOGIC
			  
           );
end uart_top;

architecture Behavioral of uart_top is

	COMPONENT uart_clkgen
	PORT(
		i_clk : IN std_logic;
		i_reset : IN std_logic;          
		o_tx_ce : OUT std_logic;
		o_rx_ce : OUT std_logic
		);
	END COMPONENT;

	COMPONENT uart_rx
	PORT(
		i_clk : IN std_logic;
		i_reset : IN std_logic;
		i_ce : IN std_logic;
		i_rx : IN std_logic;          
		o_data : OUT std_logic_vector(7 downto 0);
		o_dv : OUT std_logic
		);
	END COMPONENT;

	COMPONENT uart_tx
	PORT(
		i_clk : IN std_logic;
		i_reset : IN std_logic;
		i_ce : IN std_logic;
		i_data : IN std_logic_vector(7 downto 0);
		i_dv : IN std_logic;          
		o_tx : OUT std_logic;
		o_busy : OUT std_logic
		);
	END COMPONENT;

	signal s_tx_ce : std_logic := '0';
	signal s_rx_ce : std_logic := '0';

begin

	Inst_uart_clkgen: uart_clkgen PORT MAP(
		i_clk => i_clk,
		i_reset => i_reset,
		o_tx_ce => s_tx_ce,
		o_rx_ce => s_rx_ce
	);

	Inst_uart_rx: uart_rx PORT MAP(
		i_clk => i_clk,
		i_reset => i_reset,
		i_ce => s_rx_ce,
		i_rx => i_rx,
		o_data => o_rx_data,
		o_dv => o_rx_dv
	);

	Inst_uart_tx: uart_tx PORT MAP(
		i_clk => i_clk,
		i_reset => i_reset,
		i_ce => s_tx_ce,
		i_data => i_tx_data,
		i_dv => i_tx_dv,
		o_tx => o_tx,
		o_busy => o_tx_busy
	);

end Behavioral;

