----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:08:19 05/30/2013 
-- Design Name: 
-- Module Name:    preproc - Behavioral 
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

entity preproc is
		Port( message: in STD_LOGIC_VECTOR(639 downto 0);
				messagechunk1,messagechunk2: out STD_LOGIC_VECTOR(511 downto 0));
end preproc;

architecture Behavioral of preproc is
		signal zeros : STD_LOGIC_VECTOR(319 downto 0) := (others=>'0');
		signal procmessage : STD_LOGIC_VECTOR(1023 downto 0);
begin
		procmessage <= message & "1" & zeros & x"0000000000000040";
		messagechunk1 <= procmessage(1023 downto 512);
		messagechunk2 <= procmessage(511 downto 0);

end Behavioral;

