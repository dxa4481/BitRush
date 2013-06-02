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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.array64.all;

--This takes a 512 chunk and returns the hash for it

entity messagechunk is
		Port(	clk: in STD_LOGIC;
				messagechunk: in STD_LOGIC_VECTOR(511 downto 0);
				h0,h1,h2,h3,h4,h5,h6,h7: in STD_LOGIC_VECTOR(31 downto 0);
				chunkhash: out STD_LOGIC_VECTOR(255 downto 0):= (others=>'0'));
end messagechunk;

architecture Behavioral of messagechunk is



		--signal letters : letterarray:= (x"6a09e667", x"bb67ae85", x"3c6ef372", x"a54ff53a", x"510e527f", x"9b05688c", x"1f83d9ab", x"5be0cd19");
		signal wordsext : arrayofvectors64;
		
		signal sh0,sh1,sh2,sh3,sh4,sh5,sh6,sh7: STD_LOGIC_VECTOR(31 downto 0) := (others=>'0');
	
		 COMPONENT extendto64
				Port(	clk: in STD_LOGIC;
						messagechunk: in STD_LOGIC_VECTOR(511 downto 0);
						extpart : out arrayofvectors64);
		 END COMPONENT;		
begin
--break chunk into sixteen 32-bit big-endian words w[0..15]
		
		
		 extender: extendto64 PORT MAP(
					clk => clk,
					messagechunk => messagechunk,
					extpart => wordsext
		 );

		process(clk)
			variable s0,s1  	: std_logic_vector (31 downto 0);
			variable ch,temp,maj : std_logic_vector (31 downto 0);
			--unsure if this is the correct size for temp
			variable vwords : arrayofvectors64:= wordsext;
			variable letters : letterarray;
			begin
			if (clk'event and clk = '1') then
					vwords := wordsext;
--	Extend the sixteen 32-bit words into sixty-four 32-bit words:
-- for i from 16 to 63
--   s0 := (w[i-15] rightrotate 7) xor (w[i-15] rightrotate 18) xor (w[i-15] rightshift 3)
--   s1 := (w[i-2] rightrotate 17) xor (w[i-2] rightrotate 19) xor (w[i-2] rightshift 10)
--   w[i] := w[i-16] + s0 + w[i-7] + s1
--				for i in 16 to 63 loop
--					s0 := (vwords(i-15)(6 downto 0)&vwords(i-15)(31 downto 7)) xor (vwords(i-15)(17 downto 0)&vwords(i-15)(31 downto 18)) xor ("000"&vwords(i-15)(31 downto 3));
--					s1 := (vwords(i-2)(16 downto 0)&vwords(i-2)(31 downto 17)) xor (vwords(i-2)(18 downto 0)&vwords(i-2)(31 downto 19)) xor ("0000000000"&vwords(i-2)(31 downto 10));
--					vwords(i):=vwords(i-16)+s0+vwords(i-7)+s1;
--				end loop;
		
-- Initialize hash value for this chunk:
-- a := h0
-- b := h1
-- c := h2
-- d := h3
-- e := h4
-- f := h5
-- g := h6
-- h := h7				
				letters(0):=h0;
				letters(1):=h1;
				letters(2):=h2;
				letters(3):=h3;
				letters(4):=h4;
				letters(5):=h5;
				letters(6):=h6;
				letters(7):=h7;
--Main loop:
--for i from 0 to 63
--   S1 := (e rightrotate 6) xor (e rightrotate 11) xor (e rightrotate 25)
--   ch := (e and f) xor ((not e) and g)
--   temp := h + S1 + ch + k[i] + w[i]
--   d := d + temp;
--   S0 := (a rightrotate 2) xor (a rightrotate 13) xor (a rightrotate 22)
--   maj := (a and (b xor c)) xor (b and c)
--   temp := temp + S0 + maj
 
				for i in 0 to 63 loop
					s1:=(letters(4)(5 downto 0)&letters(4)(31 downto 6)) xor (letters(4)(10 downto 0)&letters(4)(31 downto 11)) xor (letters(4)(24 downto 0)&letters(4)(31 downto 25));
					ch:=(letters(4) and letters(5)) xor ((not letters(4)) and letters(6));
					temp:=letters(7) + s1 + ch + K(i) + vwords(i);
					letters(3):=letters(3)+temp;
					s0:=(letters(0)(1 downto 0)&letters(0)(31 downto 2)) xor (letters(0)(12 downto 0)&letters(0)(31 downto 13)) xor (letters(0)(21 downto 0)&letters(0)(31 downto 22));
					maj:=(letters(0) and (letters(1) xor letters(2))) xor (letters(1) and letters(2));
					temp:=temp+s0 + maj;
					
					letters(7):=letters(6);
					letters(6):=letters(5);
					letters(5):=letters(4);
					letters(4):=letters(3);
					letters(3):=letters(2);
					letters(2):=letters(1);
					letters(1):=letters(0);
					letters(0):=temp;					
				end loop;

--   h := g
--   g := f
--   f := e
--   e := d
--   d := c
--   c := b
--   b := a
--   a := temp
				

				
-- Add this chunk's hash to result so far:
-- h0 := h0 + a
-- h1 := h1 + b
-- h2 := h2 + c
-- h3 := h3 + d
-- h4 := h4 + e
-- h5 := h5 + f
-- h6 := h6 + g
-- h7 := h7 + h

				sh0<=h0 + letters(0);
				sh1<=h1 + letters(1);
				sh2<=h2 + letters(2);
				sh3<=h3 + letters(3);
				sh4<=h4 + letters(4);
				sh5<=h5 + letters(5);
				sh6<=h6 + letters(6);
				sh7<=h7 + letters(7);
						
			end if;
		end process;
		chunkhash<= sh0 & sh1 & sh2 & sh3 & sh4 & sh5 & sh6 & sh7;
end Behavioral;

