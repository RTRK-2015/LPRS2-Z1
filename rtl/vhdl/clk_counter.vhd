-------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije
--  Autor: LPRS2  <lprs2@rt-rk.com>                                           
--                                                                             
--  Ime modula: timer_counter                                                          
--                                                                             
--  Opis:                                                               
--                                                                             
--    Modul odogvaran za indikaciju o proteku sekunde
--                                                                             
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY clk_counter IS GENERIC(
                              -- maksimalna vrednost broja do kojeg brojac broji
                              max_cnt : STD_LOGIC_VECTOR(25 DOWNTO 0) := "10111110101111000010000000" -- 50 000 000
                             );
                      PORT   (
                               clk_i     : IN  STD_LOGIC; -- ulazni takt
                               rst_i     : IN  STD_LOGIC; -- reset signal
                               cnt_en_i  : IN  STD_LOGIC; -- signal dozvole brojanja
                               cnt_rst_i : IN  STD_LOGIC; -- signal resetovanja brojaca (clear signal)
                               one_sec_o : OUT STD_LOGIC  -- izlaz koji predstavlja proteklu jednu sekundu vremena
                             );
END clk_counter;

ARCHITECTURE rtl OF clk_counter IS

SIGNAL   counter_r : STD_LOGIC_VECTOR(25 DOWNTO 0);
signal	 c_i : STD_LOGIC_VECTOR (25 downto 0);
signal	 c_tc : STD_LOGIC;
signal	 c_m : STD_LOGIC_VECTOR(25 downto 0);
signal	 c_en : STD_LOGIC_VECTOR(25 downto 0);
signal	 c_rst : STD_LOGIC_VECTOR(25 downto 0);


component reg is
	generic(
		WIDTH    : positive := 1;
		RST_INIT : integer := 0
	);
	port(
		i_clk  : in  std_logic;
		in_rst : in  std_logic;
		i_d    : in  std_logic_vector(WIDTH-1 downto 0);
		o_q    : out std_logic_vector(WIDTH-1 downto 0)
	);
end component reg;

BEGIN

-- DODATI:
-- brojac koji kada izbroji dovoljan broj taktova generise SIGNAL one_sec_o koji
-- predstavlja jednu proteklu sekundu, brojac se nulira nakon toga

	cnt_reg: reg
	generic map(
			WIDTH => 26
	)
	port map(
		i_clk => clk_i,
		in_rst => rst_i,
		i_d => c_rst,
		o_q => counter_r
	);
	
	c_i <= counter_r + 1;
	
	c_tc <= '1' when counter_r = max_cnt - 1 else '0';
	
	c_m <= (others => '0') when c_tc = '1' else
			c_i;
		
	c_en <= counter_r when cnt_en_i = '0' else
			c_m;
			
	c_rst <= (others => '0') when cnt_rst_i = '1' else
			c_en;

	one_sec_o <= '1' when counter_r = max_cnt - 1 else '0';


END rtl;