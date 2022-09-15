
class driver #(parameter pckg_size, num_msg, drvrs, bits);
  	
	  mailbox agnt_2_drvr_mbx;
  
    virtual bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) vif; //instancia para la interface
    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_2_DUT[drvrs-1:0]; //instancia de la clase de transferencia para guardar el mensaje que se va a enciar al DUT
    
    Fifo #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size) ) fifo[drvrs-1:0];

    function new();
    
    for ( int p=0; p < drvrs; p++)begin//se construyen las fifos
      fifo[p]=new();
      fifo[p].k = p;//se pasa este valor para saber que numero de dispositivo controla cada fifo
    end
    endfunction
      

    task run();
    
      $display("Driver correctamente inicializado");
      @(posedge vif.clk);
      vif.reset= 1;

      for (int i=0; i < drvrs; i++) begin
        fifo[i].vif=vif;//se conecta la interfaz de cada fifo con la interfaz del DUT
        $display("");
        $display("------Driver-----");
        $display("t=%0dns Fifo %0d creada", $time, i);
        $display("");

      end      

      for ( int p=0; p < drvrs; p++)
        begin//se recorren con el numero de dispositivos

          fork
          automatic int w=p;
          fifo[w].run();  //se corre el task run de cada fifo
          join_none


          fork 

            automatic int j=p;
            msg_2_DUT[j]=new();//se crea item de transferencia para obtener el mensaje del mailbox

            
            //Actualiza los valors de la fifo
            forever begin
              @(posedge vif.clk)
              vif.reset= 1'b0;//se pone el reset en 0 


                if(agnt_2_drvr_mbx.num()>0) begin//se revisa si el mailbox tiene algun mensaje 
                  agnt_2_drvr_mbx.peek(msg_2_DUT[j]);//se asigna la primer instruccion del mailbox al objeto de transferencia para poder comparar

                  if(msg_2_DUT[j].id_emisor==j) begin//se revisa si la direccion de emisor que indica la instruccion coincide con el disipositivo en el cual se esta iterando
                    agnt_2_drvr_mbx.get(msg_2_DUT[j]);// si se cumple la condicion saca la instruccion del mailbox
                    fifo[j].q.push_back(msg_2_DUT[j].message);// se hace un push de la palabra a la fifo simulada
                    $display("");
                    $display("------------------------Driver---------------------------");
                    $display("t=%0dns Mensaje ingresado en la fifo de entrada %0d", $time, j);
                    $display("Emisor %d", msg_2_DUT[j].id_emisor);
                    $display("Receptor %d", msg_2_DUT[j].id_dest);
                    $display("Payload %b", msg_2_DUT[j].message);  
                    $display("");

                  end
                  
                end
            //$display("Dato actual de la fifo: %d en el D_pop: %b ", j,vif.D_pop[0][j]);
            //$display("Push del dispositivo %0d %0d: ",j,vif.push[0][j]);
            //$display("pndng del dispositivo %0d %0d: ",j,vif.pndng[0][j]);
            //$display("Reset: %d",vif.reset);

            end


          join_none

      end
    endtask    
//a
endclass
