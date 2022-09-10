class FIFO #(parameter pckg_sz = 4, parameter disp = 4);

    bit rst;
    int D_in;
    bit push;
    bit pop;
    int D_out;
  	int q[$];

    function new(bit rst = 0, bit D_in = 0, bit push = 0, bit pop = 0, bit D_out = 0);
        this.rst = rst;
        this.push = push;
        this.pop = pop;
        this.D_in = D_in;
        this.D_out = D_out;
    endfunction
  
  function void fifo();

      forever begin
          D_out = q[-1];

          //Funciones de la FIFO
          if(push)begin
              q.push_front(D_in);
              $display("Dato out push = %0b",this.D_out);
          end
          else if(pop)begin
              q.pop_back;
              $display("Dato out pop = %0b",this.D_out);
          end
          else if(rst)begin
              q.delete();
          end

      end

    
  endfunction


    
endclass

