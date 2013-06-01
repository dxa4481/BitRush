----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:09:05 06/01/2013 
-- Design Name: 
-- Module Name:    extendto64 - Behavioral 
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

entity extendto64 is
	
		Port(	clk: in STD_LOGIC;
				messagechunk: in STD_LOGIC_VECTOR(511 downto 0);
				extpart : out arrayofvectors64 := (others=> (others=> '0')));
end extendto64;

architecture Behavioral of extendto64 is
		signal wordsext : arrayofvectors64;

begin
		wordsext(0)<= messagechunk(511 downto 480);
		wordsext(1)<= messagechunk(479 downto 448);
		wordsext(2)<= messagechunk(447 downto 416);
		wordsext(3)<= messagechunk(415 downto 384);
		wordsext(4)<= messagechunk(383 downto 352);
		wordsext(5)<= messagechunk(351 downto 320);
		wordsext(6)<= messagechunk(319 downto 288);
		wordsext(7)<= messagechunk(287 downto 256);
		wordsext(8)<= messagechunk(255 downto 224);
		wordsext(9)<= messagechunk(223 downto 192);
		wordsext(10)<= messagechunk(191 downto 160);
		wordsext(11)<= messagechunk(159 downto 128);
		wordsext(12)<= messagechunk(127 downto 96);
		wordsext(13)<= messagechunk(95 downto 64);
		wordsext(14)<= messagechunk(63 downto 32);
		wordsext(15)<= messagechunk(31 downto 0);
	process(clk)
	variable vwords : arrayofvectors64 := wordsext;
	variable s0,s1  	: std_logic_vector (31 downto 0);
	begin
		if (clk'event and clk = '1') then
			vwords := wordsext;
			for i in 16 to 63 loop
				s0 := (vwords(i-15)(6 downto 0)&vwords(i-15)(31 downto 7)) xor (vwords(i-15)(17 downto 0)&vwords(i-15)(31 downto 18)) xor ("000"&vwords(i-15)(31 downto 3));
				s1 := (vwords(i-2)(16 downto 0)&vwords(i-2)(31 downto 17)) xor (vwords(i-2)(18 downto 0)&vwords(i-2)(31 downto 19)) xor ("0000000000"&vwords(i-2)(31 downto 10));
				vwords(i):=vwords(i-16)+s0+vwords(i-7)+s1;
			end loop;
			extpart<=vwords;
		end if;
	end process;
end Behavioral;

