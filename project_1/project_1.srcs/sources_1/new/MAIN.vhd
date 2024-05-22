----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/12/2020 06:54:35 PM
-- Design Name: 
-- Module Name: vga - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity vga is
    Port ( 
           clk : in STD_LOGIC;
           sw : in std_logic_vector(2 downto 0);
           rst : in std_logic;
           vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
           Hsync : out STD_LOGIC;
           Vsync : out STD_LOGIC);
end vga;

architecture Behavioral of vga is
component clkdiv is
    Port(
       clk_out1 : out std_logic;
       reset : in std_logic;
       clk_in1 : in std_logic);
end component;

signal Color: std_logic_vector(11 downto 0);
signal charac: std_logic_vector(7 downto 0);
signal locked : std_logic;

signal clk25MHz : std_logic;

signal TCH : std_logic;

signal Hcount : integer range 0 to 1687;
signal Vcount : integer range 0 to 1065;

type coloana_matrix is array (0 to 7, 7 downto 0) of std_logic;
signal coloana: coloana_matrix :=  ("10000001", "11010000", "11100000", "11110000", "11111000", "11111000", "11010001", "11100001");

begin

a: clkdiv port map(clk_out1=>clk25MHz,clk_in1=>clk,reset=>rst);
process(clk25MHz,rst)
begin
if(rst = '1') then
    Hcount <= 0;
    TCH <= '0';
else if rising_edge(clk25MHz) then
    if(Hcount = 800) then --800
        Hcount <= 0;
        TCH <= '1';
    else
        Hcount <= Hcount + 1;
        TCH <= '0';
    end if;   
end if;
end if;
end process;

process(clk25MHz,rst,TCH)
begin
if(rst = '1') then
   Vcount <= 0;
else if rising_edge(clk25MHz) then

    if (TCH = '1') then
    if(Vcount = 525) then --525
        Vcount <= 0;
    else
        Vcount <= Vcount + 1;
    end if;  
    end if; 
end if;
end if;
end process;

process(Vcount,clk25MHz)
begin
if rising_edge(clk25MHz) then
    if(Vcount < 490 or Vcount > 492) then --Vcount < 490 or Vcount > 492
        Vsync <= '1';
    else
        Vsync <= '0';
    end if;
end if;
end process;

process(Hcount,clk25MHz)
begin
if rising_edge(clk25MHz) then
    if(Hcount < 656 or Hcount > 752) then  --Hcount < 656 or Hcount > 752
        Hsync <= '1';
    else
        Hsync <= '0';
    end if;
end if;
end process;

process(Hcount,Vcount,clk25MHz)
variable R,G,B : std_logic_vector(3 downto 0);
begin
if rising_edge(clk25MHz)then
    if(Hcount < 640) then  --Hcount < 688 and Hcount > 48
    
    
    
        if(Vcount < 480) then  --Vcount >33 and Vcount <513
            R:= "1111";
            G:= "1111";
            B:= "1111";
         for j in 0 to 7 loop
         for i in 0 to 7 loop 
          if( Vcount <60*(i+1) and Vcount>i*60 and Hcount<80*(j+1) and Hcount >j*80)then
            if(coloana(j,i) = '1')then
            R:= "1111";
            G:= "0000";
            B:= "1111";
            else
            R:= "1111";
            G:= "1111";
            B:= "1111";
            end if;
            end if;
         end loop;  
         end loop;     
        end if;
    else
         R:= "0000";
         B:= "0000";
         G:= "0000";
     
end if;
vgaRed <= R;
vgaBlue <= B;
vgaGreen <= G;
end if;
end process;

end Behavioral;
