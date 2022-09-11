class Envi #(parameter pckg_size, num_msg, drvrs, bits);
    age_gen #(.pckg_size(pckg_size), .num_msg(num_msg), .drvrs(drvrs)) inst_age_gen;


    virtual bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) bus_interface;

    //Declaracion de los mailboxes
    //mailbox test_2_gen_mbx;
    mailbox agnt_2_drvr_mbx; 

    function new();
        //Instanciacion de los mailboxes
        test_2_gen_mbx = new();
        agnt_2_drvr_mbx = new();
        //Instanciacion de los componentes del ambiente
        inst_age_gen = new();

        //Conexion de las interfases y mailboxes en el ambiente
        inst_age_gen.agnt_2_drvr_mbx = agnt_2_drvr_mbx;
    endfunction
    task run();
        fork
            inst_age_gen.run();

        join_none



    endtask
    
endclass