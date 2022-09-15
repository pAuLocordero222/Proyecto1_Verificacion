class checker #(parameter pckg_size, num_msg, drvrs, bits);

    mailbox mntr_2_chckr_mbx;
    mailbox agnt_2_chckr_mbx;

    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_agnt_chckr[pckg_size-1:0], msg_mntr_chckr[pckg_size-1:0];
    
    task run();
        $display("[%g] El checker fue inicializado.", $time);
        msg_agnt_chckr = new;
        msg_mntr_chckr = new;

        for (int i = 0, i < num_msg, i++) begin
            mntr_2_chckr_mbx.get(msg_mntr_chckr); //Se obtiene el dato desde el monitor
            agnt_2_chckr_mbx.get(msg_agnt_chckr); //Se obtiene el dato desde el agente
            $display("Se recibieron los mensajes desde el agente y desde el monitor");
            
            if (msg_mntr_chckr.message == msg_agnt_chckr.message) begin
                $display("La transaccion fue realizada correctamente");
            end

            else begin
                $display("ERROR: no se recibio el mensaje correctamente");
            end

        end


    endtask


endclass