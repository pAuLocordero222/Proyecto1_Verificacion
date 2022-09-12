

class Envi #(parameter pckg_size, num_msg, drvrs, bits);
  
    age_gen #(.pckg_size(pckg_size), .num_msg(num_msg), .drvrs(drvrs)) inst_age_gen;
  	driver #(.pckg_size(pckg_size), .num_msg(num_msg), .drvrs(drvrs), .bits(bits)) inst_Driver;
	mailbox agnt_2_drvr_mbx;


    virtual bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) bus_interface;

    //Declaracion de los mailboxes
    //mailbox test_2_gen_mbx;
    

    function new();
        //Instanciacion de los mailboxes
        agnt_2_drvr_mbx = new();
        //Instanciacion de los componentes del ambiente
        inst_age_gen = new();
      	inst_Driver=new();
      

        //Conexion de las interfases y mailboxes en el ambiente
      
        inst_age_gen.agnt_2_drvr_mbx = agnt_2_drvr_mbx;//mailboxes entre agente y driver
      	inst_Driver.agnt_2_drvr_mbx = agnt_2_drvr_mbx;
      
    endfunction
    task run();
        fork
            inst_age_gen.run();
          	inst_Driver.run();

        join_none



    endtask
    
endclass


