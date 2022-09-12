class monitor #(parameter pckg_size, num_msg, drvrs, bits);


    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_2_Monitor;
    virtual bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) bus_interface;
    
  
  task run();
    $display("Monitor correctamente inicializado");

    for ( int i=0; i < drvrs; i++)begin

        fork
            forever begin//
              @(posedge bus_if.pop[0][i])
              //falta la parte donde el dato entra a la fifo simulada y tambien sale de esta
              msg_2_Monitor.message<=bus_interface.D_push[0][i]; 
              $display("Agente"); 
              $display("Se obtuvo el mensaje: %b",msg_2_Monitor.message);
              $display("en el dispositivo", i);

            end
        join_none

    end




    
  endtask
  
endclass