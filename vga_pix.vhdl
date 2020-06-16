
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_pixel is
    port(
        pixel_x, pixel_y : in integer;
        video_on         : in std_logic;
        ex_data_cr       : in std_logic_vector(2 downto 0); 
        rgb              : out std_logic_vector(2 downto 0)
    );
end vga_pixel;

architecture arch of vga_pixel is

begin

    rgb <= ex_data_cr and video_on;

end arch;