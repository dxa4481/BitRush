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
				h0,h1,h2,h3,h4,h5,h6,h7: in STD_LOGIC_VECTOR(31 downto 0);
				chunkhash: out STD_LOGIC_VECTOR(255 downto 0));
end messagechunk;

architecture Behavioral of messagechunk is

		type arrayofvectors63 is array(0 to 63) of STD_LOGIC_VECTOR(31 downto 0) ;
		type letterarray is array(0 to 7) of STD_LOGIC_VECTOR(31 downto 0);

		--signal letters : letterarray:= (x"6a09e667", x"bb67ae85", x"3c6ef372", x"a54ff53a", x"510e527f", x"9b05688c", x"1f83d9ab", x"5be0cd19");
		signal wordsext : arrayofvectors64;
		
		type k_array is array(0 to 63) of STD_LOGIC_VECTOR(31 downto 0);
		constant K : k_array := (
			x"428a2f98", x"71374491", x"b5c0fbcf", x"e9b5dba5", x"3956c25b", x"59f111f1", x"923f82a4", x"ab1c5ed5",
			x"d807aa98", x"12835b01", x"243185be", x"550c7dc3", x"72be5d74", x"80deb1fe", x"9bdc06a7", x"c19bf174",
			x"e49b69c1", x"efbe4786", x"0fc19dc6", x"240ca1cc", x"2de92c6f", x"4a7484aa", x"5cb0a9dc", x"76f988da",
			x"983e5152", x"a831c66d", x"b00327c8", x"bf597fc7", x"c6e00bf3", x"d5a79147", x"06ca6351", x"14292967",
			x"27b70a85", x"2e1b2138", x"4d2c6dfc", x"53380d13", x"650a7354", x"766a0abb", x"81c2c92e", x"92722c85",
			x"a2bfe8a1", x"a81a664b", x"c24b8b70", x"c76c51a3", x"d192e819", x"d6990624", x"f40e3585", x"106aa070",
			x"19a4c116", x"1e376c08", x"2748774c", x"34b0bcb5", x"391c0cb3", x"4ed8aa4a", x"5b9cca4f", x"682e6ff3",
			x"748f82ee", x"78a5636f", x"84c87814", x"8cc70208", x"90befffa", x"a4506ceb", x"bef9a3f7", x"c67178f2"
		);			
		
begin
--break chunk into sixteen 32-bit big-endian words w[0..15]
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
			variable ch,temp,maj : std_logic (31 downto 0);
			--unsure if this is the correct size for temp
			variable vwords : arrayofvectors64;
			variable letters : letterarray;
			begin
			if (clk'event and clk = '1') then
				vwords := wordsext;
--	Extend the sixteen 32-bit words into sixty-four 32-bit words:
-- for i from 16 to 63
--   s0 := (w[i-15] rightrotate 7) xor (w[i-15] rightrotate 18) xor (w[i-15] rightshift 3)
--   s1 := (w[i-2] rightrotate 17) xor (w[i-2] rightrotate 19) xor (w[i-2] rightshift 10)
--   w[i] := w[i-16] + s0 + w[i-7] + s1
				for i in 16 to 63 loop
					s0 := (vwords(i-15) sra 7) xor (vwords(i-15) sra 18) xor (vwords(i-15) srl 3);
					s1 := (vwords(i-2) sra 17) xor (vwords(i-2) sra 19) xor (vwords(i-2) srl 10);
					vwords(i):=vwords(i-16)+s0+vwords(i-7)+s1;
				end loop;
				
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
					s1:=(letters(4) sra 6) xor (letters(4) sra 11) xor (letters(4) sra 25);
					ch:=(letters(4) and letters(5)) xor ((not letters(4)) and letters(6));
					temp:=letters(7) + s1 + ch + letters + k(i) + vwords(i);
					letters(3):=letters(3)+temp;
					s0:=(letters(0) sra 2) xor (letters(0) sra 13) xor (letters(0) sra 22);
					maj:=(letters(0) and (letters(1) xor letters(2))) xor (letters(1) and letters(2));
					temp:=temp+s0 + maj;
				end loop;

--   h := g
--   g := f
--   f := e
--   e := d
--   d := c
--   c := b
--   b := a
--   a := temp
				letters(7):=letters(6);
				letters(6):=letters(5);
				letters(5):=letters(4);
				letters(4):=letters(3);
				letters(3):=letters(2);
				letters(2):=letters(1);
				letters(1):=letters(0);
				letters(0):=temp;
				
-- Add this chunk's hash to result so far:
-- h0 := h0 + a
-- h1 := h1 + b
-- h2 := h2 + c
-- h3 := h3 + d
-- h4 := h4 + e
-- h5 := h5 + f
-- h6 := h6 + g
-- h7 := h7 + h
				h0<=h0 + letters(0);
				h1<=h1 + letters(1);
				h2<=h2 + letters(2);
				h3<=h3 + letters(3);
				h4<=h4 + letters(4);
				h5<=h5 + letters(5);
				h6<=h6 + letters(6);
				h7<=h7 + letters(7);
				

			wordsext <= vwords;				
			end if;
		end process;
		chunkhash<= h0 & h1 & h2 & h3 & h4 & h5 & h6 & h7;
end Behavioral;

