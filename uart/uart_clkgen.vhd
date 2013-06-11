----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:49:47 06/11/2013 
-- Design Name: 
-- Module Name:    uart_clkgen - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_clkgen is
    Port ( i_clk : in  STD_LOGIC;
			  i_reset : in  STD_LOGIC;
           o_tx_ce : out  STD_LOGIC;
           o_rx_ce : out  STD_LOGIC);
end uart_clkgen;

architecture Behavioral of uart_clkgen is

	signal r_tx_ce : std_logic := '0';
	signal r_rx_ce : std_logic := '0';

	signal tx_count : std_logic_vector(11 downto 0) := (others => '0');
	signal rx_count : std_logic_vector(11 downto 0) := (others => '0');

	--
	-- this is input freq / 115200 (115200 is the baud rate of the uart)
	-- 100,000,000 / 115,200 = 868, = X"0364"
	--
	constant count_max : std_logic_vector(11 downto 0) := X"384";

begin

	o_tx_ce <= r_tx_ce;
	o_rx_ce <= r_rx_ce;

	-- gen tx ce
	process( i_clk )
	begin
		if( rising_edge( i_clk ) ) then
			if( i_reset = '1' ) then
				r_tx_ce <= '0';
			else
				if( tx_count = count_max ) then
					r_tx_ce <= '1';
					tx_count <= (others => '0');
				else
					r_tx_ce <= '0';
					tx_count <= tx_count + '1';
				end if;
			end if;
		end if;
	end process;
	
	-- gen rx ce (16x faster than tx ce
	process( i_clk )
	begin
		if( rising_edge( i_clk ) ) then
			if( i_reset = '1' ) then
				r_rx_ce <= '0';
			else
				if( rx_count = ("0000" & count_max(11 downto 4)) ) then -- divide by 16, so shift 4
					r_rx_ce <= '1';
					rx_count <= (others => '0');
				else
					r_rx_ce <= '0';
					rx_count <= rx_count + '1';
				end if;
			end if;
		end if;
	end process;


end Behavioral;

