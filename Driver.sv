
class driver #(parameter pckg_size, num_msg, drvrs, bits);
  
	mailbox agnt_2_drvr_mbx;
  
    virtual bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) bus_interface; //instancia para la interface
  	trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_2_DUT; //instancia de la clase de transferencia para guardar el mensaje que se va a enciar al DUT
  
    task run();
      //$display("Mensaje en driver:", msg_2_DUT.payload);//se obtiene el mensaje que se envio desde el agente
      
      for ( int i=0; i < drvrs; i++)begin //se resetea el DUT para evitar errores
        $display("aaaaaa");
        bus_interface.pndng[0][i]<=0;
        bus_interface.reset<=1'b1;
        #1bus_interface.reset<=1'b0;
      end

      /*for ( int j=0; i < drvrs; j++)begin
        fork begin



      end*/  
      
    endtask    
      
endclass
      