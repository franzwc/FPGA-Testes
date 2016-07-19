-- VHDL FILE
--{{{ HEADER
--!@file
--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;			-- Std_logic types and related functions;
use ieee.numeric_std.all;				-- X Not use with std_logic_arith
--use ieee.std_logic_arith.all;			-- Arithmetic functions X Not use whith numeric_std
--use ieee.std_logic_unsigned.all;		-- Std_logic unsigned functions;

--------------------------------------------------------------------------------
--!@brief Control Read ASI Out Mode
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! - 
--! - 
--! - Módulo que obtêm o tamnaho do pacote que sera encapsulado (188 ou 204 bytes).
--! - OBs. Cabecalho preparado para documentacao via Doxygen (somente depois de --! aparece).
--!
--! DETAILS:      
--!
--!- Project Name: MUX ISDB-T                       
--!- Module Name: ASI Out Mode       
--!- Tools: Quartus II 8.1, jEdit, Doxygen  
--!- Author: Getulio Emilio Oliveira Pereira
--!- Company: Inatel - Inatel Competence Center - ICC-HW 
--!- Create Date: Sep/2011    
--   Version: Versao.funcionalidade.correcao                        
--!- Version: 1.0.0 (Sep/2010) > Criado    
--!  
--------------------------------------------------------------------------------
-- Inatel - Inatel Competence Center - ICC-HW - 2010
--------------------------------------------------------------------------------
--
-- Conversion
-- std => Integer  ->  int = to_integer( unsigned());                        
-- integer => Std  ->  std = std_logic_vector( to_unsigned (integer ,8));
-- integer => Unsigned -> to_unsigned(IntNumb, width);
-- UNSIGNED => STD_logic -> std_logic_vector(UnsignedNumb);
--------------------------------------------------------------------------------
--}}} Header



--0		  4				  8			 12			16		   20		 24		   28 		 		31		32
--|-------|---------------|-----------|----------|----------|---------|---------|----------------|--------|
--|MAC Destination													  |MAC Source	     			      |
--|-------------------------------------------------------------------|-----------------------------------|
--|MAC Source									 |Version   |Internet Header    |Type Of Service (TOS)    |
--|----------------------------------------------|----------|-------------------|-------------------------|
--|  TOS  |Total Length (TL)    	  |				Identification			    |	FLAGS		|Fragment |
--|		  | Length (IHL)  			  |										    |			    |Offset   |
--|-------------------------------------------------------------------------------------------------------|
--|Fragment Offset					  |Time To Live (TTL)	|Protocol	        | CheckSum (CS)			  |
--|-----------------------------------|---------------------|-------------------|-------------------------|
--| CS								  |Source Address 													  |
--|-----------------------------------|-------------------------------------------------------------------|
--|Source Adress                      |Destination Address                                                |
--|-----------------------------------|-------------------------------------------------------------------|
--|Destiantio Address				  |Options (Variable)												  |
--|-----------------------------------|-------------------------------------------------------------------|
--|										      Data														  |
--|-------------------------------------------------------------------------------------------------------|		

											 
entity pkt_length is
--{{{  >> GENERIC
--------------------------------------------------------------------------------
--generic(
--g_PacketLengthAsiMode	: integer range 0 to 255:=204 	--! Tamanho do pacote (188/204)
--);
--------------------------------------------------------------------------------
--}}} Generic

--{{{  >> PORTS
--------------------------------------------------------------------------------
port(
	-- Entradas
	i_Clk   				: in std_logic;							--! Clock de 27 MHz
	i_nRst    				: in std_logic;							--! Reset Baixo Ativo
	
	i_Valid					: in std_logic;
	i_Sync					: in std_logic;	
	--i_BTS					: in std_logic;		
	

	
	
	-- Saídas
	o_BTS					: out std_logic;		
	o_PktLength				: out integer range 0 to 204


);

end pkt_length;
--------------------------------------------------------------------------------
--}}} PORTS

--! @brief Architure definition
architecture pkt_length_arc of pkt_length is
--{{{  >> SIGNALS
--------------------------------------------------------------------------------
--signal v_conta						: integer range 0 to 2;

--------------------------------------------------------------------------------
--}}} SIGNALS
begin
Process_Main:
process (i_Clk, i_nRst)
--{{{  >> Variables
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--}}} Variables

variable v_ctrl							: std_logic;
variable v_conta 						: integer range 0 to 300;

begin

--{{{  >> RESET
--------------------------------------------------------------------------------
if (i_nRst = '0' ) THEN

--Reseting outputs
	o_PktLength <= 0;

	v_ctrl := '0';
	v_conta := 0;
--------------------------------------------------------------------------------		
--}}} Reset
---{{{ >>PROCESSING
--------------------------------------------------------------------------------
elsif rising_edge(i_Clk) then

	if v_ctrl = '1' then 
		if i_Valid = '1' and i_Sync = '1' then 
			if v_conta = 188 then --encontrou pkt de 188B
				o_PktLength <= 188;
				o_BTS <= '1';
			elsif v_conta = 204 then --encontrou pkt de 204B
				o_PktLength <= 204;
				o_BTS <= '0';
			end if;
			v_ctrl := '0';
		end if;
	end if;
	
	if v_ctrl = '0' then
		if i_Valid = '1' and i_Sync = '1' then 
			v_conta := 0;
			v_ctrl := '1';
		end if;
	end if;
	
	if i_Valid = '1' and  v_ctrl = '1' then 
		v_conta := v_conta + 1;
	end if;
	
--	if i_BTS = '1' then --pkt 188B
--		o_PktLength <= 188;
--	else
--		o_PktLength <= 204;
--	end if;
	
end if;

--------------------------------------------------------------------------------
---}}} PROCESSING
End process;

end pkt_length_arc;

