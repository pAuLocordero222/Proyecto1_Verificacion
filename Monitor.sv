class monitor #(parameter pckg_size, num_msg, drvrs, bits);

  mailbox mntr_2_chckr_mbx;//Se define el mailbox que envia datos al checker


  trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_2_Monitor[drvrs-1:0];//se define un arreglo de tipo trans_bus
  virtual bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) vif;
      
  task run();// se crea un task run 
    $display("t=%0d Monitor correctamente inicializado", $time);// se 

    for ( int j=0; j < drvrs; j++)begin// se recorren los drivers 
      	
        fork//se separa cada iteracion en procesos hojos
          automatic int i=j;
          msg_2_Monitor[i]=new;//se inicializa el elemento i del arreglo trans_bus
            forever begin //se inicia un ciclo infinito 
              @(negedge vif.clk) //se corren las lineas de abajo en el flanco negativo del reloj
              if (vif.push[0][i]==1)begin //se verifica si la bandera de push para el dispositivo i esta en alto
                msg_2_Monitor[i].message=vif.D_push[0][i];// si el push esta en alto se toma el mensaje y se asgina en elemento i del arreglo de trans_bus
                msg_2_Monitor[i].tiempo_recibido = $time; //Se asgina el tiempo de recibido al elemento del arreglo que guarda el mensaje
                mntr_2_chckr_mbx.put(msg_2_Monitor[i]);//se envia el elemento del arreglo hacia el checker a traves del mailbox
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