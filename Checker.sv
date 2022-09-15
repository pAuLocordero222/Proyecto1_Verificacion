class checker #(parameter pckg_size, num_msg, drvrs, bits);

    mailbox mntr_2_chckr_mbx;
    mailbox agnt_2_chckr_mbx;

    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_agnt_chckr;
    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_mntr_chckr;
    
    task run();
        $display("[%g] El checker fue inicializado.", $time);
        msg_agnt_chckr = new;
        msg_mntr_chckr = new;

        for (int i = 0; i < num_msg; i++) begin
            mntr_2_chckr_mbx.get(msg_mntr_chckr); //Se obtiene el dato desde el monitor
            agnt_2_chckr_mbx.get(msg_agnt_chckr); //Se obtiene el dato desde el agente
            $display("---------------------------");
            $display("Checker");
            $display("Se recibieron los mensajes desde el agente y desde el monitor");
            $display("Mensaje del agente: %b", msg_agnt_chckr);
            $display("Mensaje del monitor: %b", msg_mntr_chckr);
            
            if (msg_mntr_chckr.message == msg_agnt_chckr.message) begin
                $display("La transaccion fue realizada correctamente");
                $display("---------------------------");
            end

            else begin
                $display("ERROR: no se recibio el mensaje %d correctamente", i);
                $display("---------------------------");
            end

        end


    endtask


endclass