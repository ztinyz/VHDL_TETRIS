----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/15/2024 10:26:48 AM
-- Design Name: 
-- Module Name: clkdiv - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clkdiv is
    Port ( clk_in1,reset : in STD_LOGIC;
           clk_out1 : out STD_LOGIC );
end clkdiv;

architecture Behavioral of clkdiv is
signal clk: std_logic := '0';
signal clock: std_logic := '0';
signal clock25mh: std_logic := '0';
begin
process(clk_in1,reset,clock,clk,clock25mh)
begin
if( reset = '1') then
    clk <= '0';
--else
--    clk_out1<= clock25mh;
else if(rising_edge(clk_in1))then
        clk<=not (clk);
end if;
end if; 
end process;

process(reset,clk,clock25mh)
begin
if( reset = '1') then
    clock25mh <= '0';
else if(rising_edge(clk))then
    clock25mh <= not (clock25mh);
end if;
end if;
end process;
clk_out1<= clock25mh;
end Behavioral;
