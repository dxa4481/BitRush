----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:25:48 05/28/2013 
-- Design Name: 		sha 256
-- Module Name:    messagechunk - Behavioral 
-- Project Name: 		Mission lotsocash
-- Target Devices: 	basys spartan3e
-- Tool versions: 
-- Description: 		This is a peice for 512 chunks
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
use IEEE.NUMERIC_STD.ALL;

--This takes a 512 chunk and returns the hash for it

entity messagechunk is
		Port(messagechunk: in STD_LOGIC_VECTOR(511 downto 0);
				chunkhash: out STD_LOGIC_VECTOR(255 downto 0));
end messagechunk;

architecture Behavioral of messagechunk is

begin


end Behavioral;

