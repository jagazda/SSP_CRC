module ram_mem_sim(clk, ren, we, addr, din, dout);

parameter [31:0]  SIZE = 32'd12;

input wire                      clk;
input wire                      ren;
input wire      [3:0]           we;
input wire      [SIZE-3:0]      addr;
input wire      [`WIDTH-1:0]    din;
output wire     [`WIDTH-1:0]    dout;

`ifndef LINT

reg     [7:0]   mem_a    [0:2**(SIZE-2)-1];
reg     [7:0]   mem_b    [0:2**(SIZE-2)-1];
reg     [7:0]   mem_c    [0:2**(SIZE-2)-1];
reg     [7:0]   mem_d    [0:2**(SIZE-2)-1];

reg     [7:0]        dout_reg       [3:0];

assign  dout    = {dout_reg[3],dout_reg[2],dout_reg[1],dout_reg[0]};

always @(posedge clk)
begin
    if (ren|(we!=0)) begin
        dout_reg[0] <= mem_a[addr];
        dout_reg[1] <= mem_b[addr];
        dout_reg[2] <= mem_c[addr];
        dout_reg[3] <= mem_d[addr];
    end
    if (we[0]) begin
        mem_a[addr] <= din[7:0];
    end
    if (we[1]) begin
        mem_b[addr] <= din[15:8];
    end
    if (we[2]) begin
        mem_c[addr] <= din[23:16];
    end
    if (we[3]) begin
        mem_d[addr] <= din[31:24];
    end
end

`endif
