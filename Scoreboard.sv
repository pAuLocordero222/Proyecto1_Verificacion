class scoreborad #(parameter pckg_size, num_msg, drvrs, bits);


    mailbox chckr_2_scrbrd_mbx;
    //mailbox agnt_2_scrbrd_mbx;
    mailbox drvr_2_scrbrd_mbx;


    int t_total = 0;
    int t_promedio = 0;
    int fcsv;

    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) array_drvr[num_msg-1:0];
    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) array_chckr[num_msg-1:0];



    task run();
        
        $display("[%g] El scoreboard fue inicializado.", $time);

        fcsv = $fopen("./resultados.csv", "w");

        $fwrite(fcsv,"T_envio,Disp_envio,T_recibido,Disp_recibido,Retraso \n");
        


        for (int i = 0; i < num_msg; i++) begin

            array_chckr[i] = new();
            array_drvr[i] = new();

            drvr_2_scrbrd_mbx.get(array_drvr[i]);
            chckr_2_scrbrd_mbx.get(array_chckr[i]);

        end

        for (int i = 0; i < num_msg; i++) begin
            for (int j = 0; j < num_msg; j++) begin
                if(array_drvr[i].message==array_chckr[j].message)begin
                    $fwrite(fcsv, "%0d, %0d, %0d, %0d, %0d \n", array_drvr[i].tiempo_envio,array_drvr[i].id_emisor,array_chckr[j].tiempo_recibido,array_chckr[j].message[15:8],array_chckr[j].tiempo_recibido-array_drvr[i].tiempo_envio);
                    t_total = t_total + array_chckr[j].tiempo_recibido-array_drvr[i].tiempo_envio;
                end
            end
        end

        t_promedio = t_total / num_msg;
        $display("---------------------------");
        $display("Scoreboard");
        $display("El retardo promedio es %0d ns:", t_promedio);



    endtask

/*
    function new_row();
    endfunction*/

endclass