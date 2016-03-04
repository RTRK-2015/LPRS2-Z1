-------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije
--  Autor: LPRS2  <lprs2@rt-rk.com>                                           
--                                                                             
--  Ime modula: top                                                           
--                                                                             
--  Opis:                                                               
--                                                                             
--    vrh hijerarhije                                              
--                                                                             
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY top IS PORT (
                    FPGA_CLK   : IN  STD_LOGIC; -- GLAVNI TAKT
                    FPGA_RESET : IN  STD_LOGIC; -- GLAVNI RESET
                    UI_SW0     : IN  STD_LOGIC; -- RESET    PREKIDAC
                    UI_SW1     : IN  STD_LOGIC; -- STOP     PREKIDAC
                    UI_SW2     : IN  STD_LOGIC; -- START    PREKIDAC
                    UI_SW3     : IN  STD_LOGIC; -- CONTINUE PREKIDAC
                    -- LED OUTS
                    UI_LED0    : OUT STD_LOGIC;
                    UI_LED1    : OUT STD_LOGIC;
                    UI_LED2    : OUT STD_LOGIC;
                    UI_LED3    : OUT STD_LOGIC;
                    UI_LED4    : OUT STD_LOGIC;
                    UI_LED5    : OUT STD_LOGIC;
                    UI_LED6    : OUT STD_LOGIC;
                    UI_LED7    : OUT STD_LOGIC
                   );
END top;

ARCHITECTURE rtl OF top IS

-- instanciranje svih komponenti koje se nalaze u sistemu

-------------------------------------------------------------------
-- generator takta
-------------------------------------------------------------------
COMPONENT clk_gen IS PORT (
                           clkin_i       : IN  STD_LOGIC;
                           rst_i         : IN  STD_LOGIC;
                           clk_50MHz_o   : OUT STD_LOGIC;
                           clk_27MHz_o   : OUT STD_LOGIC;
                           reset_o       : OUT STD_LOGIC
                          );
END COMPONENT clk_gen;

-------------------------------------------------------------------
-- brojac taktova
-------------------------------------------------------------------
COMPONENT clk_counter IS
                    GENERIC(
                            max_cnt : STD_LOGIC_VECTOR(25 DOWNTO 0) := "10111110101111000010000000" -- 50 000 000
                           );
                    PORT   (
                             clk_i     : IN  STD_LOGIC;
                             rst_i     : IN  STD_LOGIC;
                             cnt_en_i  : IN  STD_LOGIC;
                             cnt_rst_i : IN  STD_LOGIC;
                             one_sec_o : OUT STD_LOGIC
                           );
END COMPONENT clk_counter;

-------------------------------------------------------------------
-- tajmer
-------------------------------------------------------------------
COMPONENT timer_counter IS PORT (
                                 clk_i     : IN  STD_LOGIC;
                                 rst_i     : IN  STD_LOGIC;
                                 one_sec_i : IN  STD_LOGIC;
                                 cnt_en_i  : IN  STD_LOGIC;
                                 cnt_rst_i : IN  STD_LOGIC;
                                 led_o     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
                                );
END COMPONENT timer_counter;

-------------------------------------------------------------------
-- automat tajmera (fsm)
-------------------------------------------------------------------
COMPONENT timer_fsm IS PORT (
                             clk_i             : IN  STD_LOGIC;
                             rst_i             : IN  STD_LOGIC;
                             reset_switch_i    : IN  STD_LOGIC;
                             start_switch_i    : IN  STD_LOGIC;
                             stop_switch_i     : IN  STD_LOGIC;
                             continue_switch_i : IN  STD_LOGIC;
                             cnt_en_o          : OUT STD_LOGIC;
                             cnt_rst_o         : OUT STD_LOGIC
                            );
END COMPONENT timer_fsm;

-- signali za povezivanje komponenti
SIGNAL clk_50MHz_s        : STD_LOGIC;
SIGNAL clk_27MHz_s       : STD_LOGIC;
SIGNAL rst_locked_s      : STD_LOGIC;
SIGNAL one_sec_s         : STD_LOGIC;
SIGNAL led_s             : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL cnt_rst_s         : STD_LOGIC;
SIGNAL cnt_en_s          : STD_LOGIC;

BEGIN

clk_gen_i:clk_gen             PORT MAP(
                                       clkin_i     => FPGA_CLK        ,
                                       rst_i       => not FPGA_RESET  ,
                                       clk_50MHz_o => clk_50MHz_s     ,
                                       clk_27MHz_o => clk_27MHz_s     ,
                                       reset_o     => rst_locked_s
                                      );

clk_counter_i:clk_counter     PORT MAP(
                                       clk_i     => clk_50MHz_s   ,
                                       rst_i     => rst_locked_s ,
                                       cnt_en_i  => cnt_en_s     ,
                                       cnt_rst_i => cnt_rst_s    ,
                                       one_sec_o => one_sec_s
                                      );

timer_counter_i:timer_counter PORT MAP(
                                       clk_i     => clk_50MHz_s   ,
                                       rst_i     => rst_locked_s ,
                                       one_sec_i => one_sec_s    ,
                                       cnt_en_i  => cnt_en_s     ,
                                       cnt_rst_i => cnt_rst_s    ,
                                       led_o     => led_s
                                      );

timer_fsm_i:timer_fsm         PORT MAP(
                                       clk_i             => clk_50MHz_s   ,
                                       rst_i             => rst_locked_s ,
                                       reset_switch_i    => UI_SW0       , -- RESET    PREKIDAC
                                       stop_switch_i     => UI_SW1       , -- STOP     PREKIDAC
                                       start_switch_i    => UI_SW2       , -- START    PREKIDAC
                                       continue_switch_i => UI_SW3       , -- CONTINUE PREKIDAC
                                       cnt_en_o          => cnt_en_s     ,
                                       cnt_rst_o         => cnt_rst_s
                                      );

-- povezivanje signala na izlane pinove LE dioda

UI_LED0  <= led_s(0);
UI_LED1  <= led_s(1);
UI_LED2  <= led_s(2);
UI_LED3  <= led_s(3);
UI_LED4  <= led_s(4);
UI_LED5  <= led_s(5);
UI_LED6  <= led_s(6);
UI_LED7  <= led_s(7);

END rtl;