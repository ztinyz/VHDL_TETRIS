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
    --Port ( 
    --);
end Tris_logic;

architecture Behavioral of Tris_logic is

signal BTNR: std_logic := '0';
signal BTNL: std_logic := '0';
signal BTNC: std_logic := '0';

type coloana_matrix is array (0 to 7, 7 downto 0) of std_logic;
signal coloana: coloana_matrix :=  ("10000001", "11010000", "11100000", "11110000", "11111000", "11111000", "11010001", "11100001");
signal clona: coloana_matrix :=  ("00000000", "11010000", "11100000", "11110000", "11111000", "11111000", "11010001", "11100001");


signal clock: std_logic := '0';
signal clockcad: std_logic := '0';

signal index: integer := 6;
signal index2: integer := 6; -- pt cea mai de jos cu piesa pe ea ( unde se opreste urm piesa)
signal index3: integer := 6;
signal coorx: integer := 0;
signal coory: integer := 0;
signal same: integer := 0;

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
            for i in 6 downto 0 loop
                coloana(i + 1) := coloana(i);
            end loop;
            coloana(0) := '0';
        end if;
        
end procedure update_coloana;

begin

process
begin
clock <= not(clock);
wait for 15ms;
end process;

process
begin
clockcad <= not(clockcad);
wait for 10ms;
end process;

process(clockcad,clock)
    variable v_index2: integer;
    variable v_index3: integer;
    variable v_coloana: std_logic_vector(7 downto 0);
begin
    v_index2 := index2;
    v_index3 := index3;

    if (rising_edge(clockcad)) then
        same <= 0;
        for i in 0 to 7 loop
            for j in 0 to 7 loop
                if(coloana(i,j) /= clona(i,j))then
                    same <= 1;
                    clona(i,j) <= coloana(i, j);
                end if;
            end loop;
        end loop;
                
        if(index = 0) then
            index <= 6;
        else
            index <= index - 1;
        end if;
        
    if(same = 0) then
        if(rising_edge (clock))then
            for i in 0 to 7 loop
                for j in 0 to 7 loop
                    v_coloana(j) := coloana(i, j);
                end loop;
                update_coloana(v_coloana, v_index2, v_index3, index);
                for j in 0 to 7 loop
                    coloana(i, j) <= v_coloana(j);
                end loop;
            end loop;
        end if;
    else
        coloana(0, 0) <= '0';
    end if;
    
    end if;
    
end process;


end Behavioral;
