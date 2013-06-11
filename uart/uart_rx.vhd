----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:47:42 06/11/2013 
-- Design Name: 
-- Module Name:    uart_rx - Behavioral 
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

entity uart_rx is
    Port ( i_clk : in  STD_LOGIC;
           i_reset : in  STD_LOGIC;
           i_ce : in  STD_LOGIC;
           i_rx : in  STD_LOGIC;
           o_data : out  STD_LOGIC_VECTOR (7 downto 0);
           o_dv : out  STD_LOGIC);
end uart_rx;

architecture Behavioral of uart_rx is

	type state_type is (idle, offset, sample, finish);
	signal state : state_type := idle;

	signal bit_count : std_logic_vector(3 downto 0) := (others => '0');
	constant bit_count_max : std_logic_vector(3 downto 0) := "1001";
	signal count : std_logic_vector(3 downto 0) := (others => '0');
	constant count_offset : std_logic_vector(3 downto 0) := "0111";
	constant count_max : std_logic_vector(3 downto 0) := "1111";

	signal s_get_sample : std_logic := '0';
	signal s_done : std_logic := '0';
	signal s_reset_count : std_logic := '0';

	signal r_rx_last : std_logic := '0';
	signal s_start : std_logic := '0';
	
	signal r_payload : std_logic_vector(9 downto 0) := (others => '0');

	signal r_data : std_logic_vector(7 downto 0) := (others => '0');
	signal r_dv : std_logic := '0';

begin

	o_data <= r_data;
	o_dv <= r_dv;

	-- start decode
	process( i_clk )
	begin
		if( rising_edge( i_clk ) ) then
			if( i_reset = '1' ) then
				s_start <= '0';
				r_rx_last <= '0';
			else
				s_start <= s_start;
				r_rx_last <= r_rx_last;
				if( i_ce = '1' ) then
					r_rx_last <= i_rx;
					if( r_rx_last = '1' and i_rx = '0' ) then
						s_start <= '1';
					else
						s_start <= '0';
					end if;
				end if;
			end if;
		end if;
	end process;
	
	-- state machine
	process( i_clk )
	begin
		if( rising_edge( i_clk ) ) then
			if( i_reset = '1' ) then
				r_data <= (others => '0');
				r_dv <= '0';
				r_payload <= (others => '0');
				state <= idle;
				s_reset_count <= '0';
			else
				-- defaults to prevent latches
				r_data <= r_data;
				r_dv <= '0';
				r_payload <= r_payload;
				state <= state;
				s_reset_count <= s_reset_count;
				
				-- wait for clock enable to evailuate
				if( i_ce = '1' ) then
					-- state machine
					case state is
						when idle =>
							s_reset_count <= '1';
							if( s_start = '1' ) then
								state <= offset;
							end if;
						when offset =>
							s_reset_count <= '0';
							if( count = count_offset ) then
								state <= sample;
								-- reset the count, so we can count to the middle of the next bit
								s_reset_count <= '1';
							end if;
						when sample =>
							s_reset_count <= '0';
							if( s_done = '1' ) then
								state <= finish;
							else
								if( s_get_sample = '1' ) then
									r_payload <= i_rx & r_payload(9 downto 1);
								end if;
							end if;
						when finish =>
							r_dv <= '1';
							r_data <= r_payload(8 downto 1);
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
				s_done <= '0';
			else
				-- defualts to prevent latches
				s_done <= s_done;
				
				-- only evaluate on clock enable
				if( i_ce = '1' ) then
					if( bit_count = bit_count_max ) then
						s_done <= '1';
					else
						s_done <= '0';
					end if;
				end if;
			end if;
		end if;
	end process;


	-- counter decode
	process( i_clk )
	begin
		if( rising_edge( i_clk ) ) then
			if( i_reset = '1' ) then
				s_get_sample <= '0';
				bit_count <= (others => '0');
				count <= (others => '0');
			else
			
				-- defualts to prevent latches
				s_get_sample <= s_get_sample;
				bit_count <= bit_count;
				count <= count;
				
				-- only evaluate on clock enable
				if( i_ce = '1' ) then
				
					if( s_reset_count = '1' ) then
						count <= (others => '0');
						bit_count <= (others => '0');
					else
						if( count = count_max ) then
							s_get_sample <= '1';
							bit_count <= bit_count + '1';
							count <= (others => '0');
						else
							s_get_sample <= '0';
							count <= count + '1';
						end if;
					end if;
					
				end if;
			end if;
		end if;
	end process;

end Behavioral;

