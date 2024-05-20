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
    --BTNL: in std_logic;
    --BTNR: in std_logic
    --);
end Tris_logic;

architecture Behavioral of Tris_logic is

signal BTNR: std_logic := '0';
signal BTNL: std_logic := '0';
signal BTNC: std_logic := '0';

type coloana_matrix is array (1 to 6, 7 to 0) of std_logic;
signal coloana: coloana_matrix :=  ("10000000", "11010000", "11100000", "11110000", "11111000", "11111000");

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

process -- procces pt butoane
begin
BTNR <= not(BTNR);
wait for 100ns;
BTNL <= not(BTNL);
wait for 100ns;
BTNC <= not(BTNC);
wait for 100ns;
end process;

process
begin
clock <= not(clock);
wait for 50ns;
end process;

process(clock)
    variable v_index2: integer;
    variable v_index3: integer;
    variable v_coloana: std_logic_vector(7 downto 0);
begin
    v_index2 := index2;
    v_index3 := index3;

    if (rising_edge(clock)) then
        if(index = 0) then
            index <= 6;
        else
            index <= index - 1;
        end if;

        for i in 1 to 6 loop
            for j in 0 to 7 loop
                v_coloana(j) := coloana(i, j);
            end loop;
            update_coloana(v_coloana, v_index2, v_index3, index);
            for j in 0 to 7 loop
                coloana(i, j) <= v_coloana(j);
            end loop;
        end loop;
    end if;
    
end process;


end Behavioral;
