-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Gera OMR
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Gera sinal da OMR para ser enviado ao medipix
--!
--! DETAILS:      
--!
--!- Project Name: Gera_OMR.v                       
--!- Module Name: Gera_OMR
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 17/2/2014     
--!- Version: 1.0.0 (Fev/2014) 
--------------------------------------------------------------------------------
-- LNLS - DET - 2014
--------------------------------------------------------------------------------
--}}} Header*/

--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------------------------
entity Gera_Rajada_Load_CounterL is
--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------
port(
	-- Entradas Nios 
	In_Reset                    : in std_logic;
	In_Clk               		 : in std_logic;
	In_Send              		 : in std_logic;
	
	In_POLARITY         	   	 : in std_logic;
	In_DISC_CSM_SPM      		 : in std_logic;
	In_COUNT_L           		 : in std_logic_vector(1 downto 0);
	In_EQUALIZATION      		 : in std_logic;
	In_COLOUR_MODE       		 : in std_logic;
	In_CSM_SPM           		 : in std_logic;
	In_GAIN_MODE    		       : in std_logic_vector(1 downto 0);
	
	-- Saidas
	Out_Clk_Medipix             : out std_logic :='0';
	Out_Data_Mdpx               :	out std_logic :='0';
	Out_En_Mdpx                 : out std_logic :='1'

);

end Gera_Rajada_Load_CounterL;

architecture Gera_Rajada_Load_CounterL_arc of Gera_Rajada_Load_CounterL is
--------------------------------------------------------------------------------
--  >> Declaração dos sinais do Processo
--------------------------------------------------------------------------------

signal Mdpx_clk_up   : std_logic :='1';
signal Mdpx_clk_down : std_logic :='1';

begin
process (In_Clk, In_Reset, Mdpx_clk_up, Mdpx_clk_down)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------
variable conta_byte		       : natural range 0 to 1048575 := 0;

begin

Out_Clk_Medipix<=(Mdpx_clk_up xor Mdpx_clk_down);

--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then
	-- Inicialização das saídas
	Out_Clk_Medipix     <='0';
	Out_Data_Mdpx       <='0';
	Out_En_Mdpx         <='1';
	
	conta_byte          :=0;

elsif (falling_edge(In_Clk))then

   ---------------------------------------------------
	--clock 
	---------------------------------------------------
	if conta_byte=0 then 
	--inicio sinc byte
	elsif conta_byte>=2 and conta_byte<=81 then
	   Mdpx_clk_down<=not(Mdpx_clk_down);
	--inicio 10'b0
	elsif conta_byte>=83 and conta_byte<=96 then
	   Mdpx_clk_down<=not(Mdpx_clk_down);
	--inicio execucao
	elsif conta_byte>=101 and conta_byte<=393605 then
	   Mdpx_clk_down<=not(Mdpx_clk_down);
	------------------------------------------------
	elsif conta_byte>=393609 and conta_byte<=393619 then
	   Mdpx_clk_down<=not(Mdpx_clk_down);
	------------------------------------------------
	------------------------------------------------
	--inicio pacote 2
	elsif conta_byte>=393623 and conta_byte<=787127 then
	   Mdpx_clk_down<=not(Mdpx_clk_down);
	------------------------------------------------
	elsif conta_byte>=787130 and conta_byte<=787140 then
	   Mdpx_clk_down<=not(Mdpx_clk_down);
	------------------------------------------------
	else
	   Mdpx_clk_down<='0';
	end if;
		
--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------	
elsif (rising_edge(In_Clk)) then

	
	if In_Send = '1' then
	conta_byte:=0;
	Out_En_Mdpx<='1';
	else
	
	---------------------------------------------------
	--clock 
	---------------------------------------------------
	if conta_byte=0 then
	--inicio sinc byte
	elsif conta_byte>=1 and conta_byte<=80 then
	   Mdpx_clk_up<=not(Mdpx_clk_up);
	--inicio 10'b0
	elsif conta_byte>=83 and conta_byte<=96 then
	   Mdpx_clk_up<=not(Mdpx_clk_up);
	--inicio execucao
	elsif conta_byte>=100 and conta_byte<=393605 then
	   Mdpx_clk_up<=not(Mdpx_clk_up);
	------------------------------------------------
	elsif conta_byte>=393609 and conta_byte<=393619 then
	   Mdpx_clk_up<=not(Mdpx_clk_up);
	------------------------------------------------
	--inicio pacote 2
	elsif conta_byte>=393622 and conta_byte<=787126 then
	   Mdpx_clk_up<=not(Mdpx_clk_up);
	------------------------------------------------
	elsif conta_byte>=787130 and conta_byte<=787140 then
	   Mdpx_clk_up<=not(Mdpx_clk_up);
	------------------------------------------------
	else
	   Mdpx_clk_up<='0';
	end if;
	
	------------------------------------------------
	--envio de dados
	------------------------------------------------
	if conta_byte=0 then
	------------------------------------------------
	-- inicio manda omr
   -- cabecalho 0011 12'b0   
	elsif conta_byte=1 then
      Out_En_Mdpx<='0';
		Out_Data_Mdpx<='0';
	elsif conta_byte=2 then
		Out_Data_Mdpx<='0';
	elsif conta_byte=3 then
		Out_Data_Mdpx<='1';
	elsif conta_byte=4 then
		Out_Data_Mdpx<='1';
		
	elsif conta_byte>=5 and conta_byte<=16 then
		Out_Data_Mdpx<='0';
	--fim cabecalho
	---------------------------------------
	-- comeco da OMR
	elsif conta_byte=17 then
		Out_Data_Mdpx<='0';--> load counter l
	elsif conta_byte=18 then
		Out_Data_Mdpx<='1';--> load counter l
	elsif conta_byte=19 then
		Out_Data_Mdpx<='0';--> load counter l
	elsif conta_byte=20 then
	   Out_Data_Mdpx<='0';-- sequencial
	elsif conta_byte=21 then
	   Out_Data_Mdpx<=In_POLARITY;
	elsif conta_byte=22 then
	   Out_Data_Mdpx<='0';-- data 0
	elsif conta_byte=23 then
	   Out_Data_Mdpx<='0';-- 0
	elsif conta_byte=24 then
	   Out_Data_Mdpx<=In_DISC_CSM_SPM;-- disc l
	elsif conta_byte=25 then
	   Out_Data_Mdpx<='0';-- d tp
	elsif conta_byte=26 then
	   Out_Data_Mdpx<=In_COUNT_L(1);
	elsif conta_byte=27 then
	   Out_Data_Mdpx<=In_COUNT_L(0);
	elsif conta_byte=28 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=29 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=30 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=31 then
	   Out_Data_Mdpx<='0';-- all coluns
	elsif conta_byte=32 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=33 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=34 then
	   Out_Data_Mdpx<='1';-- 0:127
	elsif conta_byte=35 then
	   Out_Data_Mdpx<='1';-- matrix roll
	elsif conta_byte=36 then
	   Out_Data_Mdpx<=In_EQUALIZATION;
	elsif conta_byte=37 then
	   Out_Data_Mdpx<=In_COLOUR_MODE;
	elsif conta_byte=38 then
	   Out_Data_Mdpx<=In_CSM_SPM;
	elsif conta_byte=39 then
	   Out_Data_Mdpx<='0';-- no info
	elsif conta_byte=40 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=41 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=42 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=43 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=44 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=45 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=46 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=47 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=48 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=49 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=50 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=51 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=52 then
	   Out_Data_Mdpx<=In_GAIN_MODE(1);
	elsif conta_byte=53 then
	   Out_Data_Mdpx<=In_GAIN_MODE(0);
	elsif conta_byte=54 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=55 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=56 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=57 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=58 then
	   Out_Data_Mdpx<='0';
   elsif conta_byte=59 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=60 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=61 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=62 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=63 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=64 then
	   Out_Data_Mdpx<='0';
	-- fim da OMR
	--------------------------------
	-- inicio post sync 8'b10	
	--------------------------------
	elsif conta_byte=65 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=66 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=67 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=68 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=69 then
	   Out_Data_Mdpx<='1';
   elsif conta_byte=70 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=71 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=72 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=73 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=74 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=75 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=76 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=77 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=78 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=79 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=80 then
	   Out_Data_Mdpx<='0';
	-- fim post sync
	---------------------------------
	--10'b0
	elsif conta_byte>=81 and conta_byte<=94 then
	   Out_Data_Mdpx<='0';
		Out_En_Mdpx<='0';
   elsif conta_byte>=95 and conta_byte<=99 then
	   Out_Data_Mdpx<='0';
		Out_En_Mdpx<='1';
	---------------------------------
	-- inicio execucao 
	-- cabecalho 0101 12'b0   
	elsif conta_byte=100 then
      Out_En_Mdpx<='0';
		Out_Data_Mdpx<='0';
	elsif conta_byte=101 then
		Out_Data_Mdpx<='1';
	elsif conta_byte=102 then
		Out_Data_Mdpx<='0';
	elsif conta_byte=103 then
		Out_Data_Mdpx<='1';
		
	elsif conta_byte>=104 and conta_byte<=115 then
		Out_Data_Mdpx<='0';
	--fim cabecalho
	-------------------------------
	-------------------------------
	--inicio pacote 1
	elsif conta_byte>=116 and conta_byte<=393588 then
	  
	
   --------------------------------
   --inicio fim de pacote 1
	elsif conta_byte>= 393589 and conta_byte<=393604 then
		Out_Data_Mdpx<=not(Mdpx_clk_up);
	elsif conta_byte>=393605 and conta_byte<=393618 then
	   Out_Data_Mdpx<='0';
	--levanta o enable
	elsif conta_byte>= 393619 and conta_byte<=393621 then
	   Out_En_Mdpx<='1';
		Out_Data_Mdpx<='0';
	--fim de pacote 1
	--------------------------------
	 
	-- inicio execucao 2
	-- cabecalho 0101 12'b0   
	elsif conta_byte=393622 then
      Out_En_Mdpx<='0';
		Out_Data_Mdpx<='0';
	elsif conta_byte=393623 then
		Out_Data_Mdpx<='1';
	elsif conta_byte=393624 then
		Out_Data_Mdpx<='0';
	elsif conta_byte=393625 then
		Out_Data_Mdpx<='1';
		
	elsif conta_byte>=393626 and conta_byte<=393637 then
		Out_Data_Mdpx<='0';
	--fim cabecalho 
	--inicio pacote 2
	elsif conta_byte>=393638 and conta_byte<=787110 then
	---------------------------------
	 
	
   --------------------------------
   --inicio fim de pacote 2
	elsif conta_byte>= 787111 and conta_byte<=787126 then
		Out_Data_Mdpx<=Mdpx_clk_up;
	elsif conta_byte>=787127 and conta_byte<=787140 then
	   Out_Data_Mdpx<='0';
	--levanta o enable
	elsif conta_byte>= 787141 then
	   Out_En_Mdpx<='1';
		Out_Data_Mdpx<='0';
	--fim de pacote 2
	--------------------------------
	else
	   Out_Data_Mdpx<='0';
		Out_En_Mdpx<='1';
		conta_byte:=1048574;
	end if;
	
   if conta_byte< 1048574 then
		conta_byte:=conta_byte+1;
	else
	   conta_byte:=1048575;
	end if;
	
	end if;
end if;
End process;
end Gera_Rajada_Load_CounterL_arc;
