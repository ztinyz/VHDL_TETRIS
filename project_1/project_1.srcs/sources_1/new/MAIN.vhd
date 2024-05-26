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
           BTNR,BTNL: in STD_LOGIC;
           reset : in std_logic;
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
       clk_in1 : in std_logic;
       clockfall : out std_logic);
end component;

component mpg is
    Port ( btn : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           enable : out  STD_LOGIC);
end component mpg;

signal Color: std_logic_vector(11 downto 0);
signal butonR : std_logic;
signal butonL : std_logic;
signal rst : std_logic := '0';

signal clk25MHz : std_logic;
signal clock : std_logic := '0';


signal TCH : std_logic;

signal Hcount : integer range 0 to 1687;
signal Vcount : integer range 0 to 1065;

type coloana_matrix is array (0 to 7, 7 downto 0) of std_logic;
--signal coloana: coloana_matrix :=  ("10000001", "11010000", "11100000", "11110000", "11111000", "11111000", "11010001", "11100001");
signal coloana: coloana_matrix :=  ("00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000");
signal index: integer := 6;
signal index2: integer := 6; -- pt cea mai de jos cu piesa pe ea ( unde se opreste urm piesa)
signal index3: integer := 6;
signal coorx: integer := 3;
signal coory: integer := 0;
signal coorx2: integer := 3;
signal coory2: integer := 0;
signal sameHor: integer := 0;

-- procedure declaration space:

procedure update_coloana(coloana: inout std_logic_vector(7 downto 0); index2: inout integer; index3: inout integer) is
    begin
        if (coloana(7)='1') then        
        for index2 in 6 downto 1 loop
            if(coloana(index2) = '0')then
                for index3 in index2 downto 1 loop 
                    coloana(index3) := coloana(index3 - 1);
                end loop;
                coloana(0) := '0';
                exit;
            end if;
        end loop; 
        else
            for i in 6 downto 0 loop
                coloana(i + 1) := coloana(i);
            end loop;
            coloana(0) := '0';
        end if;
end procedure update_coloana;

-- end declaration space
begin
a: clkdiv port map(clk_out1=>clk25MHz,clk_in1=>clk,reset=>rst,clockfall => clock);
b: mpg port map(enable=>butonR,clk=>clk,btn => BTNR);
c: mpg port map(enable=>butonL,clk=>clk,btn => BTNL);
d: mpg port map(enable=>rst,clk=>clk,btn => reset);

process(clock,butonR,rst)
    variable v_index2: integer;
    variable v_index3: integer;
    variable v_coloana: std_logic_vector(7 downto 0);
begin
    v_index2 := index2;
    v_index3 := index3; 
        
        if(rising_edge (clock))then
        sameHor <= 1;
            for i1 in 0 to 7 loop
            
                if (rst = '1') then
                    for ir in 0 to 7 loop
                        for jr in 0 to 7 loop
                            coloana(ir,jr) <= '0';
                        end loop;
                    end loop;    
                end if;
                
                if coorx2 = 1 then
                coloana(coorx,coory) <='1';
                coorx2<=0;
                end if;
                coory2 <= coory;
                if butonR = '1' then
                    if(coloana(coorx - 1,coory + 1) = '0' and coloana(coorx - 1,coory) = '0' and coloana(coorx,coory + 1) = '0' and coloana(coorx + 1,coory + 1) = '0' and coloana(coorx + 1,coory) = '0')and coorx<7then
                    coloana(coorx - 1,coory) <='0';
                    coloana(coorx,coory) <='1';
                    coorx<= coorx + 1;
                    else
                    coory <= coory -1;--ramana y la fel
                    end if;
                end if;
                
                if butonL = '1' then
                    if(coloana(coorx - 1,coory + 1) = '0' and coloana(coorx - 1,coory) = '0' and coloana(coorx,coory + 1) = '0' and coloana(coorx + 1,coory + 1) = '0' and coloana(coorx + 1,coory) = '0')and coorx>0then
                    coloana(coorx + 1,coory) <='0';
                    coloana(coorx,coory) <='1';
                    coorx<= coorx - 1;
                    else
                    coory <= coory -1;--ramana y la fel
                    end if;
                end if;
                
                --if(rising_edge (clock))then
                for j in 0 to 7 loop
                    v_coloana(j) := coloana(i1, j);
                end loop;
                
                update_coloana(v_coloana, v_index2, v_index3);
                
                for j in 0 to 7 loop             
                    coloana(i1, j) <= v_coloana(j);
                end loop;
                
                --end if;
                if(coloana(i1,7) = '0' and i1 > 0 and i1 < 7)then
                    sameHor <= 0;
                end if;
            end loop;
            coory <= coory + 1;
            
           if(sameHor = 1)then
               for i1 in 1 to 6 loop
                  coloana(i1,7) <= '0';
               end loop;
               sameHor <= 0;
           end if;
           
            if(coory = 7)then
            coory<= 0;
            coorx<=3;
            coorx2<=1;
            else
            coorx2<=0;
            end if;

        end if;
    
end process;

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
            if(coloana(j,i) = '1' and j < 7 and j > 0)then
            case i is
                when 0 =>
                  R:= "1111";
                  G:= "0000";
                  B:= "1111";
                when 1 =>
                  R:= "1111";
                  G:= "1111";
                  B:= "0000";
                 when 2 =>
                  R:= "0000";
                  G:= "1111";
                  B:= "1111";
                 when 3 =>
                  R:= "1111";
                  G:= "0000";
                  B:= "0000";
                 when 4 =>
                  R:= "0000";
                  G:= "0000";
                  B:= "1111";
                 when 5 =>
                  R:= "0000";
                  G:= "1111";
                  B:= "0000";
                 when 6 =>
                  R:= "0011";
                  G:= "1010";
                  B:= "0101";
                 when 7 =>
                  R:= "1010";
                  G:= "0000";
                  B:= "1010";            
                  
            end case;
            elsif (coloana(j,i) = '0' and j < 7 and j > 0 ) then
            R:= "1111";
            G:= "1111";
            B:= "1111";
            else
            R:= "0000";
            G:= "0000";
            B:= "0000";
            
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
