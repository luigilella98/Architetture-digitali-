library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity datapath_3 is
port ( clk: in std_logic;
		RESET: in std_logic;
		A : in std_logic_vector(15 downto 0); --W(16,8,8)
		B : in std_logic_vector(10 downto 0); --W(11,3,8)
		C : in std_logic_vector(15 downto 0); -- W(16,8,8)
		Y : out std_logic_vector(16 downto 0); 
		START: in std_logic;
		VALID: out std_logic;
		LOAD: in std_logic;
		base_x: in std_logic_vector (10 downto 0); -- W(11,3,8)
		base_y: in std_logic_vector (16 downto 0); -- W(17,0,17)
		coeff: in std_logic_vector (16 downto 0)); -- W(17,0,17));
end datapath_3;

architecture bhe of datapath_3 is 

	signal index : natural; 
	signal A_int : std_logic_vector(15 downto 0); --W(16,8,8)
	signal B_int : std_logic_vector(10 downto 0); --W(11,3,8)
	signal C_int : unsigned(16 downto 0); --(17,7,10)
	
	signal diff : unsigned(10 downto 0); --(11,3,8)
	signal diffcoeff : unsigned(24 downto 0); --(25,0,25)
	signal inverso : unsigned(16 downto 0); --W(17,0,17)
	signal invA: unsigned(32 downto 0); --W(33,8,25)

signal con, next_con	: natural;
signal reset_con : std_logic;
signal en_out : std_logic;
type stato is (idle,processing,data_out);
signal cs, ns : stato;
signal Y_temp : std_logic_vector(16 downto 0);
constant N : natural := 5;
type array1 is array (0 to N-1) of std_logic_vector(16 downto 0);
type array2 is array (0 to N-1) of unsigned(10 downto 0);

signal baseY_reg, coeff_reg : array1;
signal baseX_reg : array2;

begin

update_fsm : process(clk)
	begin
	if clk'event and clk = '1' then 
		if RESET = '1' then
			cs <= idle;
			else
			cs <= ns;
			end if;
		end if;
	end process;

	
fsm : process(cs, START, LOAD)
	begin
	
	VALID <= '0';
	en_out <= '0';
	
	
	case cs is
	
	when idle =>
		if LOAD = '0' and START ='1' then 
			ns <= processing;
			else
			ns <= cs;
			end if;

		
	when processing =>
	ns <= data_out;
	en_out <= '1';
		
		
	when data_out =>
	VALID <= '1';
	if START = '1' then 
			ns <= processing;
			else 
			ns <= idle;
			end if;	
	
	when others =>
		ns <= idle;
	end case;
	
	
	
	end process;
	
	
reg_con : process(clk)
	begin  
	if clk'event and clk ='1' then
		if reset_con = '1' then 
			con <= 0;
			elsif LOAD ='1' then 
				con <= next_con;
				end if;
			end if;
end process;	 	
	

next_con <= con + 1 when LOAD ='1' else 0;
reset_con <= '1' when (RESET = '1' ) else '0';

load_coef_BX_BY : process(clk)
	begin
	if clk'event and clk ='1' then
		if RESET = '1' then 
			
			baseY_reg <= (others=> (others=>'0'));
			baseX_reg <= (others=> (others=>'0'));
			coeff_reg <= (others=> (others=>'0'));
			
			elsif LOAD ='1' then 
				baseY_reg(con) <= base_y;
				baseX_reg(con) <= unsigned(base_x);
				coeff_reg(con) <= coeff;
				end if;
			end if;

end process;	

sample_I : process(clk)
begin 
if clk'event and clk = '1' then
		if reset = '1' then
		A_int <= (others =>'0');
		B_int <= (others => '0');
		C_int <= (others => '0');
		
		elsif START = '1' and LOAD = '0' then
		
		A_int <= A;
		B_int <= B;
		C_int <= '0' & unsigned(C); 
			end if;
		end if;
end process;


sample_out : process(clk)
begin
if clk'event and clk = '1' then
		if reset = '1' then
		Y <= (others =>'0');
		
		else 
		Y<= Y_temp;
			end if;
		end if;

end process;

		soglie : process(B_int)
			begin
				index <= 0;
				
				for I in 0 to N-1 loop
					if (baseX_reg(I) <= unsigned(B_int)) then
						index <= I;
					end if;
					
				end loop;
		
			end process;
			
			diff <= unsigned(B_int) - unsigned(baseX_reg(index));
			diffcoeff <= diff(7 downto 0) * unsigned(coeff_reg(index));
			inverso <= unsigned(baseY_reg(index)) - diffcoeff(24 downto 8);
			invA <= unsigned(A_int)*inverso;
			Y_temp <= std_logic_vector(invA(31 downto 15 ) + C_int) when en_out ='1' else (others=>'0');
	
end bhe;