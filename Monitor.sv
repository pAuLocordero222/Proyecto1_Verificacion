class monitor #(parameter pckg_size, num_msg, drvrs, bits);
  
      //virtual bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) bus_interface;
  
  task run();
    $display("Monitor correctamente inicializado");



    
  endtask
  
endclass