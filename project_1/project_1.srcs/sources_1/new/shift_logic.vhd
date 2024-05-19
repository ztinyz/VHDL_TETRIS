----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/19/2024 11:14:28 AM
-- Design Name: 
-- Module Name: shift_logic - Behavioral
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

entity shift_logic is
  Port ( 
  coloana: in std_logic_vector(7 downto 0);
  shiftat: out std_logic_vector(7 downto 0);
  clk: in std_logic;
  start: integer
  );
end shift_logic;

architecture Behavioral of shift_logic is
signal index: integer:=6;
begin
index <= start;
process(clk,coloana,index)
begin
    if(rising_edge (clk))then
        if(index > 0)then
        shiftat(index)<=coloana(index-1);
        end if;
        index <= index -1;
    end if;
end process;
shiftat(0)<='0';
end Behavioral;
