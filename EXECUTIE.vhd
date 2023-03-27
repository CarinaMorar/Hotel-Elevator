library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_signed.all;

entity EXECUTIE is
Port (
sw_etaj : in std_logic_vector(3 downto 0);
act_but : in std_logic;
clk : in std_logic;
reset : in std_logic;
senzor_masa, usa_busy : in std_logic;
clk_ms_P : out std_logic;
lift_activ_P : out std_logic;
go_to_up_P : out std_logic;
go_to_down_P : out std_logic;
clk_sec_PP : out std_logic;
flag_target_P : out std_logic;
stare_usi : out std_logic_vector(5 downto 0);
etaj_target_P : out std_logic_vector (3 downto 0);
etaj_curent_P : out std_logic_vector (3 downto 0);
led_masa : out std_logic
 );
end EXECUTIE;

architecture Behavioral of EXECUTIE is

    signal etaj_target : integer range 0 to 15;
    signal etaj_curent : integer range 0 to 15;
    signal go_to_up, go_to_down : std_logic;
    signal clk_ms, clk_sec : std_logic;
    signal lift_activ : std_logic;
    signal flag_target : std_logic;
    signal m : std_logic_vector(2 downto 0);
     
begin
--nu poti sa faci conversia directa din integer in std_logic_vector de aceea am facut o conversie intermediara din integer in unsigned
etaj_target_P <= std_logic_vector(to_unsigned(etaj_target, 4));--se face conversia din integer in unsigned si apoi din unsigned in std_logic_vector
etaj_curent_P <= std_logic_vector(to_unsigned(etaj_curent, 4));

clk_ms_P <= clk_ms;

lift_activ_P<=lift_activ;
go_to_up_P <= go_to_up;
go_to_down_P <= go_to_down;

clk_sec_PP <= clk_sec;
flag_target_P<=flag_target;

--clk pentru citirea memoriei 
    clock_ms: process(clk)-- clock ul in milisecunde (are perioada de o milisecunda)
        variable  n : integer range 0 to 1000000;--frecventa clock ului de pe placa e de 100MHz (100 000 000 oscilatii pe secunda)
	       begin
		if clk'event and clk='1' then
			if n < 100000 then
				n := n+1;
			else
				n := 0; 
			end if;
		
			if n <= 50000 then
				clk_ms <= '1';
			else
				clk_ms <= '0';
			end if;
		end if;
	end process clock_ms;
	
	clock_sec: process(clk_ms)--clock-ul in secunde (are perioada de o secunda)
        variable  n : integer range 0 to 2000;-- masoara o secunda (1000ms)
	       begin
		if clk_ms'event and clk_ms='1' then
			if n < 1000 then--daca e mai mic de 1000ms=1s 
				n := n+1;
			else
				n := 0; 
			end if;
		
			if n <= 500 then--pentru jumatate de secunda este in 1 logic si epntru urm este in 0 logic 
				clk_sec <= '1';
			else
				clk_sec <= '0';
			end if;
		end if;
	end process clock_sec;
		  
	  numarator : process (clk_sec, lift_activ, reset)
	       begin       
	        if(rising_edge(clk_sec)) then --[A]
	           if(reset='1') then --[AR]
	               etaj_target<=0;
	               etaj_curent<=0;
	               flag_target<='0';
	               lift_activ<='0';
	               led_masa <='0';
	               go_to_up<='0'; go_to_down<='0';
	               
	                   else
	        
	               if (act_but='1') then
                        etaj_target<=to_integer(unsigned(sw_etaj));--etaj target ia valoarea sw 0-3 din dreapta atunci cand se apasa butonul central
                        flag_target<='0';--se reseteaza bitul care ne spune cand ajunge liftul la etajul target
                    else null;--situatie implicita
                    end if;
                    
                    if (m<"010") then-- m nr de secunde dintre etaje (3 secunde 0,1,2 )
	                   lift_activ<='1';
	                   m<=m+'1';
	                 else 
	                   lift_activ<='0';
	                   m<="000";
	                 end if;
	                 
	                 if(senzor_masa = '1') then
	                   led_masa <='1';
	                    else
	                       led_masa <= '0';
	                 end if;
	                 
	              --lift activ cand e intre etaje este pe 0 
                  --lift activ cand e la un etaj este 1(nu neaparat la etajul target)
	             if(senzor_masa='0' and usa_busy='0') then -- [BM] masa e mai mica decat masa maxima si usile sunt inchise atunci se intampla restul
	               if (flag_target='0' and lift_activ='0') then -- [B] liftul nu este in miscare sau a ajuns la un etaj
	                   if (etaj_curent=0 and etaj_target>0) then-- [C] liftul este la parter
	                       etaj_curent<=etaj_curent+1; --liflul urca un etaj
	                       go_to_up<='1'; go_to_down<='0';
	                       lift_activ<='1';
	                   elsif(etaj_curent=0 and etaj_target=0) then
	                       flag_target<='1'; -- liftul a ajuns la etajul target
	                   elsif ((etaj_curent>0) and (etaj_curent <12)) then --daca etajul curent este intre 1 si 11 inclusiv
	                       if(etaj_curent=etaj_target) then --[D]
	                           flag_target<='1'; -- liftul a ajuns la etajul target
	                               elsif (etaj_target > etaj_curent) then
	                                   etaj_curent<=etaj_curent+1;--liftul va urca un etaj;
	                                   go_to_up<='1'; go_to_down<='0';
	                                   lift_activ<='1';
	                               elsif(etaj_target < etaj_curent)then
                                       etaj_curent<=etaj_curent-1;--liftul va cobora un etaj;
                                       go_to_up<='0'; go_to_down<='1';
                                       lift_activ<='1';
	                               else null;
	                        end if; -- [D]
	                
	                   elsif (etaj_curent=12 and etaj_target<12) then--liftul este la ultimul etaj
	                       etaj_curent<=etaj_curent-1;--liftl coboara un etaj
	                       go_to_up<='0'; go_to_down<='1';
	                       lift_activ<='1';
	                   elsif(etaj_curent=12 and etaj_target=12) then
	                       flag_target<='1'; -- liftul a ajuns la etajul targe	                   
	                   else null;
	               
	                   end if; -- [C]    
	                   end if; -- [B]
	               end if; -- [BR]    
	          end if; --[AR]
	       end if; --[A];            	       
	   end process numarator;
	   
usi_inchis_deschis : process (clk_sec, flag_target)
	           variable k : integer range 0 to 15;
	       begin
	       
        if rising_edge(clk_sec) then
	           if(flag_target='1'and usa_busy = '0') then
	               case k is
	               when 0 => stare_usi <="000000";--usi deschise 0%
	               k:=1;
	               when 1 => stare_usi <="001100";--usi deschise 30%
	               k:=2;
	               when 2 => stare_usi <="011110";--usi deschise 70%
	               k:=3;
	               when 3 => stare_usi <="111111";--usi deschise 100%
	               k:=4;
	               when 4 => stare_usi <="111111";--usile raman deschise 1 sec
	               k:=5;
	               when 5 => stare_usi <="111111";--usile raman deschise 2 sec
	               k:=6;
	               when 6 => stare_usi <="111111";--usile raman deschise 3 sec
	               k:=7;
	               when 7 => stare_usi <="011110";--usi inchise 30%
	               k:=8;
	               when 8 => stare_usi <="001100";--usi inchise 70%
	               k:=9;
	               when 9 => stare_usi <="000000";--usi inchise 100%
	               k:=9;
	               when others => k:=0; stare_usi <="101010";
	               end case;
	              
	              elsif (usa_busy='1') then
	                   stare_usi <="111111";
	                   k:=0;
	              else stare_usi <="000000";
	               k:=0;  
	           end if; 
	            
	            end if;
	       end process usi_inchis_deschis;
end Behavioral;
