class scoreborad #(parameter pckg_size, num_msg, drvrs, bits);


    mailbox chckr_2_scrbrd_mbx;
    //mailbox agnt_2_scrbrd_mbx;
    mailbox drvr_2_scrbrd_mbx;


    int t_total = 0;
    int t_promedio = 0;
    int fcsv;

    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_drvr_scrbrd;//[drvrs-1:0];
    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_chckr_scrbrd;//[drvrs-1:0];

    chkr_scrbrd #(.pckg_size(pckg_size)) ob_scrbrd;

    task run();
        
        $display("[%g] El scoreboard fue inicializado.", $time);

        fcsv = $fopen("./resultados.csv", "w");

        $fwrite(fcsv,"T_envio,Disp_envio,T_recibido,Disp_recibido,Retraso \n");
        

        $display("Retardo promedio");

        //msg_drvr_scrbrd = new;
        msg_chckr_scrbrd = new;

        for (int i = 0; i < num_msg; i++) begin
            chckr_2_scrbrd_mbx.get(ob_scrbrd);
            $fwrite(fcsv, "%d, %d, %d, %d, %d \n", ob_scrbrd.tiempo_envio,ob_scrbrd.id_emisor,ob_scrbrd.tiempo_recibido,ob_scrbrd.id_dest,1);
        end






    endtask

/*
    function new_row();
    endfunction*/

endclass