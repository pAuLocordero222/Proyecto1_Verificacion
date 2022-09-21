class monitor #(parameter pckg_size, num_msg, drvrs, bits);

  mailbox mntr_2_chckr_mbx;


  trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_2_Monitor[drvrs-1:0];
  virtual bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) vif;
      
  task run();
    $display("t=%0d Monitor correctamente inicializado", $time);

    for ( int j=0; j < drvrs; j++)begin
      	
        fork
          automatic int i=j;
          msg_2_Monitor[i]=new;
            forever begin//
              @(negedge vif.clk)
              if (vif.push[0][i]==1)begin
                //falta la parte donde el dato entra a la fifo simulada y tambien sale de esta
                msg_2_Monitor[i].message=vif.D_push[0][i];
                msg_2_Monitor[i].tiempo_recibido = $time; 
                mntr_2_chckr_mbx.put(msg_2_Monitor[i]);
              	$display(""); 
                $display("------Monitor-----"); 
                $display("t=%0dns  Se obtuvo el mensaje: %b",$time, msg_2_Monitor[i].message);
                $display("en el dispositivo", i);
                $display(""); 
              end
            end
        join_none
    end   
  endtask  
endclass