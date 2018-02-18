library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
	
entity MUX2_1 is
	generic(pathwidth: integer);
	port(I0: in std_logic_vector(pathwidth-1 downto 0);
	I1: in std_logic_vector(pathwidth-1 downto 0); 
	S0: in std_logic;
	O: out std_logic_vector(pathwidth-1 downto 0));
end MUX2_1;

architecture arh_MUX2_1 of MUX2_1 is
begin
	process(I0,I1,S0)
	variable intQ: std_logic_vector(pathwidth-1 downto 0);
	begin
		if S0='0' then
			intQ:=I0;
		else
			intQ:=I1;
		end if;	
		O<=intQ;
	end process;
end;	 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity I4_O1 is
	port(A: in std_logic_vector(3 downto 0);
	O: out std_logic);
end I4_O1;

architecture And_gate_test_1101 of I4_O1 is
begin
	O<=A(3) and A(2) and not(A(1)) and A(0);
end;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ent_ALU is  
	port(A,B,Const: in std_logic_vector(7 downto 0);
	Instr: in std_logic_vector(15 downto 0);
	CIN: in std_logic;
	Y: out std_logic_vector(7 downto 0);
	Zero,Carry: out std_logic);
end;						   

architecture arh_ALU of ent_ALU is	

component MUX2_1 is
	generic(pathwidth: integer:=1);
	port(I0: in std_logic_vector(pathwidth-1 downto 0);
	I1: in std_logic_vector(pathwidth-1 downto 0); 
	S0: in std_logic;
	O: out std_logic_vector(pathwidth-1 downto 0));
end component;	  

component I4_O1 is
	port(A: in std_logic_vector(3 downto 0);
	O: out std_logic);
end component;

component ALU2 is 
	port(A,B: in std_logic_vector(7 downto 0);
	CIN: in std_logic;
	SEL: in std_logic_vector(2 downto 0);
	Y: out std_logic_vector(7 downto 0);
	COUT: out std_logic;
	ZERO: out std_logic);
end	component; 

component shift_reg is
	port(A:in std_logic_vector(7 downto 0);
	sel:in std_logic_vector(2 downto 0);
	B3:in std_logic; 
	CarryI:in std_logic;
	R:out std_logic_vector(7 downto 0);
	Zero,CarryO:out std_logic);
end component;

signal V1,V2,V3: std_logic_vector(7 downto 0);
signal intZero0, intZero1: std_logic;
signal intCarry0, intCarry1: std_logic; 
signal intSel,intSel1: std_logic;
signal intSel3b,intSel3b2: std_logic_vector(2 downto 0);

begin
	U0:Mux2_1
	generic map(pathwidth=>8)
	port map(Const,B,Instr(15),V1);
	U1:Mux2_1
	generic map(pathwidth=>3)
	port map(Instr(14 downto 12),Instr(2 downto 0),Instr(15),intSel3b);
	U2:Mux2_1
	generic map(pathwidth=>8)
	port map(V3,V2,intSel,Y);
	U3:Mux2_1
	generic map(pathwidth=>1)
	port map(I0(0)=>intZero0,I1(0)=>intZero1,S0=>intSel,O(0)=>Zero);
	U4:Mux2_1
	generic map(pathwidth=>1)
	port map(I0(0)=>intCarry0,I1(0)=>intCarry1,S0=>intSel,O(0)=>Carry);
	U5:I4_O1
	port map(Instr(15 downto 12),intSel);                                                                    
	U6:ALU2
	port map(A,V1,CIN,intSel3b,V3,intCarry0,intZero0);
	U7:Shift_reg
	port map(A,Instr(2 downto 0),Instr(3),CIN,V2,intZero1,intCarry1);
	U8:Mux2_1
	generic map(pathwidth=>3)
	port map(intSel3b,"000",intSel1,intSel3b2);
	intSel1<='1' when instr(15 downto 13)="100" or instr(15 downto 13)="111" or instr(15 downto 13)="101" else '0';
end;

library ieee;
use ieee.std_logic_1164.all;   
use ieee.std_logic_unsigned.all;

entity debouncer is
	port(button: in std_logic;
	clk: in std_logic;
	result: out std_logic);
end debouncer;

architecture a1 of debouncer is
signal ff: std_logic_vector(1 downto 0);
signal counter_set: std_logic;
signal counter_cont: std_logic_vector(19 downto 0);
begin
	counter_set<=ff(0) xor ff(1);
	process(clk)
	begin
		if clk'event and clk='1' then
			ff(0)<=button;
			ff(1)<=ff(0);
			if counter_set='1' then
				counter_cont<=(others=>'0');
			elsif(counter_cont(19)='0') then
				counter_cont<=counter_cont+1;
			else
				result<=ff(1);
			end if;
		end if;
	end process;
end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
	
entity ALU2 is -- ALU2 
	port(A,B: in std_logic_vector(7 downto 0);
	CIN: in std_logic;
	SEL: in std_logic_vector(2 downto 0);
	Y: out std_logic_vector(7 downto 0);
	COUT: out std_logic;
	ZERO: out std_logic);
end ALU2;

architecture operatii of ALU2 is
signal sum: std_logic_vector(8 downto 0);
signal intY: std_logic_vector(7 downto 0);
begin
	op: process(A,B,CIN,SEL)
	variable sum: std_logic_vector(8 downto 0);
	begin
		case SEL is
			when "000" => intY <= B;
			COUT<='0';
			when "001" => intY <= A and B;
			COUT<='0';
			when "010" => intY <= A or B;
			COUT<='0';
			when "011" => intY <= A xor B;
			COUT<='0';
			when "100" => sum := ('0'&A) + ('0'&B);
			COUT<=sum(8);
			intY<=sum(7 downto 0);		
			when "101" => sum := ('0'&A) + ('0'&B) + CIN;
			COUT<=sum(8);
			intY<=sum(7 downto 0);
			when "110" => sum := ('0'&A) - ('0'&B);
			COUT<=sum(8);
			intY<=sum(7 downto 0);
			when "111" => sum := ('0'&A) - ('0'&B) - CIN;
			COUT<=sum(8);
			intY<=sum(7 downto 0);
			when others => sum := "000000000";
		end case;	
	end process op;
	Y<=intY;
	Zero<='1' when intY="00000000" else '0';
end architecture operatii;

library ieee;
use ieee.std_logic_1164.all;

entity MUX8_1 is
	port(I0,I1,I2,I3,I4,I5,I6,I7:in std_logic;
	sel:in std_logic_vector(2 downto 0);
	R:out std_logic);
end MUX8_1;

architecture arh1 of MUX8_1 is
begin
	process(I0,I1,I2,I3,I4,I5,I6,I7,sel)
	begin
		case sel is
			when "000"=>R<=I0;
			when "001"=>R<=I1;
			when "010"=>R<=I2;
			when "011"=>R<=I3;
			when "100"=>R<=I4;
			when "101"=>R<=I5;
			when "110"=>R<=I6;
			when "111"=>R<=I7;
			when others=>R<='0';
		end case;
	end process;
end architecture arh1;	 

library ieee;
use ieee.std_logic_1164.all;

entity shift_reg is	  --Shift-Register
	port(A:in std_logic_vector(7 downto 0);
	sel:in std_logic_vector(2 downto 0);
	B3:in std_logic; 
	CarryI:in std_logic;
	R:out std_logic_vector(7 downto 0);
	Zero,CarryO:out std_logic);
end shift_reg;

architecture arh2 of shift_reg is

component MUX2_1 is
	generic(pathwidth: integer);
	port(I0: in std_logic_vector(pathwidth-1 downto 0);
	I1: in std_logic_vector(pathwidth-1 downto 0); 
	S0: in std_logic;
	O: out std_logic_vector(pathwidth-1 downto 0));
end component;

component MUX8_1 is
	port(I0,I1,I2,I3,I4,I5,I6,I7:in std_logic;
	sel:in std_logic_vector(2 downto 0);
	R:out std_logic);
end component;	

signal iR1,iR2,intCarry0,intCarry1:std_logic;
signal iR3,iR4,intR:std_logic_vector(7 downto 0);

begin
	U0:MUX8_1 port map(CarryI,'0',A(0),'0',A(7),'0','0','1',sel,iR1);	--shift right
	U1:MUX8_1 port map(CarryI,'0',A(7),'0',A(0),'0','0','1',sel,iR2);	--shift left 
	iR3(6 downto 0)<=A(7 downto 1);   --shift left
	iR3(7)<=iR1;
	iR4(7 downto 1)<=A(6 downto 0);	  --shift left
	iR4(0)<=iR2;
	U2:MUX2_1
	generic map(pathwidth=>8)
	port map(iR4,iR3,B3,intR);
	U3:MUX2_1
	generic map(pathwidth=>1)
	port map(I0(0)=>intCarry0,I1(0)=>intCarry1,S0=>B3,O(0)=>CarryO); 
	intCarry0<=A(7);
	intCarry1<=A(0);
	R<=intR;
	process(intR)
	begin
		if intR="00000000" then Zero<='1'; else Zero<='0'; end if;	
	end process;
end architecture arh2;

library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity num_princ is	 --Program Counter
	port(clk: in std_logic;	
	reset: in std_logic;
	le: in std_logic;
	interruptSig: in std_logic;
	addressI: in std_logic_vector(7 downto 0);
	addressO: out std_logic_vector(7 downto 0));
end num_princ;

architecture arh1 of num_princ is
signal intQ: std_logic_vector(7 downto 0):="00000000";
begin
	process(clk,reset)
	begin
		if reset='1' then
			intQ<="00000000";
		else	
			if clk'event and clk='1' then
				if le='1' then
					intQ<=addressI;
				elsif interruptSig='1' then
					intQ<="11111111";
				else
					intQ<=intQ+1;	
				end if;
			end if;
		end if;
	end process;
	addressO<=intQ;
end;

library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MUX4_1 is
	generic(N:integer);
	port(I0,I1,I2,I3:in std_logic_vector(N-1 downto 0);
	S:in std_logic_vector(1 downto 0);
	O:out std_logic_vector(N-1 downto 0));
end MUX4_1;						  

architecture arh of MUX4_1 is
begin
	process(I0,I1,I2,I3,S)
	variable intQ:std_logic_vector(N-1 downto 0);
	begin
		case S is
			when "00"=>intQ:=I0;
			when "01"=>intQ:=I1;
			when "10"=>intQ:=I2;
			when others=>intQ:=I3;
		end case;
		O<=intQ;
	end process;
end architecture arh;	

library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cond_check is
	port(Carry,Zero:in std_logic;
	instr:in std_logic_vector(15 downto 0);
	Enable:out std_logic);
end cond_check;

architecture arh1 of cond_check is
component MUX2_1 is
	generic(pathwidth: integer);
	port(I0: in std_logic_vector(pathwidth-1 downto 0);
	I1: in std_logic_vector(pathwidth-1 downto 0); 
	S0: in std_logic;
	O: out std_logic_vector(pathwidth-1 downto 0));
end component;
component MUX4_1 is
	generic(N:integer);
	port(I0,I1,I2,I3:in std_logic_vector(N-1 downto 0);
	S:in std_logic_vector(1 downto 0);
	O:out std_logic_vector(N-1 downto 0));
end component;
signal S1,S2,S3:std_logic;
begin
	U1:MUX2_1
	generic map(pathwidth=>1)
	port map(I0(0)=>'1',I1(0)=>S1,S0=>instr(12),O(0)=>Enable);
	U2:MUX4_1
	generic map(N=>1)
	port map(I0(0)=>Zero,I1(0)=>S2,I2(0)=>Carry,I3(0)=>S3,S=>instr(11 downto 10),O(0)=>S1);
	S2<=not(Zero);
	S3<=not(Carry);
end architecture arh1;

library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity num_complet is
	port(instr:in std_logic_vector(15 downto 0);
	addrExt,addrSt:in std_logic_vector(7 downto 0);
	Carry,Zero:in std_logic; 
	reset:in std_logic;
	interruptSig: in std_logic;
	clk:in std_logic;
	Output:out std_logic_vector(7 downto 0));
end num_complet;

architecture arh1 of num_complet is	

component cond_check is
	port(Carry,Zero:in std_logic;
	instr:in std_logic_vector(15 downto 0);
	Enable:out std_logic);
end component; 

component num_princ is
	port(clk: in std_logic;
	reset:in std_logic;
	le: in std_logic;
	interruptSig: in std_logic;
	addressI: in std_logic_vector(7 downto 0);
	addressO: out std_logic_vector(7 downto 0));
end component; 

component MUX2_1 is
	generic(pathwidth: integer);
	port(I0: in std_logic_vector(pathwidth-1 downto 0);
	I1: in std_logic_vector(pathwidth-1 downto 0); 
	S0: in std_logic;
	O: out std_logic_vector(pathwidth-1 downto 0));
end component; 

signal intAddr:std_logic_vector(7 downto 0);
signal S2,S3,S4:std_logic;

begin							
	U1:MUX2_1
	generic map(pathwidth=>8)
	port map(addrSt,addrExt,instr(8),intAddr);
	U2:cond_check port map(carry,Zero,instr,S2);
	U3:num_princ port map(Clk,reset,S3,interruptSig,intAddr,Output);
	S4<=instr(15) and not(instr(14)) and not(instr(13));
	S3<=S4 and S2 when instr/="1000000000110000" and instr/="1000000000010000" else '0';
end architecture arh1;

library ieee;
use ieee.std_logic_1164.all;

entity clk_div is
	port(clk:in std_logic;
	O0,O1:out std_logic);
end clk_div;

architecture arh1 of clk_div is
signal intQ:std_logic:='0';
begin
	process(clk)
	begin
		if clk'event and clk='1' then
			intQ<=not(intQ);
		end if;
	end process;
	O0<=intQ;
	O1<=not(intQ);
end architecture arh1;

library ieee;
use ieee.std_logic_1164.all;

entity storage is
	port(instr:in std_logic_vector(15 downto 0);
	clk: in std_logic;
	reset:in std_logic;
addr:in std_logic_vector(7 downto 0);
	interruptEnable: out std_logic);
end storage;

architecture arh1 of storage is
signal intQ:std_logic;
begin
	process(clk,reset)
	begin
		if reset='1' then
			intQ<='0';
		else
			if clk'event and clk='1' then
				if instr="1000000011110000" or instr="1000000000110000" then
					intQ<='1';
				elsif instr="1000000011010000" or instr="1000000000010000" or addr=”11111111” then
					intQ<='0';
				end if;
			end if;
		end if;
	end process;
	interruptEnable<=intQ;
end architecture arh1;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity counter4bit is  --Counter from stack
	port(CU: in std_logic;
	CE: in std_logic; 
	reset:in std_logic;
	clk: in std_logic;
	Y: out std_logic_vector(3 downto 0));
end counter4bit;

architecture numar of counter4bit is
signal intQ: std_logic_vector(3 downto 0):= "0000";
begin
	numara: process(clk,reset,ce)
	begin 
		if reset='1' then
			intQ<="0000";
		else
			if clk'event and clk='1' then	
				if(CE = '1') then
					if(CU = '1') then
						intQ<=intQ + 1;
					else 
						intQ<=intQ - 1;
					end if;
				end if;	
			end if;
		end if;
	end process numara;
	Y<=intQ;
end architecture numar;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity stack is    --Stack RAM
	port(WE: in std_logic;
	A: in std_logic_vector(7 downto 0);
	SEL: in std_logic_vector(3 downto 0);
	CLK: in std_logic;
	Y: out std_logic_vector(7 downto 0));
end stack;

architecture stack_RAM of stack is
type RAM_cell is array (15 downto 0) of std_logic_vector(7 downto 0);
signal RAM_stack: RAM_cell;
begin
	stiva: process(CLK,WE,A)
	begin
		if(CLK'EVENT) and CLK = '1'	then
			if WE = '1' then
				RAM_stack(conv_integer(SEL+1))<=A;
			end if;								  
		Y<=RAM_stack(conv_integer(SEL));
		end if;
	end process stiva;
end architecture stack_RAM;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity complete_stack is		--Program Counter Stack
	port(instr:in std_logic_vector(15 downto 0);
	Cont:in std_logic_vector(7 downto 0);
	Carry,Zero:in std_logic;
	reset:in std_logic;
	interrupt:in std_logic;
	clk:in std_logic;
	Output: out std_logic_vector(7 downto 0));
end complete_stack;


architecture arh1 of complete_stack is
component stack is 
	port(WE: in std_logic;
	A: in std_logic_vector(7 downto 0);
	SEL: in std_logic_vector(3 downto 0);
	CLK: in std_logic;
	Y: out std_logic_vector(7 downto 0));
end component;
component CE is
	port(A,B,C,D,E: in std_logic;
	Y: out std_logic);
end component;
component counter4bit is 
	port(CU: in std_logic;
	CE: in std_logic;
	reset:in std_logic;
	clk: in std_logic;
	Y: out std_logic_vector(3 downto 0));
end component;
component cond_check is
	port(Carry,Zero:in std_logic;
	instr:in std_logic_vector(15 downto 0);
	Enable:out std_logic);
end component;
signal s1,s3,s4,s5,s6,s7,s8:std_logic;
signal s2:std_logic_vector(3 downto 0);
begin
	U0:CE port map(instr(15),instr(14),instr(13),instr(9),instr(8),s1);
	U1:counter4bit port map(s6,s8,reset,clk,s2);
	U2:stack port map(s5,Cont,s2,clk,Output);	
	U3:cond_check port map(Carry,Zero,instr,s3);
	s4<=s1 and s3;
	s5<=instr(9) or interrupt;
	s6<=instr(8) or interrupt;
	check_returni:process(instr)
	begin
		if instr="1000000011110000" or instr="1000000011010000" then
			s7<='1';
		else
			s7<='0';
		end if;
	end process;
	s8<=s4 or interrupt or s7;
end architecture arh1;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ROMMemory is --ROM Instruction Memory
	port(SEL: in std_logic_vector(7 downto 0);
	clk:in std_logic;
	Y: out std_logic_vector(15 downto 0));
end ROMMemory;

architecture ROM of ROMMemory is
type ROM_cell is array (0 to 255) of std_logic_vector(15 downto 0);
signal ROM_Memory:ROM_cell := ();
signal intY:std_logic_vector(15 downto 0);
begin
	intY<=ROM_Memory(conv_integer(sel));
	Y<=intY when clk'event and clk='1';
end architecture ROM;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity program_counter is	-- Program Flow Control
	port(instr:in std_logic_vector(15 downto 0);
	Carry,Zero:in std_logic;
	reset:in std_logic;
	interrupt:in std_logic;
	clk:in std_logic;
	addr:out std_logic_vector(7 downto 0));
end program_counter;

architecture arh of program_counter is
component complete_stack is
	port(instr:in std_logic_vector(15 downto 0);
	Cont:in std_logic_vector(7 downto 0);
	Carry,Zero:in std_logic;
	reset:in std_logic;
	interrupt:in std_logic;
	clk:in std_logic;
	Output: out std_logic_vector(7 downto 0));
end component;

component num_complet is
	port(instr:in std_logic_vector(15 downto 0);
	addrExt,addrSt:in std_logic_vector(7 downto 0);
	Carry,Zero:in std_logic; 
	reset:in std_logic;
	interruptSig: in std_logic;
	clk:in std_logic;
	Output:out std_logic_vector(7 downto 0));
end component;

signal s1,s2,s3:std_logic_vector(7 downto 0);
begin
	U0:num_complet port map(instr,instr(7 downto 0),s3,Carry,Zero,reset,interrupt,clk,s2);
	U1:complete_stack port map(instr,s2,Carry,Zero,reset,interrupt,clk,s1);
	addr<=s2;
	s3<=s1+1;
end architecture arh;

library ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

entity clk200Hz is
    Port (
        clk_in : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        clk_out: out STD_LOGIC
    );
end clk200Hz;

architecture Behavioral of clk200Hz is
    signal temporal: STD_LOGIC;
    signal counter : integer range 0 to 124999 := 0;
begin
    frequency_divider: process (reset, clk_in) begin
        if (reset = '1') then
            temporal <= '0';
            counter <= 0;
        elsif rising_edge(clk_in) then
            if (counter = 124999) then
                temporal <= NOT(temporal);
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    clk_out <= temporal;
end Behavioral;

library ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

entity MUX4_1 is
	generic(N:integer);
	port(I0,I1,I2,I3:in std_logic_vector(N-1 downto 0);
	S:in std_logic_vector(1 downto 0);
	O:out std_logic_vector(N-1 downto 0));
end MUX4_1;						  

architecture arh of MUX4_1 is
begin
	process(I0,I1,I2,I3,S)
	variable intQ:std_logic_vector(N-1 downto 0);
	begin
		case S is
			when "00"=>intQ:=I0;
			when "01"=>intQ:=I1;
			when "10"=>intQ:=I2;
			when others=>intQ:=I3;
		end case;
		O<=intQ;
	end process;
end architecture arh;

library ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

entity conv_to_bcd is
	port(nrIN1,nrIN2,nrIN3,nrIN4: in std_logic_vector(3 downto 0);
	nrOut1,nrOut2,nrOut3,nrOut4: out std_logic_vector(6 downto 0));
end conv_to_bcd;

architecture arh of conv_to_bcd is
type cont is array(0 to 15) of std_logic_vector(0 to 6);
signal intQ: cont:=("0000001","1001111","0010010","0000110","1001100","0100100","0100000","0001111","0000000","0000100","0001000","1100000","0110001","1000010","0110000","0111000");
begin
	nrOut1<=intQ(conv_integer(nrIN1));
	nrOut2<=intQ(conv_integer(nrIN2));
	nrOut3<=intQ(conv_integer(nrIN3));
	nrOut4<=intQ(conv_integer(nrIN4));
end architecture arh;

library ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

entity num2bit is
	port(clk: in std_logic;
	Q:out std_logic_vector(1 downto 0));
end num2bit;

architecture arh of num2bit is	
signal intQ: std_logic_vector(1 downto 0):="00";
begin
	process(clk)
	begin
		if(clk'event and clk='1') then
			intQ<=intQ+1;
		end if;
	end process;
	Q<=intQ;
end architecture arh; 

library ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

entity DMUX1_4 is
	port(I:in std_logic;
	sel:in std_logic_vector(1 downto 0);
	O:out std_logic_vector(3 downto 0));
end DMUX1_4;

architecture arh1 of DMUX1_4 is
begin
	process(I,sel)
	begin
		if(sel="00") then
			O(0)<=I;
			O(3 downto 1)<="000";
		elsif(sel="01") then
			O(0)<='0';
			O(1)<=I;
			O(3 downto 2)<="00";
		elsif(sel="10") then
			O(1 downto 0)<="00";
			O(2)<=I;
			O(3)<='0';
		elsif(sel="11") then
			O(2 downto 0)<="000";
			O(3)<=I;
		end if;
	end process;
end architecture arh1;

library ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

entity led_7_disp is  --LED Display
	port(clk:in std_logic;
	sw:in std_logic_vector(15 downto 0);
	an:out std_logic_vector(3 downto 0);
	seg:out std_logic_vector(0 to 6));
end led_7_disp;

architecture arh of led_7_disp is
component conv_to_bcd is
	port(nrIN1,nrIN2,nrIN3,nrIN4: in std_logic_vector(3 downto 0);
	nrOut1,nrOut2,nrOut3,nrOut4: out std_logic_vector(6 downto 0));
end component;
component num2bit is
	port(clk: in std_logic;
	Q:out std_logic_vector(1 downto 0));
end component;
component DMUX1_4 is
	port(I:in std_logic;
	sel:in std_logic_vector(1 downto 0);
	O:out std_logic_vector(3 downto 0));
end component; 
component MUX4_1 is
	generic(N:integer);
	port(I0,I1,I2,I3:in std_logic_vector(N-1 downto 0);
	S:in std_logic_vector(1 downto 0);
	O:out std_logic_vector(N-1 downto 0));
end component;
component clk200Hz is
    Port (
        clk_in : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        clk_out: out STD_LOGIC
    );
end component;
signal int:std_logic;
signal intQ0,intQ1,intQ2,intQ3:std_logic_vector(0 to 6);
signal sel:std_logic_vector(1 downto 0);
signal an1:std_logic_vector(3 downto 0);
begin
	U0:conv_to_bcd port map(sw(15 downto 12),sw(11 downto 8),sw(7 downto 4),sw(3 downto 0),intQ3,intQ2,intQ1,intQ0);
	U1:num2bit port map(int,sel);
	U2:DMUX1_4 port map('1',sel,an1);	
	U3:MUX4_1
	generic map(N=>7)
	port map(intQ0,intQ1,intQ2,intQ3,sel,seg);
	U4:clk200Hz port map(clk,'0',clk_out=>int);
	an<=not(an1);
end architecture arh;

library ieee;
use ieee.std_logic_1164.all;

entity read_strobe is
	port(instr:in std_logic_vector(15 downto 0);
	O:out std_logic);
end read_strobe;

architecture arh of read_strobe is
begin
	O<='1' when instr(15 downto 13)="101" else '0';
end architecture arh;

library ieee;
use ieee.std_logic_1164.all;

entity write_strobe is
	port(instr:in std_logic_vector(15 downto 0);
	O:out std_logic);
end write_strobe;

architecture arh of write_strobe is
begin
	O<='1' when instr(15 downto 13)="111" else '0';
end architecture arh;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


package reg_package is
type reg_cell is array (15 downto 0) of std_logic_vector(7 downto 0);
end package reg_package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.reg_package.all;

entity register_ent is							 
	port(input: in std_logic_vector(7 downto 0);
	reg_select1: in std_logic_vector(3 downto 0);
	reg_select2: in std_logic_vector(3 downto 0);
	clk: in std_logic;
	reset:in std_logic;
	output1: out std_logic_vector(7 downto 0);
	output2: out std_logic_vector(7 downto 0));
end register_ent;

architecture arh1 of register_ent is	
signal internal_cont: reg_cell;
begin
	process(clk,reset)
	begin			  
		if reset='1' then
			internal_cont<=(others=>"00000000");
		else
			if clk'event and clk='1' then						   
				internal_cont(conv_integer(reg_select1))<=input;
			end if;
		end if;
	end process;
	output1<=internal_cont(conv_integer(reg_select1));
	output2<=internal_cont(conv_integer(reg_select2));
end architecture arh1;

library ieee;
use ieee.std_logic_1164.all;  

entity mem_alu is
	port(in_port:in std_logic_vector(7 downto 0);
	instr:in std_logic_vector(15 downto 0);	
	Cin:in std_logic;
	clk:in std_logic;
	reset:in std_logic;
	zero:out std_logic;
	carry:out std_logic;
	out_port:out std_logic_vector(7 downto 0);
	port_id:out std_logic_vector(7 downto 0));
end mem_alu;

architecture arh of mem_alu is
component register_ent is							 
	port(input: in std_logic_vector(7 downto 0);
	reg_select1: in std_logic_vector(3 downto 0);
	reg_select2: in std_logic_vector(3 downto 0);
	clk: in std_logic;
	reset:in std_logic;
	output1: out std_logic_vector(7 downto 0);
	output2: out std_logic_vector(7 downto 0));
end component;
component ent_ALU is  
	port(A,B,Const: in std_logic_vector(7 downto 0);
	Instr: in std_logic_vector(15 downto 0);
	CIN: in std_logic;
	Y: out std_logic_vector(7 downto 0);
	Zero,Carry: out std_logic);
end component;	 
component MUX2_1 is
	generic(pathwidth: integer);
	port(I0: in std_logic_vector(pathwidth-1 downto 0);
	I1: in std_logic_vector(pathwidth-1 downto 0); 
	S0: in std_logic;
	O: out std_logic_vector(pathwidth-1 downto 0));
end component;
signal A,B,I,Y:std_logic_vector(7 downto 0);
signal Sem:std_logic_vector(3 downto 0);
signal en,S3,S4:std_logic;
begin
	U0:ent_ALU port map(A,B,instr(7 downto 0),instr,Cin,Y,zero,carry);
	U1:MUX2_1
	generic map(pathwidth=>8)
	port map(instr(7 downto 0),B,instr(12),port_id);	 
	en<='1' when instr(15 downto 13)="111" else '0';
	out_port<=A when en='1' else "00000000";			
	U5:MUX2_1
	generic map(pathwidth=>8)
	port map(Y,in_port,S3,I);
	S3<='1' when instr(15 downto 13)="101" else '0';
	U6:MUX2_1
	generic map(pathwidth=>4)
	port map(instr(11 downto 8),instr(7 downto 4),S4,Sem);	
	S4<='0' when (instr(15 downto 13)="100" or instr(15 downto 13)="101" or instr(15 downto 13)="111") else '1';
	U7:register_ent port map(I,instr(11 downto 8),Sem,clk,reset,A,B);
end architecture arh;

library ieee;
use ieee.std_logic_1164.all;

entity flg_store is
	port(reset:in std_logic;
	interrupt:in std_logic;
	inpCarry,inpZero:in std_logic;
	retCarry,retZero:in std_logic;
	instr:in std_logic_vector(15 downto 0);
	clk:in std_logic;
	carry,zero:out std_logic);
end flg_store;

architecture arh of flg_store is 
component MUX2_1 is
	generic(pathwidth: integer);
	port(I0: in std_logic_vector(pathwidth-1 downto 0);
	I1: in std_logic_vector(pathwidth-1 downto 0); 
	S0: in std_logic;
	O: out std_logic_vector(pathwidth-1 downto 0));
end component; 
signal ce, ce1, intC, intZ, sig1, iC, iZ:std_logic;
begin
	process(clk,ce,reset,interrupt)
	begin
		if reset='1' or interrupt='1' then
			intC<='0';
			intZ<='0';
		else
			if interrupt=’1’ then
if clk'event and clk='1' then
					intC<=’0’;
					intZ<=’0’;
				end if;
			elsif ce='1' then
				if clk'event and clk='1' then
					intC<=iC;
					intZ<=iZ;
				end if;
			end if;
		end if;
	end process;
	U0:Mux2_1
	generic map(pathwidth=>1)
	port map(I0(0)=>inpCarry,I1(0)=>retCarry,S0=>sig1,O(0)=>iC);	
	U1:Mux2_1
	generic map(pathwidth=>1)
	port map(I0(0)=>inpZero,I1(0)=>retZero,S0=>sig1,O(0)=>iZ);
	carry<=intC;
	zero<=intZ;		
	sig1<='1' when instr="1000000011110000" or instr="1000000011010000" else '0';
	ce<=ce1 or sig1;
	ce1<='0' when instr(15 downto 13)="100" or instr(15 downto 13)="111" or instr(15 downto 13)="101" or instr(15 downto 12)="0000" or (instr(15 downto 12)="1100" and instr(3 downto 0)="0000") else '1';
end architecture arh;

library ieee;
use ieee.std_logic_1164.all;

entity interrupt_store is
	port(inCarry, inZero:in std_logic;
	clk:in std_logic;
	reset:in std_logic;
	interrupt:in std_logic;
	carry,zero:out std_logic);
end interrupt_store;

architecture arh of interrupt_store is
signal ce, intC, intZ:std_logic;
begin
	process(reset,ce,clk)
	begin
		if reset='1' then
			intC<='0';
			intZ<='0';
		else
			if ce='1' then
				if clk'event and clk='1' then
					intC<=inCarry;
					intZ<=inZero;
				end if;
			end if;
		end if;
	end process;
	carry<=intC;
	zero<=intZ;
	ce<=interrupt;
end architecture arh;

library ieee;
use ieee.std_logic_1164.all;

entity comb is
	port(clk:in std_logic;
	reset:in std_logic;
	interrupt:in std_logic;
	instr:in std_logic_vector(15 downto 0);
	inCarry,inZero:in std_logic;
	carry,zero:out std_logic);		   
end comb; 

architecture arh of comb is
component interrupt_store is
	port(inCarry, inZero:in std_logic;
	clk:in std_logic;
	reset:in std_logic;
	interrupt:in std_logic;
	carry,zero:out std_logic);
end component;
component flg_store is
	port(reset:in std_logic;
	interrupt:in std_logic;
	inpCarry,inpZero:in std_logic;
	retCarry,retZero:in std_logic;
	instr:in std_logic_vector(15 downto 0);
	clk:in std_logic;
	carry,zero:out std_logic);
end component;
signal retCarry, retZero, outCarry, outZero:std_logic;
begin
	U0:flg_store port map(reset,interrupt,inCarry,inZero,retCarry,retZero,instr,clk,outCarry,outZero);
	U1:interrupt_store port map(outCarry,outZero,clk,reset,interrupt,retCarry,retZero);
	carry<=outCarry;
	zero<=outZero;
end architecture arh;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity micro is
	port(in_port:in std_logic_vector(7 downto 0);
	clk:in std_logic;
	interrupt:in std_logic;
	reset:in std_logic;
	port_id:out std_logic_vector(7 downto 0);
	out_port:out std_logic_vector(7 downto 0);
	RS:out std_logic;
	WS:out std_logic);
end micro;

architecture arh of micro is
component mem_alu is
	port(in_port:in std_logic_vector(7 downto 0);
	instr:in std_logic_vector(15 downto 0);	
	Cin:in std_logic;
	clk:in std_logic;
	reset:in std_logic;
	zero:out std_logic;
	carry:out std_logic;
	out_port:out std_logic_vector(7 downto 0);
	port_id:out std_logic_vector(7 downto 0));
end component;
component program_counter is
	port(instr:in std_logic_vector(15 downto 0);
	Carry,Zero:in std_logic;
	reset:in std_logic;
	interrupt:in std_logic;
	clk:in std_logic;
	addr:out std_logic_vector(7 downto 0));
end component;
component clk_div is
	port(clk:in std_logic;
	O0,O1:out std_logic);
end component;
component storage is
	port(instr:in std_logic_vector(15 downto 0);
	clk: in std_logic;
	reset:in std_logic;
	addr:in std_logic_vector(7 downto 0);
	interruptEnable: out std_logic);
end component;
component ROMMemory is 
	port(SEL: in std_logic_vector(7 downto 0); 
	clk:in std_logic;
	Y: out std_logic_vector(15 downto 0));
end component;	 
component read_strobe is
	port(instr:in std_logic_vector(15 downto 0);
	O:out std_logic);
end	component;
component write_strobe is
	port(instr:in std_logic_vector(15 downto 0);
	O:out std_logic);
end component;
component comb is
	port(clk:in std_logic;
	reset:in std_logic;
	interrupt:in std_logic;
	instr:in std_logic_vector(15 downto 0);
	inCarry,inZero:in std_logic;
	carry,zero:out std_logic);		   
end component; 
signal addr:std_logic_vector(7 downto 0);
signal clk1,clk2,C,Z,oZ,oC,interruptEnable,INTinterrupt:std_logic;	 
signal instr:std_logic_vector(15 downto 0);	 
begin
	U0:ROMMemory port map(addr,clk1,instr);
	U1:mem_alu port map(in_port,instr,C,clk1,reset,oZ,oC,out_port,port_id);
	U2:program_counter port map(instr,C,Z,reset,INTinterrupt,clk2,addr);
	U3:clk_div port map(clk,clk1,clk2);
	U4:storage port map(instr,clk1,reset,instr,interruptEnable);
	U5:read_strobe port map(instr,RS);
	U6:write_strobe port map(instr,WS);
	U7:comb port map(clk1,reset,INTinterrupt,instr,oC,oZ,C,Z);
	INTinterrupt<=interruptEnable and interrupt;
end architecture arh;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity DMUXspec2_1 is
	port(I:in std_logic_vector(7 downto 0);
	S:in std_logic;
	O0:out std_logic_vector(7 downto 0);
	O1:out std_logic_vector(7 downto 0));
end DMUXspec2_1;

architecture arh of DMUXspec2_1 is
begin
	process(I,S)
	begin
		if S='0' then
			O0<=I;
			O1<="00000000";
		else
			O0<="00000000";
			O1<=I;
		end if;
	end process;
end architecture arh;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity project is  --The project itself
	port(clk:in std_logic;
	button:in std_logic;
	sw:in std_logic_vector(7 downto 0);
	interrupt:in std_logic;
	reset:in std_logic;
	RS,WS:out std_logic;
	led:out std_logic_vector(7 downto 0);
	an:out std_logic_vector(3 downto 0);
	seg:out std_logic_vector(0 to 6));
end project;

architecture arh of project is
component micro is
	port(in_port:in std_logic_vector(7 downto 0);
	clk:in std_logic;
	interrupt:in std_logic;
	reset:in std_logic;
	port_id:out std_logic_vector(7 downto 0);
	out_port:out std_logic_vector(7 downto 0);
	RS:out std_logic;
	WS:out std_logic);
end component;
component DMUXspec2_1 is
	port(I:in std_logic_vector(7 downto 0);
	S:in std_logic;
	O0:out std_logic_vector(7 downto 0);
	O1:out std_logic_vector(7 downto 0));
end component;
component MUX2_1 is
	generic(pathwidth: integer);
	port(I0: in std_logic_vector(pathwidth-1 downto 0);
	I1: in std_logic_vector(pathwidth-1 downto 0); 
	S0: in std_logic;
	O: out std_logic_vector(pathwidth-1 downto 0));
end component;
component debouncer is
	port(button: in std_logic;
	clk: in std_logic;
	result: out std_logic);
end component;
component led_7_disp is
	port(clk:in std_logic;
	sw:in std_logic_vector(15 downto 0);
	an:out std_logic_vector(3 downto 0);
	seg:out std_logic_vector(0 to 6));
end component;
signal port_id, in_port, out_port, switch: std_logic_vector(7 downto 0);
signal intCLK: std_logic;
begin 
	U0:MUX2_1
	generic map(pathwidth=>8)
	port map(sw,"00001111",port_id(0),in_port);
	U1:debouncer port map(button,clk,intCLK);
	U2:micro port map(in_port,intCLK,interrupt,reset,port_id,out_port,RS,WS);
	U3:DMUXspec2_1 port map(out_port,port_id(0),led,switch);
	U4:led_7_disp port map(clk,sw(7 downto 0)=>switch,sw(15 downto 8)=>"00000000",an=>an,seg=>seg);
end architecture arh; 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity CE is
	port(A,B,C,D,E: in std_logic;
	Y: out std_logic);
end CE;

architecture A of CE is
signal int1: std_logic;
signal int2: std_logic;
begin
	int1<=A and (B nor C);
	int2<=(not D) nand E;
	Y<=int1 and int2;
end architecture A;
