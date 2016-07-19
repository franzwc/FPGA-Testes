
--------------------------------------------------------------------------------
--  >>  Controle de escrita na ram
--------------------------------------------------------------------------------
--
-- >> DESCRIÇÃO DO PROJETO:
--    
-- Projeto que recebe os dados em 8 bits vindos do NIOS
--
--------------------------------------------------------------------------------
--  >> Juliano Silveira Ferreira - INATEL/LINEAR - Nov/2007
--------------------------------------------------------------------------------


Library ieee;
use ieee.std_logic_1164.all;			-- Std_logic types and related functions;
--use ieee.std_logic_arith.all;			-- Arithmetic functions;
use ieee.numeric_std.all;				--
use ieee.std_logic_unsigned.all;		-- Std_logic unsigned functions;


entity txdata_tovhdl is




--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------

port(
	-- Entradas
	IN_CLOCK   				:   in std_logic;							-- clock 
	IN_nRESET    			:   in std_logic;							-- reset baixo ativo
	
	IN_NEWTABLE 			:   in std_logic;	
	
	-- Saídas
	OUT_EN_RD				:   out std_logic;
	OUT_ADR_RD				:   out std_logic_vector(10 downto 0);
	OUT_START_RD 			:   out std_logic;
	OUT_REQRDY 				:   out std_logic;
	OUT_BUSY			      :   out std_logic

	);

end txdata_tovhdl;

architecture txdata_tovhdl_arc of txdata_tovhdl is

begin

process (IN_CLOCK, IN_nRESET)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------

variable adr_rd				: std_logic_vector(10 downto 0);
variable hab_rd				: std_logic;
variable conta_clk 			: integer range 0 to 15;

begin

--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------

if (IN_nRESET = '0') THEN

	-- Inicialização das saídas
	OUT_EN_RD<='0';
	OUT_ADR_RD<=(others=>'0');	
	OUT_START_RD<='1';
	OUT_REQRDY<='0';
	OUT_BUSY<='0';
	--
	adr_rd:=(others=>'0');
	hab_rd:='0';
	conta_clk:=0;

	
--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------

elsif (IN_CLOCK'event and IN_CLOCK='1') then

		
	if 	(IN_NEWTABLE='1' and hab_rd='0' ) then
		-- requisição de leitura de tabela
		hab_rd:='1';	
		adr_rd:=(others=>'0');
		conta_clk:=1;
		OUT_BUSY<='1';
	end if;	
		
		
	if  hab_rd='1' then
	--lendo tabela do buffer

		OUT_ADR_RD<=adr_rd;
		OUT_EN_RD<='1';

		--inicio de leitura =  SYNC
		if adr_rd=0 then
			OUT_START_RD<='1';
		else
			OUT_START_RD<='0';
		end if;
		--endereço de leitura
		adr_rd:=adr_rd+"00000001";
		
		if adr_rd=1023 then
		-- finalizou leitura da tabela
			hab_rd:='0';
		end if;	
			

		else
		
			OUT_EN_RD<='0';
			OUT_BUSY<='0';
		end if;
		
	--sinaliza que começou a ler
	if conta_clk > 0 and conta_clk < 10 then
		conta_clk:=conta_clk+1;
		OUT_REQRDY<='1';
	else
		OUT_REQRDY<='0';
	end if;
	
	
		
end if;

End process;

end txdata_tovhdl_arc;

--------------------------------------------------------------------------------
--  >> TÉRMINO DO PROGRAMA
--------------------------------------------------------------------------------