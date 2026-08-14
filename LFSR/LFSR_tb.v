`timescale 1ns/1ps

module  LFSR2_tb ;

/////////////////////////////////////////////////////////
///////////////////// Parameters ////////////////////////
/////////////////////////////////////////////////////////

parameter LFSR_WD_tb = 8 ;
parameter Clock_PERIOD = 10 ;
parameter Test_Cases = 5 ;


/////////////////////////////////////////////////////////
//////////////////// DUT Signals ////////////////////////
/////////////////////////////////////////////////////////


reg      [LFSR_WD_tb-1:0]     Seed_tb;
reg                           Clock_tb;
reg                           Reset_tb;
reg                           Enable_tb;
reg                           OUT_Enable_tb;
wire                          OUT_tb;
wire                          Valid_tb;

/////////////////////////////////////////////////////////
///////////////// Loops Variables ///////////////////////
/////////////////////////////////////////////////////////

integer                       Operation ;

/////////////////////////////////////////////////////////
/////////////////////// Memories ////////////////////////
/////////////////////////////////////////////////////////

reg    [LFSR_WD_tb-1:0]   Test_Seeds   [Test_Cases-1:0] ;
reg    [LFSR_WD_tb-1:0]   Expec_Outs   [Test_Cases-1:0] ;

////////////////////////////////////////////////////////
////////////////// initial block /////////////////////// 
////////////////////////////////////////////////////////

initial 
 begin
 
 // System Functions
 $dumpfile("LFSR_DUMP.vcd") ;       
 $dumpvars; 
 
 // Read Input Files
 $readmemb("Seeds_b.txt", Test_Seeds);
 $readmemb("Expec_Out_b.txt", Expec_Outs);

 // initialization
 initialize() ;

 // Test Cases
 for (Operation=0;Operation<Test_Cases;Operation=Operation+1)
  begin
   do_oper(Test_Seeds[Operation]) ;                       // do_lfsr_operation
   check_out(Expec_Outs[Operation],Operation) ;           // check output response
  end

 #100
 $finish ;

 end




////////////////////////////////////////////////////////
/////////////////////// TASKS //////////////////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////

task initialize ;
 begin
  Seed_tb = 'b10010011;
  Clock_tb  = 'b0;
  Reset_tb  = 'b0;
  Enable_tb = 'b0;  
  OUT_Enable_tb = 'b0;  
 end
endtask

///////////////////////// RESET /////////////////////////

task reset ;
 begin
  Reset_tb =  'b1;
  #(Clock_PERIOD)
  Reset_tb  = 'b0;
  #(Clock_PERIOD)
  Reset_tb  = 'b1;
 end
endtask

////////////////// Do LFSR Operation ////////////////////

task do_oper ;
 input  [LFSR_WD_tb-1:0]     IN_Seed ;

 begin
   Seed_tb = IN_Seed ;
   reset () ;
   #(Clock_PERIOD)
   Enable_tb = 1'b1;
   #(10*Clock_PERIOD)
   Enable_tb = 1'b0;   
 end
endtask

////////////////// Check Out Response  ////////////////////

task check_out ;
 input  reg     [LFSR_WD_tb-1:0]     expec_out ;
 input  integer                      Oper_Num ; 

 integer i ;
 
 reg    [LFSR_WD_tb-1:0]     gener_out ;

 begin
  Enable_tb = 1'b0;  
  #(Clock_PERIOD)
  OUT_Enable_tb = 1'b1;
  @(posedge Valid_tb)
  for(i=0; i<8; i=i+1)
   begin
    #(Clock_PERIOD) gener_out[i] = OUT_tb ;
   end
   if(gener_out == expec_out) 
    begin
     $display("Test Case %d is succeeded",Oper_Num);
    end
   else
    begin
     $display("Test Case %d is failed", Oper_Num);
    end
   OUT_Enable_tb = 1'b0;
 end
endtask


////////////////////////////////////////////////////////
////////////////// Clock Generator  ////////////////////
////////////////////////////////////////////////////////

always #(Clock_PERIOD/2)  Clock_tb = ~Clock_tb ;


////////////////////////////////////////////////////////
/////////////////// DUT Instantation ///////////////////
////////////////////////////////////////////////////////

LFSR DUT
(
.Seed(Seed_tb),
.Clock(Clock_tb),
.Reset(Reset_tb),
.Enable(Enable_tb),
.OUT_Enable(OUT_Enable_tb),
.OUT(OUT_tb),
.Valid(Valid_tb)
);





endmodule
