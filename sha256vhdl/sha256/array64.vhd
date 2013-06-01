--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package array64 is
	type arrayofvectors64 is array(0 to 63) of STD_LOGIC_VECTOR(31 downto 0);
end array64;

package body array64 is
end array64;