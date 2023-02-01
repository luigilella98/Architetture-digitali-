library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity datapath_2 is
	port (clk : in std_logic;
	reset : in std_logic;
	A : in std_logic_vector(15 downto 0); --W(16,8,8)
	B : in std_logic_vector(10 downto 0); --W(11,3,8)
	C : in std_logic_vector(15 downto 0); --W(16,6,10)
	Y : out std_logic_vector(16 downto 0)); --W(17,8,10)
	end datapath_2;
	
	architecture beh of datapath_2 is 
	
	constant N : natural := 5;
	signal index : natural; 
	type array1 is array (0 to N-1) of std_logic_vector(16 downto 0);
	type array2 is array (0 to N-1) of unsigned(10 downto 0);
	
	--W(15,0,17)
	constant baseY : array1 := ("01000100010000000", 
											"00111111111011110",
											"00111000111000110",
											"00110011001010001",
											"00101110011111111");
	--W(15,0,17)										
	constant coeff : array1 := (	"00010001011110001",
											"00001110100010100",
											"00001011100110110",
											"00001001011110101",
											"00000111110000010");
	--W(11,3,8)
		constant baseX : array2 := ("01111000000","10000000000","10010000000","10100000000","10110000000");
	
	signal A_int : std_logic_vector(15 downto 0); --W(16,8,8)
	signal B_int : std_logic_vector(10 downto 0); --W(11,3,8)
	signal C_int : unsigned(16 downto 0); --(17,7,10)
	
	signal diff : unsigned(10 downto 0); --(11,3,8)
	signal diffcoeff: unsigned(24 downto 0); --(25,0,25)
	signal inverso : unsigned(16 downto 0); --W(17,0,17)
	signal invA: unsigned(32 downto 0); --W(33,8,25)
	
	
	begin
	sample : process(clk)
	begin
	if clk'event and clk = '1' then
		if reset = '1' then
		A_int <= (others =>'0');
		B_int <= (others => '0');
		C_int <= (others => '0');
		Y <= (others => '0');
		
		else
		
		A_int <= A;
		B_int <= B;
		C_int <= '0' & unsigned(C);
		Y <= std_logic_vector(invA(31 downto 15 ) + C_int);
			end if;
		end if;
	end process;
		
		soglie : process(B_int)
			begin
				index <= 0;
				
				for I in 0 to N-1 loop
					
					if (baseX(I) <= unsigned(B_int)) then
						index <= I;
					end if;
					
				end loop;
		
			end process;
			
			diff <= unsigned(B_int) - unsigned(baseX(index));
			diffcoeff <= diff(7 downto 0) * unsigned(coeff(index));
			inverso <= unsigned(baseY(index)) -diffcoeff(24 downto 8);
			invA <= unsigned(A_int)*inverso;
			
			
			
	end beh;