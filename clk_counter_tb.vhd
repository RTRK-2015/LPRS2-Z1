--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:52:40 03/03/2016
-- Design Name:   
-- Module Name:   C:/materija/RA113-2013/sarma/clk_counter_tb.vhd
-- Project Name:  sarma
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clk_counter
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY clk_counter_tb IS
END clk_counter_tb;
 
ARCHITECTURE behavior OF clk_counter_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clk_counter IS GENERIC(
		max_cnt : STD_LOGIC_VECTOR(25 DOWNTO 0) := "00000000000000000000000010"
	);
    PORT(
         clk_i : IN  std_logic;
         rst_i : IN  std_logic;
         cnt_en_i : IN  std_logic;
         cnt_rst_i : IN  std_logic;
         one_sec_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal rst_i : std_logic := '0';
   signal cnt_en_i : std_logic := '0';
   signal cnt_rst_i : std_logic := '0';

 	--Outputs
   signal one_sec_o : std_logic;

   -- Clock period definitions
   constant clk_i_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: clk_counter
   GENERIC MAP (
		max_cnt => ( 1 => '1' , others => '0' )
   )
   PORT MAP (
          clk_i => clk_i,
          rst_i => rst_i,
          cnt_en_i => cnt_en_i,
          cnt_rst_i => cnt_rst_i,
          one_sec_o => one_sec_o
        );

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_i_period*10;

      -- insert stimulus here 
	  rst_i <= '1';
	  cnt_rst_i <= '0';
	  cnt_en_i <= '1';
	  
	  wait for 50 ns;
	  
	  cnt_en_i <= '0';
	  
	  wait for 50 ns;
	  
	  cnt_en_i <= '1';

      wait;
   end process;

END;
