----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:49:22 04/18/2022 
-- Design Name: 
-- Module Name:    mpg - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mpg is
    Port ( btn : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           enable : out  STD_LOGIC);
end mpg;

architecture Behavioral of mpg is
    constant DEBOUNCE_PERIOD : integer := 65535; -- adjust as needed
    signal counter : integer := 0;
    signal debounced_state : STD_LOGIC := '0';
    signal previous_state : STD_LOGIC := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if btn /= previous_state then
                counter <= 0;
                previous_state <= btn;
            else
                if counter < DEBOUNCE_PERIOD then
                    counter <= counter + 1;
                else
                    debounced_state <= previous_state;
                end if;
            end if;

            enable <= debounced_state;
        end if;
    end process;

end Behavioral;
