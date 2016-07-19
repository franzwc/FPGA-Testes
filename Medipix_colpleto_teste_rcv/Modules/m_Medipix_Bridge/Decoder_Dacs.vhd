-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Decoder de parametros passados do Nios
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Decoder de parametros passados do Nios
--!
--! DETAILS:      
--!
--!- Project Name: Decoder_Parametros.vhd                       
--!- Module Name: Decoder_Parametros
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 2/12/2013     
--!- Version: 1.0.0 (Dez/2013) 
--------------------------------------------------------------------------------
-- LNLS - DET - 2013
--------------------------------------------------------------------------------
--}}} Header*/

--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------------------------
entity Decoder_Dacs is
--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------
port(
	-- Entradas Nios
	In_Reset                    : in std_logic;
	In_Clk_nios                 : in std_logic;
	In_En_nios                  : in std_logic;
	In_Sync_nios                : in std_logic;
	In_Data_nios                :	in std_logic_vector(7 downto 0);
	
	-- Saidas
	Out_Threshold_0             : out std_logic_vector(8 downto 0);
	Out_Threshold_1             : out std_logic_vector(8 downto 0);
	Out_Threshold_2             : out std_logic_vector(8 downto 0);
	Out_Threshold_3             : out std_logic_vector(8 downto 0);
	Out_Threshold_4             : out std_logic_vector(8 downto 0);
	Out_Threshold_5             : out std_logic_vector(8 downto 0);
	Out_Threshold_6             : out std_logic_vector(8 downto 0);
	Out_Threshold_7             : out std_logic_vector(8 downto 0);
	Out_Preamp                  : out std_logic_vector(7 downto 0);
	Out_Ikrum                   : out std_logic_vector(7 downto 0);
	Out_Shaper                  : out std_logic_vector(7 downto 0);
	Out_Disc                    : out std_logic_vector(7 downto 0);
	Out_DiscLS                  : out std_logic_vector(7 downto 0);
	Out_Shaper_Test             : out std_logic_vector(7 downto 0);
	Out_DAC_DiscL               : out std_logic_vector(7 downto 0);
	Out_DAC_Test                : out std_logic_vector(7 downto 0);
	Out_DAC_DiscH               : out std_logic_vector(7 downto 0);
	Out_Delay                   : out std_logic_vector(7 downto 0);
	Out_TP_Buffer_In            : out std_logic_vector(7 downto 0);
	Out_TP_Buffer_Out           : out std_logic_vector(7 downto 0);
	Out_Rpz                     : out std_logic_vector(7 downto 0);
	Out_Gnd                     : out std_logic_vector(7 downto 0);
	Out_TP_Ref                  : out std_logic_vector(7 downto 0);
	Out_Fbk                     : out std_logic_vector(7 downto 0);
	Out_Cas                     : out std_logic_vector(7 downto 0);
	Out_TP_RefA                 : out std_logic_vector(8 downto 0);
	Out_TP_RefB                 : out std_logic_vector(8 downto 0);
	
	Out_Send_DACS               : out std_logic

);

end Decoder_Dacs;

architecture Decoder_Dacs_arc of Decoder_Dacs is
--------------------------------------------------------------------------------
--  >> Declaração dos sinais do Processo
--------------------------------------------------------------------------------
signal sig_valid               : std_logic;
signal sig_sinc   				 : std_logic;
signal sig_data   				 : std_logic_vector (7 downto 0);

begin
process (In_Clk_nios, In_Reset)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------
variable conta_byte		       : integer range 0 to 200 := 0;
variable var_tipo              : std_logic_vector(7 downto 0) :=(others=>'0');
variable var_tipo2             : std_logic_vector(7 downto 0) :=(others=>'0');

variable threshold0            : natural;
variable threshold1            : natural;
variable threshold2            : natural;
variable threshold3            : natural;
variable threshold4            : natural;
variable threshold5            : natural;
variable threshold6            : natural;
variable threshold7            : natural;
variable preamp                : natural;
variable ikrum                 : natural;
variable shaper                : natural;
variable disc                  : natural;
variable discLS                : natural;
variable shaper_test           : natural;
variable dac_discL             : natural;
variable dac_test              : natural;
variable dac_discH             : natural;
variable delay                 : natural;
variable tp_buffer_In          : natural;
variable tp_buffer_Out         : natural;
variable rpz                   : natural;
variable gnd                   : natural;
variable tp_ref                : natural;
variable fbk                   : natural;
variable cas                   : natural;
variable tp_refA               : natural;
variable tp_refB               : natural;

begin
--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then
	-- Inicialização das saídas
	Out_Threshold_0     <=(others=>'0');
	Out_Threshold_1     <=(others=>'0');
	Out_Threshold_2     <=(others=>'0');
	Out_Threshold_3     <=(others=>'0');
	Out_Threshold_4     <=(others=>'0');
	Out_Threshold_5     <=(others=>'0');
	Out_Threshold_6     <=(others=>'0');
	Out_Threshold_7     <=(others=>'0');
	Out_Preamp          <=(others=>'0');
	Out_Ikrum           <=(others=>'0');
	Out_Shaper          <=(others=>'0');
	Out_Disc            <=(others=>'0');
	Out_DiscLS          <=(others=>'0');
	Out_Shaper_Test     <=(others=>'0');
	Out_DAC_DiscL       <=(others=>'0');
	Out_DAC_Test        <=(others=>'0');
	Out_DAC_DiscH       <=(others=>'0');
	Out_Delay           <=(others=>'0');
	Out_TP_Buffer_In    <=(others=>'0');
	Out_TP_Buffer_Out   <=(others=>'0');
	Out_Rpz             <=(others=>'0');
	Out_Gnd             <=(others=>'0');
	Out_TP_Ref          <=(others=>'0');
	Out_Fbk             <=(others=>'0');
	Out_Cas             <=(others=>'0');
	Out_TP_RefA         <=(others=>'0');
	Out_TP_RefB         <=(others=>'0');
	Out_Send_DACS       <='0';
	
	conta_byte          :=0;
--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------
elsif (rising_edge(In_Clk_nios)) then

   sig_valid<=In_En_nios;
	sig_sinc<=In_Sync_nios;
	sig_data<=In_Data_nios;
	
	
	if (sig_valid='1') then
		
		conta_byte:=conta_byte+1;

		if (sig_sinc='1' and sig_data=x"47") then
			conta_byte:=0;
		end if;

	   if conta_byte=4 then
			var_tipo:=sig_data(7 downto 0);
		elsif conta_byte=5 then
			var_tipo2:=sig_data(7 downto 0);
		end if;
		
		if (conta_byte>6 and (var_tipo=x"44" and var_tipo2=x"41")) then
		
			if conta_byte=7 then
				threshold0:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=8 then
            threshold0:=threshold0+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=9 then
			   threshold0:=threshold0+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=10 then
            threshold1:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=11 then
            threshold1:=threshold1+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=12 then
            threshold1:=threshold1+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=13 then
            threshold2:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=14 then
            threshold2:=threshold2+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=15 then
            threshold2:=threshold2+to_integer(unsigned(sig_data(3 downto 0)));
		   elsif conta_byte=16 then
            threshold3:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=17 then
            threshold3:=threshold3+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=18 then
            threshold3:=threshold3+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=19 then
            threshold4:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=20 then
            threshold4:=threshold4+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=21 then
            threshold4:=threshold4+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=22 then
            threshold5:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=23 then
            threshold5:=threshold5+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=24 then
            threshold5:=threshold5+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=25 then
            threshold6:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=26 then
            threshold6:=threshold6+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=27 then
            threshold6:=threshold6+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=28 then
            threshold7:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=29 then
            threshold7:=threshold7+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=30 then
            threshold7:=threshold7+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=31 then
            preamp:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=32 then
            preamp:=preamp+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=33 then
            preamp:=preamp+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=34 then
            ikrum:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=35 then
            ikrum:=ikrum+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=36 then
            ikrum:=ikrum+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=37 then
            shaper:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=38 then
            shaper:=shaper+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=39 then
            shaper:=shaper+to_integer(unsigned(sig_data(3 downto 0)));	
			elsif conta_byte=40 then
            disc:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=41 then
            disc:=disc+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=42 then
            disc:=disc+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=43 then
            discLS:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=44 then
            discLS:=discLS+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=45 then
            discLS:=discLS+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=46 then
            shaper_test:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=47 then
            shaper_test:=shaper_test+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=48 then
            shaper_test:=shaper_test+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=49 then
            dac_discL:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=50 then
            dac_discL:=dac_discL+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=51 then
            dac_discL:=dac_discL+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=52 then
            dac_test:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=53 then
            dac_test:=dac_test+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=54 then
            dac_test:=dac_test+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=55 then
            dac_discH:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=56 then
            dac_discH:=dac_discH+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=57 then
            dac_discH:=dac_discH+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=58 then
            delay:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=59 then
            delay:=delay+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=60 then
            delay:=delay+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=61 then
            tp_buffer_In:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=62 then
            tp_buffer_In:=tp_buffer_In+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=63 then
            tp_buffer_In:=tp_buffer_In+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=64 then
            tp_buffer_Out:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=65 then
            tp_buffer_Out:=tp_buffer_Out+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=66 then
            tp_buffer_Out:=tp_buffer_Out+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=67 then
            rpz:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=68 then
            rpz:=rpz+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=69 then
            rpz:=rpz+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=70 then
            gnd:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=71 then
            gnd:=gnd+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=72 then
            gnd:=gnd+to_integer(unsigned(sig_data(3 downto 0)));
		   elsif conta_byte=73 then
            tp_ref:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=74 then
            tp_ref:=tp_ref+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=75 then
            tp_ref:=tp_ref+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=76 then
            fbk:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=77 then
            fbk:=fbk+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=78 then
            fbk:=fbk+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=79 then
            cas:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=80 then
            cas:=cas+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=81 then
            cas:=cas+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=82 then
            tp_refA:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=83 then
            tp_refA:=tp_refA+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=84 then
            tp_refA:=tp_refA+to_integer(unsigned(sig_data(3 downto 0)));
			elsif conta_byte=85 then
            tp_refB:=to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=86 then
            tp_refB:=tp_refB+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=87 then
            tp_refB:=tp_refB+to_integer(unsigned(sig_data(3 downto 0)));
				
			--fim da leitura comea a mandar dados pro medipix
			elsif (conta_byte>=88 and conta_byte<=187) then
	
            Out_Threshold_0<=std_logic_vector( to_unsigned(threshold0,9));
	         Out_Threshold_1<=std_logic_vector( to_unsigned(threshold1,9));
				Out_Threshold_2<=std_logic_vector( to_unsigned(threshold2,9));
				Out_Threshold_3<=std_logic_vector( to_unsigned(threshold3,9));
	         Out_Threshold_4<=std_logic_vector( to_unsigned(threshold4,9));
				Out_Threshold_5<=std_logic_vector( to_unsigned(threshold5,9));
				Out_Threshold_6<=std_logic_vector( to_unsigned(threshold6,9));
				Out_Threshold_7<=std_logic_vector( to_unsigned(threshold7,9));
				Out_Preamp<=std_logic_vector( to_unsigned(preamp,8));
				Out_Ikrum<=std_logic_vector( to_unsigned(ikrum,8));
				Out_Shaper<=std_logic_vector( to_unsigned(shaper,8));
				Out_Disc<=std_logic_vector( to_unsigned(disc,8));
				Out_DiscLS<=std_logic_vector( to_unsigned(discLS,8));
				Out_Shaper_Test<=std_logic_vector( to_unsigned(shaper_test,8));
				Out_DAC_DiscL<=std_logic_vector( to_unsigned(dac_discL,8));
				Out_DAC_Test<=std_logic_vector( to_unsigned(dac_test,8));
				Out_DAC_DiscH<=std_logic_vector( to_unsigned(dac_discH,8));
				Out_Delay<=std_logic_vector( to_unsigned(delay,8));
				Out_TP_Buffer_In<=std_logic_vector( to_unsigned(tp_buffer_In,8));
				Out_TP_Buffer_Out<=std_logic_vector( to_unsigned(tp_buffer_Out,8));
				Out_Rpz<=std_logic_vector( to_unsigned(rpz,8));
				Out_Gnd<=std_logic_vector( to_unsigned(gnd,8));
				Out_TP_Ref<=std_logic_vector( to_unsigned(tp_ref,8));
				Out_Fbk<=std_logic_vector( to_unsigned(fbk,8));
				Out_Cas<=std_logic_vector( to_unsigned(cas,8));
				Out_TP_RefA<=std_logic_vector( to_unsigned(tp_refA,9));
				Out_TP_RefB<=std_logic_vector( to_unsigned(tp_refB,9));
				if (conta_byte=100) then
				Out_Send_DACS<='1';
				else
				Out_Send_DACS<='0';
				end if;
			else
			   Out_Threshold_0<=(others=>'0');
				Out_Threshold_1<=(others=>'0');
				Out_Threshold_2<=(others=>'0');
				Out_Threshold_3<=(others=>'0');
				Out_Threshold_4<=(others=>'0');
				Out_Threshold_5<=(others=>'0');
				Out_Threshold_6<=(others=>'0');
				Out_Threshold_7<=(others=>'0');
				Out_Preamp<=(others=>'0');
				Out_Ikrum<=(others=>'0');
				Out_Shaper<=(others=>'0');
				Out_Disc<=(others=>'0');
				Out_DiscLS<=(others=>'0');
				Out_Shaper_Test<=(others=>'0');
				Out_DAC_DiscL<=(others=>'0');
				Out_DAC_Test<=(others=>'0');
				Out_DAC_DiscH<=(others=>'0');
				Out_Delay<=(others=>'0');
				Out_TP_Buffer_In<=(others=>'0');
				Out_TP_Buffer_Out<=(others=>'0');
				Out_Rpz<=(others=>'0');
				Out_Gnd<=(others=>'0');
				Out_TP_Ref<=(others=>'0');
				Out_Fbk<=(others=>'0');
				Out_Cas<=(others=>'0');
				Out_TP_RefA<=(others=>'0');
				Out_TP_RefB<=(others=>'0');
				Out_Send_DACS<='0';

			end if;
   end if;
	end if;
	
end if;
End process;
end Decoder_Dacs_arc;
