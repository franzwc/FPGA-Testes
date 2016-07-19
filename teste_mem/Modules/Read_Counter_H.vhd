-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Medipix Bridge
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Bridge de comunicacao com o chip medipix
--!
--! DETAILS:      
--!
--!- Project Name: Medipix_Bridge.v                       
--!- Module Name: Medipix_Bridge
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
use ieee.std_logic_1164.all;			-- Std_logic types and related functions;
use ieee.numeric_std.all;				-- X Not use with std_logic_arith
--------------------------------------------------------------------------------


entity Read_Counter_H is

--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------

port(
	
	-- Entradas Medipix
	In_Reset                    :   in std_logic;
	In_Clk_Mdpx                 :   in std_logic;
	In_En_RCH                   :   in std_logic;
   In_Data_RCH                 :	  in std_logic;
	In_M                        :	  in std_logic_vector(2 downto 0);
	In_PS                       :	  in std_logic_vector(1 downto 0);
	In_CountL                   :	  in std_logic_vector(1 downto 0);
	
	Out_Addr                    :   out std_logic_vector(9 downto 0);
	Out_En_RCH                  :   out std_logic;
	Out_Data_RCH                :   out std_logic_vector(7 downto 0)
		
);

end Read_Counter_H;

architecture Read_Counter_H_arc of Read_Counter_H is

type Pipe_256x256 is array (0 to 255) of std_logic_vector(255 downto 0);
signal X : Pipe_256x256;

signal sig_in_data_mdpx        :  std_logic;
signal sig_in_en_atual         :  std_logic;
signal sig_in_en_anterior      :  std_logic;

begin

process (In_Clk_Mdpx, In_Reset)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------

variable conta_byte		     : natural :=0;
variable conta_bite_linha    : natural :=0;
variable conta_bite_coluna   : natural :=0;

begin

--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) THEN

	-- Inicialização das saídas
	Out_En_RCH          <='0';
	Out_Data_RCH        <=(others=>'0');
	
	conta_byte          :=0;
	conta_bite_linha    :=0;
	conta_bite_coluna   :=0;

--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------

elsif (falling_edge(In_Clk_Mdpx)) then

	sig_in_data_mdpx<=In_Data_RCH;
	sig_in_en_anterior<=sig_in_en_atual;
	sig_in_en_atual<=In_En_RCH;
	
	
	if (sig_in_en_anterior='0' and sig_in_en_atual ='1') then
		conta_byte:=0;
		conta_bite_linha:=0;
		conta_bite_coluna:=0;
		Out_En_RCH<='0';
	elsif (sig_in_en_anterior='1' and sig_in_en_atual='1') then
		conta_byte:=conta_byte+1;
	end if;
	
	if (conta_byte>=1 and conta_byte<=1024) then
	   conta_bite_linha:=conta_bite_linha+1;
	   if(conta_bite_linha mod 256 = 0) then
			conta_bite_coluna:=conta_bite_coluna+1;
		end if;
		if (conta_bite_linha=256) then
		   conta_bite_linha:=0;
		end if;
	   X(conta_bite_coluna)(conta_bite_linha)<=sig_in_data_mdpx;
	end if;
	
	if conta_byte = 1024 then
	   --conta_byte:=2000;
		conta_bite_linha:=0;
		conta_bite_coluna:=0;
	elsif conta_byte>=1025 then
		conta_bite_linha:=conta_bite_linha+1;
		if (conta_bite_coluna < 3) then
			 Out_En_RCH<='1';
		else 
			 Out_En_RCH<='0';
	   end if;
	end if;
	
	if (conta_bite_linha>=1 and conta_byte>=1025) then
	
	   if (conta_bite_linha mod 256 = 0) then
		    conta_bite_coluna:=conta_bite_coluna+1;
	   end if;
		if conta_bite_linha=256 then
		    conta_bite_linha:=0;
		end if;
		Out_Addr<=std_logic_vector( to_unsigned(conta_byte,10));
	   Out_Data_RCH(0)<=X(conta_bite_coluna)(conta_bite_linha);
	end if;
   

end if;

End process;

end Read_Counter_H_arc;

--------------------------------------------------------------------------------
--  >> TÉRMINO DO PROGRAMA
