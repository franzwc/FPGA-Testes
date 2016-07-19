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
--! - Controla a leitura de dados da FIFO/Buffer.
--! - Inicia a leitura dos dados somente apos atingido nivel minimo da Fifo (1 pacote armazenado) dados somente a partir do inicio do pacote MPEG.
--! - Configuravel: g_PacketLengthAsiMode => Tamanho em bytes dos pacotes a serem armazenados (188 ou 204)
--! - OBs. Cabecalho preparado para documentacao via Doxygen (somente depois de --! aparece).
--!
--! DETAILS:      
--!
--!- Project Name: MUX ISDB-T                       
--!- Module Name: ASI Out Mode       
--!- Tools: Quartus II 8.1, jEdit, Doxygen  
--!- Author: Juliano Silveira Ferreira
--!- Company: Inatel - Inatel Competence Center - ICC-HW 
--!- Create Date: Jun/2007     
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






entity MuxMDIO is
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
	
	i_Ctrl					: in std_logic;				-- Quem controla o Phy: 1 Nios, 0 TX	
	
	
	in_MDIO_Nios		: in std_logic;
	out_MDIO_Nios		: out std_logic;
    in_DIR_Nios		: in std_logic;
    
    in_MDIO_Tx		: in std_logic;
	out_MDIO_Tx		: out std_logic;
    
    -- Phy MII TX
 
     inout_MDIO	: inout std_logic
     
    


);

end MuxMDIO;
--------------------------------------------------------------------------------
--}}} PORTS

--! @brief Architure definition
architecture MuxMDIO_arc of MuxMDIO is
--{{{  >> SIGNALS
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--}}} SIGNALS
begin


--inout_MDIO <= inout_MDIO_Tx when i_Ctrl='0' else inout_MDIO_Nios;


--OK Funcionando
--saida 1
--inout_MDIO <= in_MDIO_Nios when in_DIR_Nios='1' else 'Z';
--Entrada 0
--out_MDIO_Nios <= inout_MDIO when in_DIR_Nios='0' else 'Z';	


--From NIOS
--Saida
inout_MDIO <= 
in_MDIO_Nios when (in_DIR_Nios='1' and i_Ctrl='1') else 
in_MDIO_Tx when (i_Ctrl='0') else
'Z';


--Entrada 0
out_MDIO_Nios <= 
inout_MDIO when (in_DIR_Nios='0' and i_Ctrl='1')  else 
'Z';	





										
--		if (in_DIR_Nios='0') then														-- Entrada
--			inout_MDIO	<= 'Z';
--			out_MDIO		<= inout_MDIO;
--		else																	-- Sa�da
--			inout_MDIO	<= in_MDIO;
--		end if;



--
--Process_MuxMDIO:
--process (i_Clk, i_nRst)
----{{{  >> Variables
----------------------------------------------------------------------------------
--
--
----------------------------------------------------------------------------------
----}}} Variables
--variable v_Ctrl: std_logic;
--variable v_PosRst: std_logic;
--begin
--
----{{{  >> RESET
----------------------------------------------------------------------------------
--if (i_nRst = '0') THEN
--
----Reseting outputs
--
--		--TX
--		inout_MDIO	<= 'Z';
--		out_MDC		<= '0';
--		v_Ctrl:='0';
--		v_PosRst:='1';
----------------------------------------------------------------------------------		
----}}} Reset
-----{{{ >>PROCESSING
----------------------------------------------------------------------------------
--elsif (i_Clk'event and i_Clk='1') then
--
--	
--	
--	if 	v_PosRst='1' then
--		--pos reset
--		inout_MDIO	<= 'Z';
--		out_MDC		<= '0';
--		v_Ctrl:=i_Ctrl;
--		v_PosRst:='0';
--	end if;
--	
--	
--	if i_Ctrl/=v_Ctrl then
--	--trocou o controle
--		inout_MDIO	<= 'Z';
--		out_MDC		<= '0';
--		v_Ctrl:=i_Ctrl;
--	
--	
--	elsif v_Ctrl='0' then
----TX
--  
--    
--
--  	inout_MDIO<=inout_MDIO_Tx;
--    out_MDC <=out_MDC_Tx;
--    -- Phy MII TX
-- 
--     out_PhyTxEna<=out_PhyTxEna_Tx;
--     out_PhyTxData<=out_PhyTxData_Tx;
--     
--   
--     
--elsif v_Ctrl='1' then
----nios
--
--
--  	inout_MDIO<=inout_MDIO_Nios;
--    out_MDC <=out_MDC_Nios;
--    -- Phy MII TX
-- 
--     out_PhyTxEna<=out_PhyTxEna_Nios;
--     out_PhyTxData<=out_PhyTxData_Nios;
--     
--
--end if;
--	
--	
--	
--end if;
--
----------------------------------------------------------------------------------
-----}}} PROCESSING
--End process;




end MuxMDIO_arc;

