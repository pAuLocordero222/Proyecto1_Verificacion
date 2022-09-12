
class driver #(parameter pckg_size, num_msg, drvrs, bits);
  	
  	bit dato[pckg_size-1:0];
	mailbox agnt_2_drvr_mbx;
  
    virtual bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) bus_interface; //instancia para la interface
  	trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_2_DUT; //instancia de la clase de transferencia para guardar el mensaje que se va a enciar al DUT
  
    task run();
      //$display("Mensaje en driver:", msg_2_DUT.payload);//se obtiene el mensaje que se envio desde el agente
      
      for ( int i=0; i < drvrs; i++)begin //se resetea el DUT para evitar errores
        bus_interface.pndng[0][i]<=0;
        bus_interface.reset<=1'b1;
        #1bus_interface.reset<=1'b0;
      end

      for ( int j=0; j < drvrs; j++)
        begin//se recorren con el numero de dispositivos
          fork 


            forever begin//
              @(posedge bus_interface.clk)
              #1agnt_2_drvr_mbx.peek(msg_2_DUT);//Se obtiene la instruccion que viene desde el agente y se asigna a una variable trans_BUS
              if (msg_2_DUT.id_emisor==j);//se revisa si la instruccion tiene como emisor el dispositijo j
                  agnt_2_drvr_mbx.get(msg_2_DUT);//Si se cumple la condicion se saca el mensaje del bus
                  //Aca se tiene que agregar el dato a la fifo emulada
                  //Aca se saca el dato de la fifo emulada
                  $display("----------Driver---------");
                  $display("Se hara un push a un mensaje en el DUT");           
                  $display("dispositivo destino: %b",msg_2_DUT.id_dest);
                  $display("payload: %b",msg_2_DUT.payload);
                  $display("Mensaje completo a enviar: %b",msg_2_DUT.D_push);
                        bus_interface.D_push[0][j]<=msg_2_DUT.D_push;
              		
                        bus_interface.pndng[0][j]<=1'b1;
                  $display(bus_interface.pndng[0][j]);


            end 

          join_none

      end
      
    endtask    
      
endclass