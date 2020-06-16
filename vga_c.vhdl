library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga is 
    generic(
        h_pulse   : integer;
        h_bp      : integer;
        h_display : integer;
        h_fp      : integer;
        h_pol     : std_logic;
        v_pulse   : integer;
        v_bp      : integer;
        v_display : integer;
        v_fp      : integer;
        v_pol     : std_logic
    );
    port(
        clk             : in std_logic;
        enable          : out std_logic;
        column          : out integer;
        row             : out integer;
        h_sync          : out std_logic;
        v_sync          : out std_logic;
        clk_vga         : out std_logic;
        video_on        : out std_logic
    );
end entity;

-- 640x480
architecture arch of vga is

    constant h_period : integer := h_pulse + h_bp + h_display + h_fp;
    constant v_period : integer := v_pulse + v_bp + v_display + v_fp;

    signal video_on_v, video_on_h : std_logic;
    signal h_count    : integer range 0 to h_period - 1 := 0;
    signal v_count    : integer range 0 to v_period - 1 := 0;

begin

    clk_vga <= clk;
    video_on <= video_on_h and video_on_v;

    process 
    begin 
        wait until clk'event and clk ='1';
        if h_count < h_period - 1 then h_count <= h_count + 1;
        else
            h_count <= 0;
            if v_count < v_period - 1 then
                v_count <= v_count + 1;
            else
                v_count <= 0;
            end if;
        end if;
        
        -- h_sync
        if h_count < h_display + h_fp or h_count >= h_display + h_fp + h_pulse then
            h_sync <= not h_pol;
        else
            h_sync <= h_pol;
        end if;

        -- v_sync
        if v_count < v_display + v_fp or v_count >= v_display + v_fp + v_pulse then
            v_sync <= not v_pol;
        else
            v_sync <= v_pol;
        end if;

        if h_count < h_display then
            column <= h_count;
        end if;

        if v_count < v_display then
            row <= v_count;
        end if;


        if h_count < h_display and v_count < v_display then enable <= '1';
        else enable <= '0'; end if;

    
        if h_count <= h_display - 1 then video_on_h <= '1';
        else video_on_h <= '0'; end if;


        if v_count <= v_display - 1 then video_on_v <= '1';
        else video_on_v <= '0';
        end if;
    end process;

end arch;