-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
          COMPONENT sha256
					Port(	clk: in STD_LOGIC;
							message: in STD_LOGIC_VECTOR(639 downto 0);
							hashout: out STD_LOGIC_VECTOR(255 downto 0));
          END COMPONENT;

          SIGNAL sclk :  std_logic :='0';
          SIGNAL hashout :STD_LOGIC_VECTOR(255 downto 0);

  BEGIN

  -- Component Instantiation
			sclk <= not sclk after 10 ns;
			
          uut: sha256 PORT MAP(
                  clk => sclk,
                  message => x"02000000C2E26FD54C50F4EC37BA8266222A8917EB8AE7A62FBAB0F871000000000000004F80C57D2DB0CF542E5ACA2138C2D1C3A5091643F4463F7317447B112075B5F06D20A051E97F011A00000000",
						hashout => hashout
          );

  END;
