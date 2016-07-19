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
--!@brief Control Write 
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! - Controla a gravacao de dados na FIFO/Buffer.
--! - Inicia a gravacao dos dados somente a partir do inicio de um pacote MPEG.
--! - OBs. Cabecalho preparado para documentacao via Doxygen (somente depois de --! aparece).
--!
--! DETAILS:      
--!
--!- Project Name: MUX ISDB-T                       
--!- Module Name: TxTsOIp       
--!- Tools: Quartus II 9.1, jEdit, Doxygen  
--!- Author: Juliano Silveira Ferreira
--!- Company: Inatel - Inatel Competence Center - ICC-HW 
--!- Create Date: JUl/2011     
--   Version: Versao.funcionalidade.correcao                        
--!- Version: 1.0.0 (Jun/2010) > Criado    
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

entity CtrlWrTxTsOIP is
--{{{  >> GENERIC
--------------------------------------------------------------------------------
--generic(
--i_PacketLength	: integer range 0 to 255:=204 	--! Width (in bits) of ID packet
--);
--------------------------------------------------------------------------------
--}}} Generic

--{{{  >> PORTS
--------------------------------------------------------------------------------
port(
-- Inputs
	i_Clk   		:   in std_logic;							--! Clock de recepcao dos dados
	i_nRst    		:   in std_logic;							--! Reset - baixo ativo
	i_Valid			:	in std_logic;							--! Valid/Enalde de dados validos
	i_Sync			:	in std_logic;							--! Sinalizacao de entrada do Byte sincronismo
	i_Data			:	in std_logic_vector(7 downto 0);		--! Dados de entrada
	i_PacketLength	: 	in integer range 0 to 255; 				--! Tamanho em bytes dos pacotes 188 ou 204
-- Outputs
	o_Data			:	out std_logic_vector(7 downto 0);		--! Dados de saida
	o_Valid			:	out std_logic;							--! Valid/Enalde de dados validos
	o_Sync			:	out std_logic							--! Sinalizacao de saida do Byte sincronismo

);
--------------------------------------------------------------------------------
--}}} PORTS

end CtrlWrTxTsOIP;

--! @brief Architure definition
architecture CtrlWrTxTsOIP_arc of CtrlWrTxTsOIP is
begin
Process_CtrlWrTxTsOIP:
process (i_Clk, i_nRst)

--{{{  >> Variables
--------------------------------------------------------------------------------
variable v_ContaByte		: integer range 0 to 1428; --204*7
variable v_Estado			: bit;

--------------------------------------------------------------------------------
--}}} Variables

begin

--{{{  >> RESET
--------------------------------------------------------------------------------
if (i_nRst = '0') THEN

--Reseting outputs
	o_Valid<='0';	
	o_Sync<='0';
	o_Data<=(others=>'0');
--Reseting Signals and variables	
	v_Estado:='0';
	v_ContaByte:=0;

--------------------------------------------------------------------------------		
--}}} Reset
---{{{ >>PROCESSING
--------------------------------------------------------------------------------
elsif (i_Clk'event and i_Clk='1') then


	if v_ContaByte=i_PacketLength then  --204
		--Termino de escrita de um pacote
		v_ContaByte:=0;
		v_Estado:='0';
	else
		null;
	end if;


	if i_Sync='1' and v_Estado='0' and i_Valid='1' then
		--Aguarda primerio sync para gravar dados na fifo
		v_Estado:='1';
		v_ContaByte:=0;
	end if;


	if v_Estado='1' and i_Valid='1'  then
		--Repassa dados para o Buffer
		o_Valid<=i_Valid;
		o_Sync<=i_Sync;
		o_Data<=i_Data;
	
		if v_ContaByte<=(i_PacketLength-1) then
		-- Contabilzia dados
			v_ContaByte:=v_ContaByte+1;
		end if;
		
	else
	--Nao repassa dados para o Buffer
		o_Valid<='0';	
		o_Sync<='0';
		o_Data<=(others=>'0');

	end if;

	
end if;

--------------------------------------------------------------------------------
---}}} PROCESSING
end process;

end CtrlWrTxTsOIP_arc;
