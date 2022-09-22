class scoreborad #(parameter pckg_size, num_msg, drvrs, bits);

    //Definicion de mailboxes usados
    mailbox chckr_2_scrbrd_mbx;
    mailbox drvr_2_scrbrd_mbx;


    int t_total = 0;//Se guarda la suma de todos los retrasos
    int t_promedio = 0;//se guarda el promedio de todos los retrasos
    int fcsv;//Se usa lara el archivo .csv


    //Definicion de los arreglos para guardar los datos provenientes del driver y del checker
    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) array_drvr[num_msg-1:0];
    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) array_chckr[num_msg-1:0];



    task run();
        
        $display("[%g] El scoreboard fue inicializado.", $time);

        fcsv = $fopen("./resultados.csv", "w");//Se abre el archivo .csv en modo escritura

        //Se escribe la primera linea en el archivo .csv
        $fwrite(fcsv,"T_envio [ns],Disp_envio,T_recibido [ns],Disp_recibido,Retraso [ns] \n");
        


        for (int i = 0; i < num_msg; i++) begin//Ciclo para obtener los datos provenientes del driver y del checker

            array_chckr[i] = new();//Se inicializa
            array_drvr[i] = new();//Se inicializa

            drvr_2_scrbrd_mbx.get(array_drvr[i]);//Se guardan los datos provenientes del mailbox en el arreglo
            chckr_2_scrbrd_mbx.get(array_chckr[i]);//Se guardan los datos provenientes del mailbox en el arreglo
            $display("DRVR: %0h", array_drvr[i].message);
            $display("CHCKR: %0h", array_chckr[i].message);

        end

        $display("Tamaño %0d", $size(array_chckr))

        //Ciclo para comparar los datos de ambos arreglos
        for (int i = 0; i < num_msg; i++) begin
            for (int j = 0; j < num_msg; j++) begin
                if(array_drvr[i].message==array_chckr[j].message)begin//Compara los mensajes de cada arreglo

                    //Escribe cada linea en el archivo .csv
                    $fwrite(fcsv, "%0h, %0d, %0d, %0d, %0d, %0d \n", array_drvr[i].message, array_drvr[i].tiempo_envio,array_drvr[i].id_emisor,array_chckr[j].tiempo_recibido,array_chckr[j].message[15:8],array_chckr[j].tiempo_recibido-array_drvr[i].tiempo_envio);
                    t_total = t_total + array_chckr[j].tiempo_recibido-array_drvr[i].tiempo_envio;//Se calcula la suma de todos los retrasos
                end
            end
        end

        t_promedio = t_total / num_msg;//Se calcula el retraso promedio
        $display("---------------------------");
        $display("Scoreboard");
        $display("El retardo promedio es %0d ns:", t_promedio);//Se muestra el retraso promedio



    endtask

/*
    function new_row();
    endfunction*/

endclass