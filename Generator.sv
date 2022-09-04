//Creacion de la clase para la transaccion entre generador y driver
typedef enum {lectura, escritura, reset } tipo_trans;
class trans_bus #(parameter pckg_size = 16 ):
    int retardo; //numero de ciclos de reloj que se deben esperar para ejecutar la instruccion
    int [pckg_size-8:0]payload; //dato
    int [8:0]id_dest; //direccion del dispositivo destino
    int [8:0]id_emisor; //direccion del dispositivo del cual se envia el mensaje
    tipo_trans tipo; //tipo de transaccion
    int max_retardo;

    constraint const_retardo{retardo<max_retardo: retardo>0}

endclass