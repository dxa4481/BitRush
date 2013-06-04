----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:16:14 06/03/2013 
-- Design Name: 
-- Module Name:    hashadder - Behavioral 
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
use work.array64.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hashadder is
	generic ( numofhashers,thishasher : integer );
	Port(	clk: in STD_LOGIC;
		nonce: out STD_LOGIC_VECTOR(31 downto 0):= std_logic_vector(to_unsigned(2147483648/numofhashers+thishasher)));
end hashadder;

architecture Behavioral of hashadder is
	signal snonce : std_logic_vector:= std_logic_vector(to_unsigned(2147483648/numofhashers+thishasher));
begin
	process(clk)
	begin
		if (clk'event and clk = '1') then
			snonce<=snonce+1;
		end if;
	end process;
	nonce<=snonce;
end Behavioral;

