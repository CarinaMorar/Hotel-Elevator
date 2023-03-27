library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_etaje is
Port (
clk : in std_logic;
DA, DB : in std_logic_vector (3 downto 0);--semnale da-afisat target ,db-et curent
AN0, AN1, AN2, AN3 : out std_logic;--anozi
a, b,c, d, e, f, g : out std_logic--7 seg
 );
end display_etaje;

architecture Behavioral of display_etaje is
signal clk_div : std_logic;
signal C1, C0 : std_logic_vector (3 downto 0); 
signal F1, F0 : std_logic_vector (3 downto 0); 
signal bin_val : std_logic_vector (3 downto 0);
signal nr_bin : std_logic_vector(3 downto 0);
signal D0, D1, D2, D3 : std_logic_vector (3 downto 0);
begin

com_AN : process (clk)
variable celula : integer range 0 to 3;--digit celula 0 afisoarul cel mai din drapta 
    begin
    if (clk'event and clk='1') then
        case celula is
        when 0 => AN0<='0'; AN1<='1'; AN2<='1'; AN3<='1'; celula:=1; -- prima din dreapta 
            bin_val<= DA; nr_bin <= C0;
        when 1 => AN0<='1'; AN1<='0'; AN2<='1'; AN3<='1'; celula:=2;-- a doua din dreapta  
            bin_val<= DA; nr_bin <= C1;
        when 2 => AN0<='1'; AN1<='1'; AN2<='0'; AN3<='1'; celula:=3;-- a treia din dreapta
            bin_val<= DB; nr_bin <= F0;
        when 3 => AN0<='1'; AN1<='1'; AN2<='1'; AN3<='0'; celula:=0; --a patra din dreapta 
            bin_val<= DB; nr_bin <= F1;
    when others =>  celula:=0;
    end case;
    end if;
end process com_AN;

BCD_DECOD : process(nr_bin)
    begin
    case nr_bin is
    when "0000" => a<='0'; b<='0'; c<='0'; d<='0'; e<='0'; f<='0'; g<='1';
    when "0001" => a<='1'; b<='0'; c<='0'; d<='1'; e<='1'; f<='1'; g<='1';
    when "0010" => a<='0'; b<='0'; c<='1'; d<='0'; e<='0'; f<='1'; g<='0'; 
    when "0011" => a<='0'; b<='0'; c<='0'; d<='0'; e<='1'; f<='1'; g<='0';
    when "0100" => a<='1'; b<='0'; c<='0'; d<='1'; e<='1'; f<='0'; g<='0';
    when "0101" => a<='0'; b<='1'; c<='0'; d<='0'; e<='1'; f<='0'; g<='0';
    when "0110" => a<='0'; b<='1'; c<='0'; d<='0'; e<='0'; f<='0'; g<='0';
    when "0111" => a<='0'; b<='0'; c<='0'; d<='1'; e<='1'; f<='1'; g<='1';
    when "1000" => a<='0'; b<='0'; c<='0'; d<='0'; e<='0'; f<='0'; g<='0';
    when "1001" => a<='0'; b<='0'; c<='0'; d<='0'; e<='1'; f<='0'; g<='0';
    when others =>  a<='1'; b<='1'; c<='1'; d<='1'; e<='1'; f<='1'; g<='0';
    end case;
    end process BCD_DECOD;
    
    bin_dec_1 : process (DA)--et target 
        begin
        case DA is
            when "0000" => C1<="0000"; C0<="0000";  
            when "0001" =>  C1<="0000"; C0<="0001";
            when "0010" =>  C1<="0000"; C0<="0010";
            when "0011" =>  C1<="0000"; C0<="0011";
            when "0100" =>  C1<="0000"; C0<="0100";
            when "0101" =>  C1<="0000"; C0<="0101";
            when "0110" =>  C1<="0000"; C0<="0110";
            when "0111" =>  C1<="0000"; C0<="0111";
            when "1000" =>  C1<="0000"; C0<="1000";
            when "1001" =>  C1<="0000"; C0<="1001";
            when "1010" =>  C1<="0001"; C0<="0000";--10
            when "1011" =>  C1<="0001"; C0<="0001";--11
            when "1100" =>  C1<="0001"; C0<="0010";--12
            when "1101" =>  C1<="0001"; C0<="0011";--13
            when "1110" =>  C1<="0001"; C0<="0100";--14
            when "1111" =>  C1<="0001"; C0<="0101";--15
            when others => null;
         end case;
       end process bin_dec_1;
       
     bin_dec_2 : process (DB)--et curent
        begin
        
        case DB is
            when "0000" => F1<="0000"; F0<="0000";  
            when "0001" =>  F1<="0000"; F0<="0001";
            when "0010" =>  F1<="0000"; F0<="0010";
            when "0011" =>  F1<="0000"; F0<="0011";
            when "0100" =>  F1<="0000"; F0<="0100";
            when "0101" =>  F1<="0000"; F0<="0101";
            when "0110" =>  F1<="0000"; F0<="0110";
            when "0111" =>  F1<="0000"; F0<="0111";
            when "1000" =>  F1<="0000"; F0<="1000";
            when "1001" =>  F1<="0000"; F0<="1001";
            when "1010" =>  F1<="0001"; F0<="0000";--10
            when "1011" =>  F1<="0001"; F0<="0001";--11
            when "1100" =>  F1<="0001"; F0<="0010";--12
            when "1101" =>  F1<="0001"; F0<="0011";--13
            when "1110" =>  F1<="0001"; F0<="0100";--14
            when "1111" =>  F1<="0001"; F0<="0101";--15
            when others => null;
         end case;
       end process bin_dec_2;

end Behavioral;
