	library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity datapath_1 is
port (clk : in std_logic;
		resetn : in std_logic;
		A : in std_logic_vector(15 downto 0); --W(16,8,8)
		B : in std_logic_vector(10 downto 0); --W(11,3,8)
		C : in std_logic_vector(15 downto 0); -- W(16,6,10)
		Y : out std_logic_vector(16 downto 0)); -- W(17,7,10));
end datapath_1;

architecture behavioral of datapath_1 is
signal A_int : std_logic_vector (25 downto 0); --W(26,8,18)
signal B_int : std_logic_vector (10 downto 0); --W(11,3,8)
signal C_int : std_logic_vector (15 downto 0); --W(16,6,10)
signal Y_int : std_logic_vector (16 downto 0); --W(17,7,10)
signal Y_int_temp : std_logic_vector (25 downto 0);

begin

reg_inout : process(clk)
	begin 
		if clk'event and clk ='1' then 
			if resetn = '1' then 
				A_int <= (others => '0');
				B_int <= (others => '0');
				C_int <= (others => '0');
				Y <= (others => '0');
				else 
				A_int <= A & "0000000000";
				B_int <= B;
				C_int <= C;
				Y <= Y_int;
				
			end if;
			end if;
end process;

Y_int_temp <= std_logic_vector((unsigned(A_int) / unsigned(B_int)) + unsigned(C_int));
Y_int <= Y_int_temp(16 downto 0);
end behavioral; 