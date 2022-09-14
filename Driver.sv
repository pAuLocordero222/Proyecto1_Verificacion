
class driver #(parameter pckg_size, num_msg, drvrs, bits);
  	
  	bit dato[pckg_size-1:0];
	  mailbox agnt_2_drvr_mbx;
  	int number;
  
    virtual bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) bus_interface; //instancia para la interface
    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_2_DUT[drvrs-1:0]; //instancia de la clase de transferencia para guardar el mensaje que se va a enciar al DUT
    Fifo #(.pckg_size(pckg_size)) fifo[drvrs-1:0];

    task run();
      //$display("Mensaje en driver:", msg_2_DUT.payload);//se obtiene el mensaje que se envio desde el agente
      $display("Driver correctamente inicializado");

/*
      for ( int i=0; i < drvrs; i++)begin //se resetea el DUT para evitar errores
        bus_interface.pndng[0][i]<=1'b0;
        
        bus_interface.reset<=1'b1;
        
        #1;bus_interface.reset<=1'b0;
        
      end*/

      for ( int p=0; p < drvrs; p++)
        begin//se recorren con el numero de dispositivos
          fork 
            automatic int j=p;
            msg_2_DUT[j]=new();
            fifo[j]=new();
            
            //Actualiza los valors de la fifo
            forever begin
              @(posedge bus_interface.clk)
                if(agnt_2_drvr_mbx.num()>0) begin
                  agnt_2_drvr_mbx.peek(msg_2_DUT[j]);

                  if(msg_2_DUT[j].id_emisor==j) begin
                    agnt_2_drvr_mbx.get(msg_2_DUT[j]);
                    fifo[j].q.push_front(msg_2_DUT[j].message);
                  end
                  
                end
            end
            forever begin//
              @(posedge bus_interface.clk)
              agnt_2_drvr_mbx.peek(msg_2_DUT[j]);//Se obtiene la instruccion que viene desde el agente y se asigna a una variable trans_BUS
              if (msg_2_DUT[j].id_emisor==j)begin//se revisa si la instruccion tiene como emisor el dispositijo j
                agnt_2_drvr_mbx.get(msg_2_DUT[j]);//Si se cumple la condicion se saca el mensaje del bus
              end
                  //Aca se tiene que agregar el dato a la fifo emulada
                  //Aca se saca el dato de la fifo emulada
                $display("----------Driver---------");
                $display("t=%0t Se envia mensaje desde el dispositivo [%0d]",$time ,msg_2_DUT[j].id_emisor);           
              	$display("dispositivo destino: %d",msg_2_DUT[j].id_dest);
              	$display("payload: %b",msg_2_DUT[j].payload);
              	$display("Mensaje completo a enviar: %b",msg_2_DUT[j].message);



              		#1bus_interface.D_pop[0][j]=msg_2_DUT[j].message;
              		$display("Dato en DUT: ",bus_interface.D_pop[0][j]);
              		#1bus_interface.pndng[0][j]<=1'b1;
              		

		if (bus_interface.pop[0][j])begin

			bus_interface.pndng[0][j]<=1'b0;
		end			
              			


            end 

          join_none

      end
      #1000;
      $display("Queue 0: ",fifo[0].q);
      $display("Queue 1: ",fifo[1].q);
      $display("Queue 2: ",fifo[2].q);
      $display("Queue 3: ",fifo[3].q);
    endtask    
//a
endclass
