

class Envi #(parameter pckg_size, num_msg, drvrs, bits);
    //Se instancian los distintos modulos del ambiente
  
    age_gen #(.pckg_size(pckg_size), .num_msg(num_msg), .drvrs(drvrs)) inst_age_gen;
  	driver #(.pckg_size(pckg_size), .num_msg(num_msg), .drvrs(drvrs), .bits(bits)) inst_Driver;
  	monitor #(.pckg_size(pckg_size), .num_msg(num_msg), .drvrs(drvrs), .bits(bits)) inst_Monitor;

  
	mailbox agnt_2_drvr_mbx;



    virtual bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) vif;

    //Declaracion de los mailboxes
    //mailbox test_2_gen_mbx;
    

    function new();
        //Instanciacion de los mailboxes
        agnt_2_drvr_mbx = new();
      
        //Instanciacion de los componentes del ambiente
        inst_age_gen = new();
      	inst_Driver=new();
      	inst_Monitor=new();
      

        //Conexion de las interfases y mailboxes en el ambiente
      
        inst_age_gen.agnt_2_drvr_mbx = agnt_2_drvr_mbx;//conexion de mailbox entre agente y driver
      	inst_Driver.agnt_2_drvr_mbx = agnt_2_drvr_mbx;
      

      
    endfunction
    task run();
      inst_Driver.vif=vif;
      inst_Monitor.vif=vif;
      inst_Driver.function();
      for (int i; i <= drvrs; i++) begin
        inst_Driver.fifo[i].vif=vif;
      end
      
        fork
            inst_age_gen.run();
          	inst_Driver.run();
          	inst_Monitor.run();

        join_none



    endtask
    
endclass

