//1338
module FSM(		RST,				CLK, 				READY,			SET,				B1, 				B2, 				B3, 				B4,					L1, 				L2, 				L3,  				L4,	 				DISP1,			DISP2,			DISP3,			DISP4,			RND, 				SCORE,			DISP_SU,		DISP_SD,		DISP_SC,		DISP_SM,		C_S				);
 	
  input RST; 						input CLK;  					input B1;   					input B2;   					input B3;   					input B4;							input READY;				input [1:0] RND;			input [6:0] DISP_SU; 		input [6:0] DISP_SD; 		input [6:0] DISP_SC; 		input [6:0] DISP_SM; 		output reg L1;  					output reg L2;  					output reg L3;  					output reg L4; 						output reg [1:0] SET; 		output reg [6:0] DISP1;  	output reg [6:0] DISP2;  	output reg [6:0] DISP3;  	output reg [6:0] DISP4;		output reg [11:0] SCORE;			output reg [5:0] C_S;

 	reg MOD;							reg VEL;							reg P;								reg [1:0] COR;				reg [5:0] N_S;				reg [5:0] TMAX;				reg [4:0] pA;					reg [4:0] pT;					reg [4:0] pAux;				reg [1:0] SEQ[31:0];	reg pulse;					reg [11:0] SCORE_nxt;				reg [4:0] pA_nxt;					reg [4:0] pT_nxt;					reg P_nxt;							parameter Estado_Inicial=6'b000000,
						SoltaI=6'b000001,
	 					Modo1=6'b000010,
						SoltaM1=6'b000011,
 						Modo2=6'b000100,
						SoltaM2=6'b000101,
						SoltaM=6'b100010,
 						Dificuldade1=6'b000110,
						SoltaD1=6'b000111,
	 					Dificuldade2=6'b001000,
						SoltaD2=6'b001001,
 						Dificuldade3=6'b001010,
						SoltaD3=6'b001011,
						SoltaD=6'b100011,
						Velocidade1=6'b001100,
						SoltaV1=6'b001101,
						Velocidade2=6'b001110,
						SoltaV2=6'b001111,
						SoltaV=6'b100100,
 						Gera_Cor=6'b010000,
						SoltaG=6'b010001,
 						Acende=6'b010010,
 						Apaga=6'b010011,
 						Input=6'b010100,
 						Apaga2=6'b010101,
 						Compara=6'b010110,
 						Muda_Player=6'b010111,
 						Deathmatch=6'b011000,
	 					AcendeD=6'b011001,
 						ApagaD=6'b011010,
 						InputD=6'b011011,
 						ApagaD2=6'b011100,
 						ComparaD=6'b011101,
 						ComparaD2=6'b011110,
	 					Fim=6'b011111,
 						Resultados=6'b100000,
 						Aguarda_Input=6'b100001;
  
  parameter	Verde=2'b00,
  					Vermelho=2'b01,
  					Azul=2'b10,
  					Amarelo=2'b11;
 
	always@(*) begin
    N_S=N_S;
	 if(RST == 1) 		N_S=Estado_Inicial;
	else if(pulse < 2) begin
	  case(C_S)
  	  Estado_Inicial:	begin 
      	if(B2==0)
      		N_S=SoltaI;
      end
		
		SoltaI:	begin
			if(B2==1 && B1==1)
				N_S=Modo1;
		end
		
      Modo1: begin 
        if(READY==1)
          N_S=Estado_Inicial;
        else if(B1==0)
       		N_S=SoltaM1;
       	else if(B2==0)
         	N_S=SoltaM;
      end
		
		SoltaM1:	begin
			if(B2==1 && B1==1)
				N_S=Modo2;
		end
		
      Modo2: begin 
        if(READY==1)
          N_S=Estado_Inicial;
        else if(B1==0)
        	N_S=SoltaM2;
        else if(B2==0)
          N_S=SoltaM;
      end
		
		SoltaM2:	begin
			if(B2==1 && B1==1)
				N_S=Modo1;
		end
		
		SoltaM:	begin
			if(B2==1 && B1==1)
				N_S=Dificuldade1;
		end
		
	  	Dificuldade1: begin 
        if(READY==1)
          N_S=Estado_Inicial;
        else if(B1==0)
	        N_S=SoltaD1;
        else if(B2==0)
          N_S=SoltaD;
      end
		
		SoltaD1:	begin
			if(B2==1 && B1==1)
				N_S=Dificuldade2;
		end
		
      Dificuldade2: begin
        if(READY==1)
          N_S=Estado_Inicial;
        else if(B1==0)
       	  N_S=SoltaD2;
        else if(B2==0)
          N_S=SoltaD;
      end
		
		SoltaD2:	begin
			if(B2==1 && B1==1)
				N_S=Dificuldade3;
		end
		
      Dificuldade3: begin 
        if(READY==1)
          N_S=Estado_Inicial;
        else if(B1==0)
          N_S=SoltaD3;
        else if(B2==0)
          N_S=SoltaD;
      end  
		
		SoltaD3:	begin
			if(B2==1 && B1==1)
				N_S=Dificuldade1;
		end
		
		SoltaD:	begin
			if(B2==1 && B1==1)
				N_S=Velocidade1;
		end
		
    	Velocidade1: begin 
        if(READY==1)
          N_S=Estado_Inicial;
        else if(B1==0)
      	  N_S=SoltaV1;
     		else if(B2==0)
          N_S=SoltaV;
      end
		
		SoltaV1:	begin
			if(B2==1 && B1==1)
				N_S=Velocidade2;
		end
		
      Velocidade2: begin 
        if(READY==1)
          N_S=Estado_Inicial;
        else if(B1==0)
        	N_S=SoltaV2;
        else if(B2==0)
         	N_S=SoltaV;
      end
		
		SoltaV2:	begin
			if(B2==1 && B1==1)
				N_S=Velocidade1;
		end
		
		SoltaV:	begin
			if(B2==1 && B1==1 && B3==1 && B4==1)
				N_S=Gera_Cor;
		end
		
		  Gera_Cor: begin 
        if(READY==1)
          N_S=Estado_Inicial;
        else if(MOD==0)
          N_S=Acende;
        else if(B1==0 && B2==1 && B3==1 && B4==1)
          N_S=SoltaG;
        else if(B2==0 && B1==1 && B3==1 && B4==1)
          N_S=SoltaG;
        else if(B3==0 && B1==1 && B2==1 && B4==1)
          N_S=SoltaG;
        else if(B4==0 && B1==1 && B3==1 && B2==1)
          N_S=SoltaG;
      end
		SoltaG:	begin
			if(B2==1 && B1==1 && B3 == 1 && B4 == 1 && READY == 1)
				N_S=Acende;
		end
      Acende: begin 
        if(pA>pT)
        	N_S=Input;
        else if(READY)
          N_S=Apaga;
      end
      Apaga: begin 
        if(READY==1)
          N_S=Acende;
      end
	  	Input: begin 
        if(READY==1 && MOD==0)
          N_S=Fim;
        else if(READY==1 && MOD==1)
          N_S=Deathmatch;
        else if(B1==0 && B2==1 && B3==1 && B4==1)
          N_S=Apaga2;
        else if(B2==0 && B1==1 && B3==1 && B4==1)
          N_S=Apaga2;
        else if(B3==0 && B2==1 && B1==1 && B4==1)
          N_S=Apaga2;
        else if(B4==0 && B2==1 && B3==1 && B1==1)
          N_S=Apaga2;
      end
      Apaga2: begin 
        if(READY==1 && MOD==0)
          N_S=Fim;
        else if(READY==1 && MOD==1)
          N_S=Deathmatch;
        else if(B1==1 && B2==1 && B3==1 && B4==1)
          N_S=Compara;
      end
      Compara: begin 
        if(pA>0 && COR==SEQ[pT-pA])
          N_S=Input;
        else if(pA==0 && pT<TMAX-1 && COR==SEQ[pT-pA])
          N_S=Muda_Player;
        else if(COR!=SEQ[pT-pA] && MOD==0)
          N_S=Fim;
        else if(COR==SEQ[pT-pA] && pA==0 && pT==TMAX-1)
          N_S=Fim;
        else if(COR!=SEQ[pT-pA] && MOD==1)
          N_S=Deathmatch;
      end
      Muda_Player: begin 
        if(MOD==0)
          N_S=Gera_Cor;
        else if(READY==1)
          N_S=Gera_Cor;
      end
	  	Deathmatch: begin 
        if(READY==1)
          N_S=AcendeD;
      end
      AcendeD: begin 
        if(pA>pT)
          N_S=InputD;
        else if(READY==1)
          N_S=ApagaD;
      end
      ApagaD: begin 
        if(READY==1)
          N_S=AcendeD;
      end
      InputD: begin 
        if(READY==1)
          N_S=ComparaD2;
        else if(B1==0 && B2==1 && B3==1 && B4==1)
          N_S=ApagaD2;
        else if(B2==0 && B1==1 && B3==1 && B4==1)
          N_S=ApagaD2;
        else if(B3==0 && B2==1 && B1==1 && B4==1)
          N_S=ApagaD2;
        else if(B4==0 && B2==1 && B3==1 && B1==1)
          N_S=ApagaD2;
      end
      ApagaD2: begin 
        if(READY==1)
          N_S=ComparaD2;
        else if(B1==1 && B2==1 && B3==1 && B4==1)
          N_S=ComparaD;
      end
      ComparaD: begin 
        if(COR!=SEQ[pT-pA])
          N_S=ComparaD2;
        else if(pA==0)
          N_S=ComparaD2;
        else if(pA>0)
          N_S=InputD;
      end
      ComparaD2: begin 
        if(pA>pAux && P==1 && READY==1)
          N_S=Fim;
        else if(pA>pAux && P==0 && READY==1)
          N_S=Fim;
        else if(pA<pAux && P==1 && READY==1)
          N_S=Fim;
        else if(pA<pAux && P==0 && READY==1)
          N_S=Fim;
        else if(pA==pAux && READY==1)
          N_S=Fim;
      end
	  	Fim: begin 
        if(READY==1)
          N_S=Resultados;
      end
      Resultados: begin 
        if(B1==0 || B2==0 || B3==0 || B4==0)
          N_S=Aguarda_Input;
      end
      Aguarda_Input: begin 
        if(B1==1 && B2==1 && B3==1 && B4==1)
          N_S=Estado_Inicial;
      end
      default: N_S=Estado_Inicial;
    endcase
	 end
	end

	
	always@(*) begin
  if(pulse < 2) begin
	L1=L1;
	L2=L2;
	L3=L3;
	L4=L4;
   SET=SET;
  DISP1=DISP1;
  DISP2=DISP2;
  DISP3=DISP3;
  DISP4=DISP4;

    case(C_S)
      Estado_Inicial:	begin
			pA_nxt=0;
			pT_nxt=0;
			P_nxt=0;
			pAux=0;
			SCORE_nxt=0;
			L1=0;
			L2=0;
			L3=0;
			L4=0;
			SET=0;
			DISP1=~0;
			DISP2=~0;
			DISP3=~0;
			DISP4=~0;
        if(B2==0) begin
				DISP1=~7'b1110110;	DISP2=~7'b0011101;	DISP3=~7'b0111101;	DISP4=~7'b0110000;	SET=2'b00;
			end
      end
      Modo1: begin 
			if(READY==1) begin
				DISP1=~7'b0000000;
				DISP2=~7'b0000000;
				DISP3=~7'b0000000;
				DISP4=~7'b0000000;
				SET=2'b00;
			end
			else if(B1==0) begin
				DISP1=~7'b1110110;	DISP2=~7'b0011101;	DISP3=~7'b0111101;	DISP4=~7'b1101101;	SET=2'b00; 					
        end  
        else if(B2==0)begin
				MOD=0;		DISP1=~7'b0111101;	DISP2=~7'b0010000;	DISP3=~7'b1000111;	DISP4=~7'b0110000;	SET=2'b00;
        end
		  else
          SET=2'b11;
      end
      Modo2: begin 
			if(READY==1) begin
				DISP1=~0;
				DISP2=~0;
				DISP3=~0;
				DISP4=~0;
				SET=2'b00;
			end
			else if(B1==0) begin
				DISP1=~7'b1110110;	DISP2=~7'b0011101;	DISP3=~7'b0111101;	DISP4=~7'b0110000;	SET=2'b00; 					
        end
        else if(B2==0) begin
          MOD=1; 	DISP1=~7'b0111101;	DISP2=~7'b0010000;	DISP3=~7'b1000111;	DISP4=~7'b0110000;	SET=2'b00;
        end
		  else
          SET=2'b11;
      end
    	Dificuldade1: begin 
		 if(READY==1) begin
          DISP1=~0;
          DISP2=~0;
          DISP3=~0;
          DISP4=~0;
          SET=2'b00;
        end
		  else if(B1==0) begin
	       DISP1=~7'b0111101;	DISP2=~7'b0010000;		DISP3=~7'b1000111;		DISP4=~7'b1101101;	SET=2'b00;						
        end
        else if(B2==0) begin
          TMAX=8;
			 DISP1=~7'b0111110;	DISP2=~7'b1001111;	DISP3=~7'b0001110;	DISP4=~7'b0110000;	SET=2'b00;
        end
		  else
          SET=2'b11;
      end
      Dificuldade2: begin
			if(READY==1) begin
          DISP1=~0;
          DISP2=~0;
          DISP3=~0;
          DISP4=~0;
          SET=2'b00;
        end
		  else if(B1==0)	begin
       	 DISP1=~7'b0111101;	DISP2=~7'b0010000;		DISP3=~7'b1000111;		DISP4=~7'b1111001;	SET=2'b00;			
        end
        else if(B2==0) begin
        	TMAX=16;
			DISP1=~7'b0111110;		DISP2=~7'b1001111;	DISP3=~7'b0001110;	DISP4=~7'b0110000;	SET=2'b00;			
        end
		  else
          SET=2'b11;
      end
      Dificuldade3: begin 
			if(READY==1) begin
          DISP1=~0;
          DISP2=~0;
          DISP3=~0;
          DISP4=~0;
          SET=2'b00;
        end	
		  else if(B1==0) begin
          DISP1=~7'b0111101;	DISP2=~7'b0010000;		DISP3=~7'b1000111;		DISP4=~7'b0110000;	SET=2'b00;						
        end
        else if(B2==0) begin
        	TMAX=32;		
			DISP1=~7'b0111110;		DISP2=~7'b1001111;	DISP3=~7'b0001110;	DISP4=~7'b0110000;	SET=2'b00;
        end
		  else 
          SET=2'b11;
      end  
      Velocidade1: begin 
			if(READY==1) begin
          DISP1=~0;
          DISP2=~0;
          DISP3=~0;
          DISP4=~0;
          SET=2'b00;
        end
		  else if(B1==0)begin
        	DISP1=~7'b0111110;	DISP2=~7'b1001111;	DISP3=~7'b0001110;	DISP4=~7'b1101101;	SET=2'b00;						
        end
        else if(B2==0 && MOD==0) begin
          VEL=0;
          DISP1=~DISP_SM;
          DISP2=~DISP_SC;
          DISP3=~DISP_SD;
          DISP4=~DISP_SU;
			 SET=0;
        end
		  else if(B2==0 && MOD==1) begin
          VEL=0;
          DISP1=~7'b0000000; 	DISP2=~7'b0000000;	DISP3=~7'b1100111;	DISP4=~7'b0110000;	SET=0;
        end
		  else
          SET=2'b11;
      end
		
      Velocidade2: begin 
			if(READY==1) begin
          DISP1=~0;
          DISP2=~0;
          DISP3=~0;
          DISP4=~0;
          SET=2'b00;
        end
		  else if(B1==0) begin
          SET=0;
			DISP1=~7'b0111110;	DISP2=~7'b1001111;	DISP3=~7'b0001110;	DISP4=~7'b0110000;	end
        else if(B2==0 && MOD==0) begin
          VEL=1;
          DISP1=~DISP_SM;
          DISP2=~DISP_SC;
          DISP3=~DISP_SD;
          DISP4=~DISP_SU;
			 SET=0;
        end
		  else if(B2==0 && MOD==1) begin
          VEL=1;
          DISP1=~7'b0000000; 	DISP2=~7'b0000000;	DISP3=~7'b1100111;	DISP4=~7'b0110000;	SET=0;
        end
		  else
          SET=2'b11;
      end
	   Gera_Cor: begin 
			if(READY==1) begin
          DISP1=~0;
          DISP2=~0;
          DISP3=~0;
          DISP4=~0;
          SET=2'b00;
        end
        else if(MOD==0) begin
          SEQ[pT]=RND;
			 SET=0;
        end
        else if(MOD==1) begin
          if(B1==0 && B2==1 && B3==1 && B4==1) begin
            COR=2'b00;
            SEQ[pT]=2'b00;
				SET=0;
				P_nxt=~P;
          end
          else if(B2==0 && B1==1 && B3==1 && B4==1) begin
            COR=2'b01;
            SEQ[pT]=2'b01;
				SET=0;
				P_nxt=~P;
          end 
          else if(B3==0 && B1==1 && B2==1 && B4==1) begin
            COR=2'b10;
            SEQ[pT]=2'b10;
				SET=0;
				P_nxt=~P;
          end 
          else if(B4==0 && B1==1 && B2==1 && B3==1) begin
            COR=2'b11;
            SEQ[pT]=2'b11;
				SET=0;
				P_nxt=~P;
          end
			else
          SET=2'b11; 
        end
      end
		SoltaG: begin
			if(B2==1 && B1==1 && B3 == 1 && B4 == 1 && READY == 1) begin
				if(P==0) begin
					DISP1=~7'b0000000; 	DISP2=~7'b0000000;	DISP3=~7'b1100111;	DISP4=~7'b0110000;	SET=2'b00;
				end
				else begin
					DISP1=~7'b0000000; 	DISP2=~7'b0000000;	DISP3=~7'b1100111;	DISP4=~7'b1101101;	SET=2'b00;
				end
			end
			else
				SET=2'b10;
		end
      Acende: begin 
        if(pA<=pT) begin
          if(READY==1) begin
				SET=0;
				case(SEQ[pA])
              Verde: begin
						L1=1;
						L2=0;
						L3=0;
						L4=0;
					end
              Vermelho: begin
						L1=0;
						L2=1;
						L3=0;
						L4=0;
					end
              Azul: begin
						L1=0;
						L2=0;
						L3=1;
						L4=0;
					end
              Amarelo: begin
						L1=0;
						L2=0;
						L3=0;
						L4=1;
					end
				endcase
            COR=SEQ[pA];
          end
			 else
				SET=2-VEL;
		  end
        else if(pA>pT) begin
				 SET=2'b00;
        end
      end
		Apaga: begin 
        if(READY==1) begin
          SET=0;
          L1=0;
          L2=0;
          L3=0;
          L4=0;
			 pA_nxt=pA+1;
        end
        else
          SET=1;
      end
	   	Input: begin 
        if(READY==1) begin
				L1=1;
            L2=1;
            L3=1;
            L4=1;
            SET=2'b00;
          if(MOD==1) begin
				DISP1=~7'b1001111;	DISP2=~7'b0000101;	DISP3=~7'b0000101;	DISP4=~7'b0011101;	P_nxt=~P;
            pAux=pA-1;
          end
			 else if(MOD==0) begin
				DISP1=~7'b1100111;	DISP2=~7'b1001111;	DISP3=~7'b0000101;	DISP4=~7'b0111101;	end
        end
        else if(B1==0 && B2==1 && B3==1 && B4==1) begin
          COR=2'b00;
			 L1=1;
          SET=0;
			 pA_nxt=pA-1;
        end
        else if(B2==0 && B1==1 && B3==1 && B4==1) begin
          COR=2'b01;
			 L2=1;
          SET=0;
			 pA_nxt=pA-1;
        end
        else if(B3==0 && B1==1 && B2==1 && B4==1) begin
          COR=2'b10;
			 L3=1;
          SET=0;
			 pA_nxt=pA-1;
        end
        else if(B4==0 && B1==1 && B2==1 && B3==1) begin
          COR=2'b11;
			 L4=1;
          SET=0;
			 pA_nxt=pA-1;
        end
		  else begin
          SET=2-VEL;
			 DISP1=~DISP_SM;
          DISP2=~DISP_SC;
        	 DISP3=~DISP_SD;
        	 DISP4=~DISP_SU;
		  end
      end
      Apaga2: begin 
        if(READY==1) begin
				L1=1;
            L2=1;
            L3=1;
            L4=1;
            SET=2'b00;
			if(MOD==0) begin
          	DISP1=~7'b1100111;	DISP2=~7'b1001111;	DISP3=~7'b0000101;	DISP4=~7'b0111101;	end
          else if(MOD==1) begin
				DISP1=~7'b1001111;	DISP2=~7'b0000101;	DISP3=~7'b0000101;	DISP4=~7'b0011101;	P_nxt=~P;
            pAux=pA;
          end
        end
		  else if(B1==1 && B2==1 && B3==1 && B4==1) begin
          SET=2'b00;
          L1=0;
          L2=0;
          L3=0;
          L4=0;
        end
        else
          SET=2-VEL;
      end
      Compara: begin 
        if(COR==SEQ[pT-pA])begin
          if(pA>0) begin
            SET=0;
            SCORE_nxt=SCORE + TMAX/8 + VEL +1;
          end
          else if(pA==0) begin
            if(pT<TMAX-1) begin
              SET=2'b00;
              pT_nxt=pT+1;
              SCORE_nxt=SCORE+TMAX/8+VEL+1;
            end
            else if(pT==TMAX-1) begin
              SCORE_nxt=SCORE+TMAX/8+VEL+1;
				   DISP1=~7'b1011111;	DISP2=~7'b1110111;DISP3=~7'b0010101;DISP4=~7'b0010111;L1=1;							L2=1;							L3=1;							L4=1;							SET=2'b00;
            end
          end
        end
        else if(COR!=SEQ[pT-pA]) begin			if(MOD==0) begin							DISP1=~7'b1100111;	DISP2=~7'b1001111;	DISP3=~7'b0000101;	DISP4=~7'b0111101;	L1=1;							L2=1;							L3=1;							L4=1;							SET=2'b00;            
          end
          else if(MOD==1) begin		P_nxt=~P;							
            pAux=pA;
				DISP1=~7'b1001111;	DISP2=~7'b0000101;	DISP3=~7'b0000101;	DISP4=~7'b0011101;	L1=1;							L2=1;							L3=1;							L4=1;							SET=2'b00;
          end
        end
      end
      Muda_Player: begin 
		  if(MOD==0) begin
          SET=0;
			 DISP1=~DISP_SM;
			 DISP2=~DISP_SC;
			 DISP3=~DISP_SD;
			 DISP4=~DISP_SU;
        end
        else if(READY==1) begin
			 SET=0;
        end
		  else 
			 DISP1=~7'b0010101; 	DISP2=~7'b1001110;	DISP3=~7'b0011101;	DISP4=~7'b0000101;	SET=2'b10;
      end
	   	Deathmatch: begin 
        if(READY==1) begin
          SCORE_nxt=SCORE-(pT - pA)*(TMAX/8 + VEL + 1);
          L1=0;	L2=0;	L3=0;	L4=0;	SET=2'b00;
			 pA_nxt=0;
			 if(P==0) begin
				DISP1=~7'b0000000; 	DISP2=~7'b0000000;	DISP3=~7'b1100111;	DISP4=~7'b0110000;	end
			 else begin
				DISP1=~7'b0000000; 	DISP2=~7'b0000000;	DISP3=~7'b1100111;	DISP4=~7'b1101101;	end
        end
		 else 
			SET = 2'b10;
      end
      AcendeD: begin 
        if(pA>pT) begin
			 SET=2'b00;
        end
        else if(READY==1) begin
          COR=SEQ[pA];
			 SET=2'b00;
          case(SEQ[pA])
            Verde: 		L1=1;
            Vermelho: L2=1;
            Azul: 		L3=1;
            Amarelo: 	L4=1;
			 endcase 
        end
		  else
          SET=2-VEL;
      end
		ApagaD: begin 
        if(READY==1) begin
          SET=2'b00;
          L1=0;
          L2=0;
          L3=0;
          L4=0;
			 pA_nxt=pA+1;
        end
        else
          SET=2'b01;
      end
      InputD: begin
			if(READY==1) begin
				DISP1=~7'b1001111;	DISP2=~7'b0000101;	DISP3=~7'b0000101;	DISP4=~7'b0011101;	L1=1;							L2=1;							L3=1;							L4=1;							SET=2'b00;
        end
        else if(B1==0 && B2==1 && B3==1 && B4==1) begin		COR=Verde;
			 L1=1;
          SET=2'b00;
			 pA_nxt=pA-1;
        end
        else if(B2==0 && B1==1 && B3==1 && B4==1) begin
          COR=Vermelho;
			 L2=1;
          SET=2'b00;
			 pA_nxt=pA-1;
        end
        else if(B3==0 && B2==1 && B1==1 && B4==1) begin
          COR=Azul;
			 L3=1;
          SET=2'b00;
			 pA_nxt=pA-1;
        end
        else if(B4==0 && B2==1 && B3==1 && B1==1) begin
          COR=Amarelo;
			 L4=1;
          SET=2'b00;
			 pA_nxt=pA-1;
        end
		  else begin
          SET=2-VEL;  
			 DISP1=~DISP_SM;
          DISP2=~DISP_SC;
        	 DISP3=~DISP_SD;
        	 DISP4=~DISP_SU;
		  end
      end
		ApagaD2: begin 
        if(READY==1) begin
          DISP1=~7'b1001111;	DISP2=~7'b0000101;	DISP3=~7'b0000101;	DISP4=~7'b0011101;	L1=1;							L2=1;							L3=1;							L4=1;							SET=2'b00;
        end
        else if(B1==1 && B2==1 && B3==1 && B4==1) begin
          L1=0;
          L2=0;
          L3=0;
          L4=0;
          SET=2'b00;
        end
        else
          SET=2-VEL;
    	end
      ComparaD: begin 
			if(COR!=SEQ[pT-pA]) begin
				DISP1=~7'b1001111;	DISP2=~7'b0000101;	DISP3=~7'b0000101;	DISP4=~7'b0011101;	L1=1;							L2=1;							L3=1;							L4=1;							SET=2'b00;
        end
        else if(pA>0) begin
          SCORE_nxt=SCORE + TMAX/8 + VEL + 1;
          SET=2'b00;
        end
        else if(pA==0) begin
          SCORE_nxt=SCORE+TMAX/8+VEL+1;
			 DISP1=~7'b1011111;  DISP2=~7'b1110111;  DISP3=~7'b0010101;  DISP4=~7'b0010111;  L1=1;					L2=1;					L3=1;					L4=1;					SET=2'b00;
        end
      end
      ComparaD2: begin 
        if(READY==1) begin
			 SET=2'b00;
          if(pA>pAux) begin
            SCORE_nxt=SCORE - (pT - pAux)*(TMAX/8 + VEL + 1);
				if(P==1) begin
	          	DISP1=~7'b1100111;	DISP2=~7'b0110000;	DISP3=~7'b1011111;	DISP4=~7'b1110111;	end
            else if(P==0) begin
	          	DISP1=~7'b1100111;	DISP2=~7'b1101101;	DISP3=~7'b1011111;	DISP4=~7'b1110111;	end
          end
			 else if(pA<pAux) begin
            if(P==1) begin
	          	DISP1=~7'b1100111;	DISP2=~7'b1101101;	DISP3=~7'b1011111;	DISP4=~7'b1110111;	end
            else if(P==0) begin
	          	DISP1=~7'b1100111;	DISP2=~7'b0110000;	DISP3=~7'b1011111;	DISP4=~7'b1110111;	end
          end
          else if(pA==pAux) begin
					DISP1=~7'b1001111;	DISP2=~7'b1110110;	DISP3=~7'b1100111;	DISP4=~7'b1110111;	end
        end
        else
          SET=2'b10;
      end
		Fim: begin 
        if(READY==1) begin
         	DISP1=~DISP_SM;
         	DISP2=~DISP_SC;
          DISP3=~DISP_SD;
          DISP4=~DISP_SU;
          SET=2'b00;
        end
        else
          SET=2'b10;
      end
      Resultados: begin 
        if(READY==1) begin
          DISP1=~0;
          DISP2=~0;
          DISP3=~0;
          DISP4=~0;
          L1=0;
          L2=0;
          L3=0;
          L4=0;
          SET=2'b00;
        end
        else if(B1==0 || B2==0 || B3==0 || B4==0) begin
         	DISP1=~DISP_SM;
         	DISP2=~DISP_SC;
          DISP3=~DISP_SD;
          DISP4=~DISP_SU;
          L1=0;
          L2=0;
          L3=0;
          L4=0;
          SET=2'b00;
        end
        else
          SET=2'b11;
      end
      Aguarda_Input: begin 
        if(B1==1) begin
          if(B2==1) begin
            if(B3==1) begin
              if(B4==1) begin
                    DISP1=~7'b0000000;	DISP2=~7'b0000000;	DISP3=~7'b0000000;	DISP4=~7'b0000000;	end
            end
          end
		  	end
      end
    endcase
  end
  end 

 
  always@(posedge CLK) begin
 		if(RST==1) begin
 			C_S<=Estado_Inicial;
			pulse<=0;
			pA<=0;
			pT<=0;
			SCORE<=0;
			P<=0;
		end
		else begin
			C_S<=N_S;
			pulse<=~pulse;
			pA<=pA_nxt;
			pT<=pT_nxt;
			SCORE<=SCORE_nxt;
			P<=P_nxt;
      end
  end
endmodule