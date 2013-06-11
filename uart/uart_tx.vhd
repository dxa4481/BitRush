----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:07:36 06/11/2013 
-- Design Name: 
-- Module Name:    uart_tx - Behavioral 
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

entity uart_tx is
    Port ( i_clk : in  STD_LOGIC;
	        i_reset : in  STD_LOGIC;
			  i_ce : in  STD_LOGIC;
           i_data : in  STD_LOGIC_VECTOR (7 downto 0);
           i_dv : in  STD_LOGIC;
           o_tx : out  STD_LOGIC;
			  o_busy : out  STD_LOGIC);
end uart_tx;

architecture Behavioral of uart_tx is

	type state_type is (idle, starting, sending, finish);
	signal state : state_type := idle;

	signal payload : std_logic_vector(7 downto 0) := (others => '0');
	signal count : std_logic_vector(2 downto 0) := (others => '0');
	constant count_max : std_logic_vector(2 downto 0) := "110";
	signal r_busy : std_logic := '0';
	signal r_tx : std_logic := '1';
	signal s_reset_count : std_logic := '0';

begin

	o_busy <= r_busy;
	o_tx <= r_tx;

	process( i_clk )
	begin
		if( rising_edge( i_clk ) ) then
			if( i_reset = '1' ) then
				state <= idle;
				payload <= (others => '1');
				r_tx <= '1';
				r_busy <= '0';
				s_reset_count <= '0';
			else
				-- defaults to prevent latches
				state <= state;
				payload <= payload;
				r_tx <= r_tx;
				r_busy <= r_busy;
				s_reset_count <= s_reset_count;
				
				-- only evaluate if clock enable is asserted
				if( i_ce = '1' ) then
				
					-- our state machine
					case state is
						-- wait for new data to come to the module to send
						when idle =>
							s_reset_count <= '1';
							r_busy <= '0';
							if( i_dv = '1' ) then
								payload <= i_data;
								state <= starting;
								r_busy <= '1';
							end if;
						-- start bit
						when starting =>
							s_reset_count <= '1';
							r_tx <= '0';
							r_busy <= '1';
							state <= sending;
						-- send data byte
						when sending =>
							s_reset_count <= '0';
							r_tx <= payload(0);
							payload <= '0' & payload(7 downto 1);
							r_busy <= '1';
							if( count = count_max ) then
								state <= finish;
							end if;
						-- assert stop bit
						when finish =>
							s_reset_count <= '1';
							r_tx <= '1';
							r_busy <= '1';
							state <= idle;
						when others => null;
					end case;
				end if;
			end if;
		end if;
	end process;

	-- counter decode
	process( i_clk )
	begin
		if( rising_edge( i_clk ) ) then
			if( i_reset = '1' ) then
				count <= (others => '0');
			else
				if( i_ce = '1' ) then
					if( s_reset_count = '1' ) then
						count <= (others => '0');
					else
						count <= count + '1';
					end if;
				end if;
			end if;
		end if;
	end process;

end Behavioral;

