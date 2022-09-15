
class driver #(parameter pckg_size, num_msg, drvrs, bits);
  	
	  mailbox agnt_2_drvr_mbx;
  
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
    
      $display("Driver correctamente inicializado");
      vif.reset= 1'b1;

      for (int i=0; i < drvrs; i++) begin
        fifo[i].vif=vif;
        $display("Fifo [%d] creada", i);
      end      

      for ( int p=0; p < drvrs; p++)
        begin//se recorren con el numero de dispositivos

          fork
          automatic int w=p;
          fifo[w].run();  
          join_none


          fork 

            automatic int j=p;
            msg_2_DUT[j]=new();

            
            //Actualiza los valors de la fifo
            forever begin
              @(posedge vif.clk)
              vif.reset= 1'b0;

                if(agnt_2_drvr_mbx.num()>0) begin
                  agnt_2_drvr_mbx.peek(msg_2_DUT[j]);

                  if(msg_2_DUT[j].id_emisor==j) begin
                    agnt_2_drvr_mbx.get(msg_2_DUT[j]);
                    fifo[j].q.push_back(msg_2_DUT[j].message);
                  end
                  
                end
            $display("Dato actual de la fifo: %d en el D_pop: %b ", j,vif.D_pop[0][j]);
            $display("Push del dispositivo %0d %0d: ",j,vif.push[0][j]);
            $display("pndng del dispositivo %0d %0d: ",j,vif.pndng[0][j]);
            $display("Reset: %d",vif.reset);

            end


          join_none

      end
    endtask    
//a
endclass
