library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


--IL TESTBENCH NON HA INGRESSI NE USCITE
entity tb_datapath_2 is
end tb_datapath_2 ;

Architecture H of Testbench is

component datapath_2
port (clk : in std_logic;
		reset : in std_logic;
		A : in std_logic_vector(15 downto 0);
	B : in std_logic_vector(10 downto 0);
	C : in std_logic_vector(15 downto 0);
	Y : out std_logic_vector(16 downto 0));
end component;

signal clk, reset : std_logic;
signal A : std_logic_vector(15 downto 0);
signal B :  std_logic_vector(10 downto 0);
signal C : std_logic_vector(15 downto 0);
signal Y : std_logic_vector(16 downto 0);

begin
UUT : datapath_2 port map (clk, reset, A, B, C, Y);

  xsclock_engine : process
    begin
      clk <= '0';
      wait for 12.5 ns;
      clk <= '1';
      wait for 12.5 ns;
    end process;

    reset_engine : process
      begin
        reset	 <= '0';
		  wait;
    end process;
	 
	 
input_data : process
begin 

wait for  10 ns;
A <= "1010101010101010"; --170.6640625 
B <= "10111001000"; --5.783203125
C <= "0000100111000100"; --2.44140625
wait for 25 ns;
A <= "0111100111100101";--121.89453125 
B <= "01111110011";--3.94921875
C <= "1111001111110000";--60.984375
wait for 25 ns;
A <= "1000000110000001";--129.50390625 
B <= "10011100000"; --4.875
C <= "0000000000000000";
wait for 25 ns;
A <= "0110100111100101";
B <= "10100000001"; 
C <= "1111001111110000";
wait for 25 ns;
A <= "1100110000111100";--204.234375
B <= "01111001111"; --3.80859375
C <= "0001111100100001"; --7.7822265625
wait for 25 ns;
A <= "0110110000111100";--108.234375
B <= "10001000000";--4.25
C <= "1000001000000000"; --32.5
wait for 25 ns;
A <= "1000001100000001";--131.00390625
B <= "10011110000"; --4.9375
C <= "0001111000100100";--7.53515625
wait for 25 ns;
A <= "1011100010110000";--184.6875
B <= "10111000000";--	5,75
C <= "1100011101000100";--49.81640625
wait;
end process;

end H;