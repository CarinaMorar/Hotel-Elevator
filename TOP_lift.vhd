library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TOP_lift is
 Port (
 clk_in : in std_logic;
 reset : in std_logic;
 sw_etaj : in std_logic_vector(3 downto 0);
 act_but : in std_logic;
senzor_masa, usa_busy : in std_logic;
lift_activ_P : out std_logic;
go_to_up_P : out std_logic; 
go_to_down_P : out std_logic; 
flag_target_P : out std_logic;
stare_usi : out std_logic_vector(5 downto 0);
clk_sec_P : out std_logic;
AN0, AN1, AN2, AN3 : out std_logic;
a, b,c, d, e, f, g : out std_logic;
led_masa : out std_logic
  );
end TOP_lift;

architecture Behavioral of TOP_lift is

signal DA_s : std_logic_vector(3 downto 0);
signal DB_s : std_logic_vector(3 downto 0);
signal clk_ms_s : std_logic;
signal m_P_s : std_logic_vector(2 downto 0);

component EXECUTIE port(
sw_etaj : in std_logic_vector(3 downto 0);
act_but : in std_logic;
clk : in std_logic;
reset : in std_logic;
senzor_masa, usa_busy : in std_logic;
clk_ms_P : out std_logic;
lift_activ_P : out std_logic;
go_to_up_P : out std_logic;
go_to_down_P : out std_logic; 
stare_usi : out std_logic_vector(5 downto 0);
clk_sec_PP : out std_logic;
flag_target_P : out std_logic;
etaj_target_P : out std_logic_vector (3 downto 0);
etaj_curent_P : out std_logic_vector (3 downto 0);
led_masa : out std_logic
);
end component;

component display_etaje port(
clk : in std_logic;
DA : in std_logic_vector (3 downto 0);
DB : in std_logic_vector (3 downto 0);
AN0, AN1, AN2, AN3 : out std_logic;
a, b,c, d, e, f, g : out std_logic
);
end component;

begin

n1 : EXECUTIE port map (
sw_etaj => sw_etaj, 
act_but => act_but, 
clk=>clk_in,
reset => reset,
clk_ms_P => clk_ms_s,
senzor_masa => senzor_masa,
usa_busy => usa_busy,
lift_activ_P=>lift_activ_P,
go_to_up_P => go_to_up_P,
go_to_down_P => go_to_down_P,
clk_sec_PP => clk_sec_P,
stare_usi => stare_usi, 
flag_target_P => flag_target_P,
etaj_target_P => DA_s, 
etaj_curent_P=> DB_s,
led_masa =>led_masa
);

n2 : display_etaje port map (
clk => clk_ms_s,
DA => DA_s,
DB => DB_s,
AN0 => AN0, AN1=>AN1, AN2=>AN2, AN3=>AN3,
a=>a, b=>b, c=>c, d=>d, e=>e, f=>f, g=>g
);

end Behavioral;
