library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_datapath_3 is
end tb_datapath_3 ;

Architecture I of Testbench is

component datapath_3
port ( clk: in std_logic;
		RESET: in std_logic;
		A : in std_logic_vector(15 downto 0); --W(16,8,8)
		B : in std_logic_vector(10 downto 0); --W(11,3,8)
		C : in std_logic_vector(15 downto 0); -- W(16,8,8)
		Y : out std_logic_vector(16 downto 0); -- W(TBD)
		START: in std_logic;
		VALID: out std_logic;
		LOAD: in std_logic;
		base_x: in std_logic_vector (10 downto 0); -- W(11,3,8)
		base_y: in std_logic_vector (16 downto 0); -- W(17,0,17)
		coeff: in std_logic_vector (16 downto 0)); -- W(17,0,17));
end component;

signal clk: std_logic;
signal RESET: std_logic;
signal A : std_logic_vector(15 downto 0); --W(16,8,8)
signal B : std_logic_vector(10 downto 0); --W(11,3,8)
signal C : std_logic_vector(15 downto 0); -- W(16,8,8)
signal Y : std_logic_vector(16 downto 0); -- W(TBD)
signal START: std_logic;
signal VALID: std_logic;
signal LOAD: std_logic;
signal base_x: std_logic_vector (10 downto 0); -- W(11,3,8)
signal base_y: std_logic_vector (16 downto 0); -- W(17,0,17)
signal coeff: std_logic_vector (16 downto 0); -- W(17,0,17));


begin
UUT : datapath_3 port map (clk, reset, A, B, C, Y, START, VALID, LOAD, base_x, base_y, coeff);

  xsclock_engine : process
    begin
      clk <= '0';
      wait for 20 ns;
      clk <= '1';
      wait for 20 ns;
    end process;

    reset_engine : process
      begin
        reset	 <= '0';
		  wait;
    end process;
	 
	 load_c_X_Y : process
		begin
		wait for 10 ns;
		LOAD <= '1';
		base_x <= "01111000000";
		base_y <= "01000100010000000";
		coeff <= "00010001011110001";
		wait for 40 ns;
		base_x <= "10000000000";
		base_y <= "00111111111011110";
		coeff <= "00001110100010100";
		wait for 40 ns;
		base_x <= "10010000000";
		base_y <= "00111000111000110";
		coeff <= "00001011100110110";
		wait for 40 ns;
		base_x <= "10100000000";
		base_y <= "00110011001010001";
		coeff <= "00001001011110101";
		wait for 40 ns;
		base_x <= "10110000000";
		base_y <= "00101110011111111";
		coeff <= "00000111110000010";
		wait for 40 ns;
		LOAD <= '0';
		wait;
	 end process;
	 
	 load_data : process
	 begin 
	 START <= '0';
	 wait for  330 ns;
	 START <= '1'; 
	A <= "1010101010101010"; --170.6640625 risultato 31,9517068
	B <= "10111001000"; --5.783203125
	C <= "0000100111000100"; --2.44140625
	wait for 40 ns;
	START <= '0';
	wait for 40 ns;
	START <= '1';
	A <= "0111100111100101";--121.89453125 risultato 91,849854
	B <= "01111110011";--3.94921875
	C <= "1111001111110000";--60.984375
	wait for 40 ns;
	START <= '0';
	wait for 40 ns;
	START <= '1';
	A <= "1000000110000001";--129.50390625 risultato 26,56490384
	B <= "10011100000"; --4.875
	C <= "0000000000000000";
		wait for 40 ns;
	START <= '0';
	wait; 	
	 
	 end process; 
	 
	 
	 
end I;