//Creacion de la clase para la transaccion entre generador y driver
typedef enum {lectura, escritura, reset, broadcast } tipo_trans;
class trans_bus #(parameter pckg_size = 16 ):
    int retardo; //numero de ciclos de reloj que se deben esperar para ejecutar la instruccion
    bit [pckg_size-8:0]payload; //dato
    bit [8:0]id_dest; //direccion del dispositivo destino
    int tiempo;
    bit [8:0]id_emisor; //direccion del dispositivo del cual se envia el mensaje
    tipo_trans tipo; //tipo de transaccion


    function new(int ret=0, bit[pckg_size-8:0] pyld=0, int tmp = 0; bit [8:0]dest=0, bit [8:0]emi,tipo_trans tpo=lectura, int mx_ret=5 );
        this.retardo=ret;
        this.payload=pyld;
        this.tiempo = tmp;
        this.id_dest=dest;
        this.id_emisor=emi;
        this.tipo=tpo;

        
    endfunction
        this.retardo=0;
        this.payload=0;
        this.tiempo=0;
        this.id_dest=0;
        this.id_emisor=0;
        this.tipo=0;
    function clean:

    function void print(string tag="")
        $display("[%g] %s Tiempo=%s Tipo=%s Retardo=%g Payload=0x%h destino=%b emisor=%b",$time,tag,tiempo,this.retardo,this.payload,this.id_dest,this.id_emisor);

    endfunction

endclass

//randem = emisor aleatorio
//randrec = receptor aleatorio
//specem = emisor especifico
//specrec = receptor especifico
typedef enum {randem_randrec, randem_specrec, specem_randrec, specem_specrec, reset} instrucciones_agente;


//Definicion de los mailboxes
typedef mailbox #(trans_bus) trans_bus_mbx;

typedef mailbox #(instrucciones_agente) cmd_test_agente_mbx;