
class driver #(parameter pckg_size, num_msg, drvrs, bits);
  	
  	bit dato[pckg_size-1:0];
	  mailbox agnt_2_drvr_mbx;
  	int number;
  
    virtual bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) vif; //instancia para la interface
    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_2_DUT[drvrs-1:0]; //instancia de la clase de transferencia para guardar el mensaje que se va a enciar al DUT
    
    Fifo #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size) ) fifo[drvrs-1:0];


    function new();
    for ( int p=0; p < drvrs; p++)begin
      fifo[p]=new();
      fifo[p].k = p;
    end
    endfunction
      

    task run();
      //$display("Mensaje en driver:", msg_2_DUT.payload);//se obtiene el mensaje que se envio desde el agente
      $display("Driver correctamente inicializado");
      $display("Mailbox: ",agnt_2_drvr_mbx.num());


      for ( int p=0; p < drvrs; p++)
        begin//se recorren con el numero de dispositivos

          fork
          automatic int i=p;
          fifo[i].run();  
          join_none


          fork 

            automatic int j=p;
            msg_2_DUT[j]=new();

            
            //Actualiza los valors de la fifo
            forever begin
              @(posedge vif.clk)
                if(agnt_2_drvr_mbx.num()>0) begin
                  agnt_2_drvr_mbx.peek(msg_2_DUT[j]);

                  if(msg_2_DUT[j].id_emisor==j) begin
                    agnt_2_drvr_mbx.get(msg_2_DUT[j]);
                    fifo[j].q.push_front(msg_2_DUT[j].message);
                  end
                  
                end
            end


          join_none

      end
      #1000;
      $display("Queue 0: ",fifo[0].q);
      $display("Queue 0 pndng: ",fifo[0].vif.pndng[0]);

      $display("Queue 1: ",fifo[1].q);
      $display("Queue 1 pndng: ",fifo[1].vif.pndng[1];

      $display("Queue 2: ",fifo[2].q);
      $display("Queue 2 pndng: ",fifo[2].vif.pndng[2];

      $display("Queue 3: ",fifo[3].q);
      $display("Queue 3 pndng: ",fifo[3].vif.pndng[3]);
    endtask    
//a
endclass
