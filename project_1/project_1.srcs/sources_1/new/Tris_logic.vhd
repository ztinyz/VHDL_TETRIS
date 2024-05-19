----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/19/2024 10:36:21 AM
-- Design Name: 
-- Module Name: Tris_logic - Behavioral
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

entity Tris_logic is
--  Port ( );
end Tris_logic;

architecture Behavioral of Tris_logic is

signal coloana1: std_logic_vector(7 downto 0):="11100001";
signal coloana2: std_logic_vector(7 downto 0):="11110001";
signal coloana3: std_logic_vector(7 downto 0):="10000001";
signal coloana4: std_logic_vector(7 downto 0):="11000001";
signal coloana5: std_logic_vector(7 downto 0):=x"AF";
signal clock: std_logic := '0';
signal index: integer := 6;
signal index2: integer := 6; -- pt cea mai de jos cu piesa pe ea ( unde se opreste urm piesa)
signal index3: integer := 6;

procedure update_coloana(coloana: inout std_logic_vector(7 downto 0); index2: inout integer; index3: inout integer; index: in integer) is
    begin
        
        if (coloana(7)='1') then        
        for index2 in 6 downto 1 loop
            if(coloana(index2) = '0')then
                for index3 in index2 downto 1 loop 
                    coloana(index3) := coloana(index3 - 1);
                end loop;
                coloana(0) := '0';
            end if;
        end loop; 
        else
            for index in 6 downto 0 loop
                coloana(index + 1) := coloana(index);
            end loop;
            coloana(0) := '0';
        end if;
        
end procedure update_coloana;

begin

process
begin
clock <= not(clock);
wait for 50ns;
end process;

process(coloana1,coloana2,coloana3,coloana4,coloana5,index,clock,index2,index3)
    variable v_index2: integer;
    variable v_index3: integer;
    variable v_coloana: std_logic_vector(7 downto 0);
begin  

    v_index2 := index2;
    v_index3 := index3;
  
if (rising_edge(clock)) then
    if(index = 0) then
        index<= 6 ;
    else
        index<=index - 1;
    end if;
    
    v_coloana := coloana1;
    update_coloana(v_coloana, v_index2, v_index3, index);
    coloana1 <= v_coloana;
    
    v_coloana := coloana2;
    update_coloana(v_coloana, v_index2, v_index3, index);
    coloana2 <= v_coloana;
    
    v_coloana := coloana3;
    update_coloana(v_coloana, v_index2, v_index3, index);
    coloana3 <= v_coloana;
    
    v_coloana := coloana4;
    update_coloana(v_coloana, v_index2, v_index3, index);
    coloana4 <= v_coloana;
    
    v_coloana := coloana5;
    update_coloana(v_coloana, v_index2, v_index3, index);
    coloana5 <= v_coloana;
    
    --coloana2(index + 1)<= coloana2(index);
    --coloana2(0)<= '0';
    --coloana3(index + 1)<= coloana3(index);
    --coloana3(0)<= '0';
    --coloana4(index + 1)<= coloana4(index);
    --coloana4(0)<= '0';
    --coloana5(index + 1)<= coloana5(index);
    --coloana5(0)<= '0';
    --coloana6(index + 1)<= coloana6(index);
    --coloana6(0)<= '0';
end if;
end process;
end Behavioral;
