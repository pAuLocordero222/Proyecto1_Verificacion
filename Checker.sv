class checker #(parameter pckg_size, num_msg, drvrs, bits);

    bit [pckg_size-1:0]q_chkr[$]={};

    mailbox mntr_2_chckr_mbx;
    mailbox agnt_2_chckr_mbx;
    mailbox chckr_2_scrbrd_mbx;

    //event AgenteListo;  
    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_agnt_chckr;
    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_mntr_chckr;
    
    task run();
        $display("[%g] El checker fue inicializado.", $time);
        msg_agnt_chckr = new;
        msg_mntr_chckr = new;
        for (int i = 0; i < num_msg; i++) begin
            mntr_2_chckr_mbx.get(msg_mntr_chckr);
            chckr_2_scrbrd_mbx.put(msg_mntr_chckr);
            q_chkr.push_back(msg_mntr_chckr.message);
        end


        for (int i = 0; i < agnt_2_chckr_mbx.num(); i++) begin
            //mntr_2_chckr_mbx.get(msg_mntr_chckr); //Se obtiene el dato desde el monitor
            agnt_2_chckr_mbx.get(msg_agnt_chckr); //Se obtiene el dato desde el agente
            $display("---------------------------");
            $display("Checker");
            $display("Se recibieron los mensajes desde el agente y desde el monitor");
            //$display("Mensaje del agente: %b", msg_agnt_chckr.message);
            //$display("Mensaje del monitor: %b", msg_mntr_chckr.message);
            

            for (int j = 0; j < $size(q_chkr); j++) begin
                if (q_chkr[j] == msg_agnt_chckr.message) begin
                    $display("La transaccion %0d fue realizada correctamente", i);
                    $display("---------------------------");
                end
            end
            /*
            $display("La transaccion %0d fue realizada correctamente", i);
            $display("---------------------------");*/

/*
            else begin
                $display("ERROR: no se recibio el mensaje %d correctamente", i);
                $display("---------------------------");
            end*/

        end


    endtask


endclass