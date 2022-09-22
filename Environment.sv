

class Envi #(parameter pckg_size, num_msg, drvrs, bits);
    //Se instancian los distintos modulos del ambiente
  
    age_gen #(.pckg_size(pckg_size), .num_msg(num_msg), .drvrs(drvrs)) inst_age_gen;
  	driver #(.pckg_size(pckg_size), .num_msg(num_msg), .drvrs(drvrs), .bits(bits)) inst_Driver;
  	monitor #(.pckg_size(pckg_size), .num_msg(num_msg), .drvrs(drvrs), .bits(bits)) inst_Monitor;
    checker #(.pckg_size(pckg_size), .num_msg(num_msg), .drvrs(drvrs), .bits(bits)) inst_checker;
    scoreborad #(.pckg_size(pckg_size), .num_msg(num_msg), .drvrs(drvrs), .bits(bits)) inst_scoreboard;

  
	  mailbox agnt_2_drvr_mbx;
    mailbox agnt_2_chckr_mbx;
    mailbox mntr_2_chckr_mbx;
    mailbox chckr_2_scrbrd_mbx;
    mailbox drvr_2_scrbrd_mbx;
    mailbox drvr_2_chckr_mbx;


    virtual bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) vif;

    //Declaracion de los mailboxes
    //mailbox test_2_gen_mbx;
    

    function new();
        //Instanciacion de los mailboxes
        agnt_2_drvr_mbx = new();
        agnt_2_chckr_mbx = new();
        mntr_2_chckr_mbx = new();
        chckr_2_scrbrd_mbx = new();
        drvr_2_scrbrd_mbx = new();
        drvr_2_chckr_mbx = new();
      
        //Instanciacion de los componentes del ambiente
        inst_age_gen = new();
      	inst_Driver=new();
      	inst_Monitor=new();
        inst_checker = new();
        inst_scoreboard = new();
      

        //Conexion de las interfases y mailboxes en el ambiente
      
        inst_age_gen.agnt_2_drvr_mbx = agnt_2_drvr_mbx;//conexion de mailbox entre agente y driver
      	inst_Driver.agnt_2_drvr_mbx = agnt_2_drvr_mbx;
        inst_checker.agnt_2_chckr_mbx = agnt_2_chckr_mbx;
        inst_age_gen.agnt_2_chckr_mbx = agnt_2_chckr_mbx;
        inst_checker.mntr_2_chckr_mbx = mntr_2_chckr_mbx;
        inst_Monitor.mntr_2_chckr_mbx = mntr_2_chckr_mbx;
        inst_scoreboard.chckr_2_scrbrd_mbx = chckr_2_scrbrd_mbx;
        inst_checker.chckr_2_scrbrd_mbx = chckr_2_scrbrd_mbx;
        inst_Driver.drvr_2_scrbrd_mbx = drvr_2_scrbrd_mbx;
        inst_scoreboard.drvr_2_scrbrd_mbx = drvr_2_scrbrd_mbx;
        inst_Driver.drvr_2_chckr_mbx = drvr_2_chckr_mbx;
        inst_checker.drvr_2_chckr_mbx = drvr_2_chckr_mbx;
      
      

      
    endfunction
    task run();
      inst_Driver.vif=vif;
      inst_Monitor.vif=vif;
    /*  
      for (int i; i <= drvrs; i++) begin
        inst_Driver.fifo[i].vif=vif;
      end
     */ 
        fork
            inst_age_gen.run();
          	inst_Driver.run();
          	inst_Monitor.run();
            inst_checker.run();
            #10000;
            inst_scoreboard.run();

        join_none



    endtask
    
endclass

