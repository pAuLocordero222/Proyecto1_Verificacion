class monitor #(parameter pckg_size, num_msg, drvrs, bits);


  trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_2_Monitor[drvrs-1:0];
    virtual bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) bus_interface;
    
  
  task run();
    $display("Monitor correctamente inicializado");

    for ( int j=0; j < drvrs; j++)begin
      	automatic int i=j;
        fork
          msg_2_Monitor[i]=new;
            forever begin//
              @(posedge bus_interface.push[0][i])
                $display("push en la salida: ", bus_interface.push[0][i]);
                //falta la parte donde el dato entra a la fifo simulada y tambien sale de esta
                msg_2_Monitor[i].message<=bus_interface.D_push[0][i]; 
              	$display(""); 
              $display("------Monitor-----"); 
                $display("Se obtuvo el mensaje: %b",msg_2_Monitor[i].message);
                $display("en el dispositivo", i);
     

            end
        join_none

    end




    
  endtask
  
endclass