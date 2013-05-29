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
		Port(	clk: in STD_LOGIC;
				messagechunk: in STD_LOGIC_VECTOR(511 downto 0);
				chunkhash: out STD_LOGIC_VECTOR(255 downto 0));
end messagechunk;

architecture Behavioral of messagechunk is

		type arrayofvectors63 is array(0 to 63) of STD_LOGIC_VECTOR(31 downto 0) ;
		type harray is array(0 to 7) of STD_LOGIC_VECTOR(31 downto 0);
		signal h : harray:= (x"6a09e667", x"bb67ae85", x"3c6ef372", x"a54ff53a", x"510e527f", x"9b05688c", x"1f83d9ab", x"5be0cd19");
		signal wordsext : arrayofvectors64;
begin
		process(clk)
			begin
			if (clk'event and clk = '1') then
				for I in 0 to 15 loop
					wordsext(I) <= messagechunk(511-I*32 downto 480-I*32);
				end loop;
			end if;
		end process;
		

		process(clk)
			variable s0,s1  	: std_logic_vector (31 downto 0);
			variable vwords : arrayofvectors64;
			begin
			if (clk'event and clk = '1') then
				vwords := wordsext;
				for i in 16 to 63 loop
					s0 := (vwords(i-15) sra 7) xor (vwords(i-15) sra 18) xor (vwords(i-15) srl 3);
					s1 := (vwords(i-2) sra 17) xor (vwords(i-2) sra 19) xor (vwords(i-2) srl 10);
					vwords(i):=vwords(i-16)+s0+vwords(i-7)+s1;
				end loop;
				wordsext <= vwords;
			end if;
		end process;

end Behavioral;

