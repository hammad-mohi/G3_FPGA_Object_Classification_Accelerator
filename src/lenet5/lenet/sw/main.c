/******************************************************************************
*
* Copyright (C) 2009 - 2017 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

//Standard library includes
#include <stdio.h>
#include <string.h>

// DMA
#include "xaxidma.h"
#include "sleep.h"
#include "xintc.h"
#include "xuartlite.h"
#include "xstatus.h"
#include "xil_assert.h"
//#include "image.h" // for testing only

//BSP includes for DDR DRAM access
#include <xil_io.h>

//BSP includes for peripherals
#include "xparameters.h"
#include "netif/xadapter.h"

#include "platform.h"
#include "platform_config.h"
#if defined (__arm__) || defined(__aarch64__)
#include "xil_printf.h"
#endif
#include "xil_cache.h"

//LWIP include files
#include "lwip/ip_addr.h"
#include "lwip/tcp.h"
#include "lwip/err.h"
#include "lwip/tcp.h"
#include "lwip/inet.h"
#include "lwip/etharp.h"
#if LWIP_IPV6==1
#include "lwip/ip.h"
#else
#if LWIP_DHCP==1
#include "lwip/dhcp.h"
#endif
#endif

void lwip_init(); /* missing declaration in lwIP */
struct netif *echo_netif;

//TCP Network Params
#define SRC_MAC_ADDR {0x00, 0x0a, 0x35, 0x00, 0x00, 27} // MAC ADDR OF THIS (CLIENT) COMPUTER
#define SRC_IP4_ADDR "1.1.27.2" // THIS (CLIENT) COMPUTER; 2 -> FPGA
#define IP4_NETMASK "255.255.0.0"
#define IP4_GATEWAY "1.1.0.1"
#define SRC_PORT 6063

#define DEST_IP4_ADDR  "1.1.5.1" // COMPUTER THAT SERVER IS RUNNING ON; 1 -> NOT FPGA
#define DEST_IP6_ADDR "fe80::6600:6aff:fe71:fde6"
#define DEST_PORT 6063

#define TCP_SEND_BUFSIZE 256

#define IMG_SIZE 301056

#define rgb_channels 3
#define img_width 32
//#define img_packet_tot_size img_width * img_width * rgb_channels * 2
#define img_packet_tot_size img_width * img_width * 2

// The current address in memory after receiving packets and saving
u32_t curr_addr = 0;
//volatile unsigned char* curr_addr = (unsigned int*) XPAR_MIG_7SERIES_0_BASEADDR;
// How many bytes have been received so far, want to stop when entire img sent
int curr_recv = 0;

//Function prototypes
#if LWIP_IPV6==1
void print_ip6(char *msg, ip_addr_t *ip);
#else
void print_ip(char *msg, ip_addr_t *ip);
void print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw);
#endif
int setup_client_conn();
void tcp_fasttmr(void);
void tcp_slowtmr(void);

//Function prototypes for callbacks
static err_t tcp_client_connected(void *arg, struct tcp_pcb *tpcb, err_t err);
static err_t tcp_client_recv(void *arg, struct tcp_pcb *tpcb, struct pbuf *p, err_t err);
static err_t tcp_client_sent(void *arg, struct tcp_pcb *tpcb, u16_t len);
static void tcp_client_err(void *arg, err_t err);
static void tcp_client_close(struct tcp_pcb *pcb);

//DHCP global variables
#if LWIP_IPV6==0
#if LWIP_DHCP==1
extern volatile int dhcp_timoutcntr;
err_t dhcp_start(struct netif *netif);
#endif
#endif

//Networking global variables
extern volatile int TcpFastTmrFlag;
extern volatile int TcpSlowTmrFlag;
static struct netif server_netif;
struct netif *app_netif;
static struct tcp_pcb *c_pcb;
char is_connected;
char send_buf[TCP_SEND_BUFSIZE];

// useful defines
#define DEBUG 0 // for printing more debug info


/***************** DMA related defines and variables - start *****************/
// defines
#define img_width            32
#define img_size             img_width * img_width
#define dma_device_id        XPAR_AXI_DMA_0_DEVICE_ID
#define intr_ctrl_device_id  XPAR_MICROBLAZE_0_AXI_INTC_DEVICE_ID
#define uartlite_device_id   XPAR_AXI_UARTLITE_0_DEVICE_ID
#define dma_irq              XPAR_MICROBLAZE_0_AXI_INTC_AXI_DMA_0_S2MM_INTROUT_INTR
#define neural_core_irq      XPAR_MICROBLAZE_0_AXI_INTC_NEURAL_CORE_0_O_INTERRUPT_INTR
#define dma_base_addr        XPAR_AXI_DMA_0_BASEADDR
#define dma_idle_reg_offset  0x4 // MM2S DMA status register

// global variables
XAxiDma dma_inst;
XIntc intrc_inst;
u8 max_neuron_index = -1;
int nc_done=0, dma_done=0;

// image in DDR
#define input_image 0x90000000U // set in lscript.ld
//u32 *input_image = (u32 *)img_buffer_ddr_base;

// function prototypes
//static u32 check_dma_idle(u32 base_addr, u32 offset);
XStatus init_intr_ctrl(XIntc *intrc_inst_ptr);
XStatus config_dma(XAxiDma *dma);
XStatus enable_interrupts(XIntc *intrc_inst_ptr);
void neural_core_ISR(void *callback);
void dma_s2mm_ISR(void *callback);
int start_dma_transfer();
/***************** DMA related defines and variables - start *****************/

int main() {
	//Varibales for IP parameters
#if LWIP_IPV6==0
	ip_addr_t ipaddr, netmask, gw;
#endif

	//The mac address of the board. this should be unique per board
	unsigned char mac_ethernet_address[] = SRC_MAC_ADDR;

	//Network interface
	app_netif = &server_netif;

	//Initialize platform
	init_platform();

	//Defualt IP parameter values
#if LWIP_IPV6==0
#if LWIP_DHCP==1
    ipaddr.addr = 0;
	gw.addr = 0;
	netmask.addr = 0;
#else
	(void)inet_aton(SRC_IP4_ADDR, &ipaddr);
	(void)inet_aton(IP4_NETMASK, &netmask);
	(void)inet_aton(IP4_GATEWAY, &gw);
#endif
#endif

	//LWIP initialization
	lwip_init();

	//Setup Network interface and add to netif_list
#if (LWIP_IPV6 == 0)
	if (!xemac_add(app_netif, &ipaddr, &netmask,
						&gw, mac_ethernet_address,
						PLATFORM_EMAC_BASEADDR)) {
		xil_printf("Error adding N/W interface\n");
		return -1;
	}
#else
	if (!xemac_add(app_netif, NULL, NULL, NULL, mac_ethernet_address,
						PLATFORM_EMAC_BASEADDR)) {
		xil_printf("Error adding N/W interface\n");
		return -1;
	}
	app_netif->ip6_autoconfig_enabled = 1;

	netif_create_ip6_linklocal_address(app_netif, 1);
	netif_ip6_addr_set_state(app_netif, 0, IP6_ADDR_VALID);

#endif
	netif_set_default(app_netif);

	//Now enable interrupts
	platform_enable_interrupts();

	//Specify that the network is up
	netif_set_up(app_netif);

#if (LWIP_IPV6 == 0)
#if (LWIP_DHCP==1)
	/* Create a new DHCP client for this interface.
	 * Note: you must call dhcp_fine_tmr() and dhcp_coarse_tmr() at
	 * the predefined regular intervals after starting the client.
	 */
	dhcp_start(app_netif);
	dhcp_timoutcntr = 24;

	while(((app_netif->ip_addr.addr) == 0) && (dhcp_timoutcntr > 0))
		xemacif_input(app_netif);

	if (dhcp_timoutcntr <= 0) {
		if ((app_netif->ip_addr.addr) == 0) {
			xil_printf("DHCP Timeout\n");
			xil_printf("Configuring default IP of %s\n", SRC_IP4_ADDR);
			(void)inet_aton(SRC_IP4_ADDR, &(app_netif->ip_addr));
			(void)inet_aton(IP4_NETMASK, &(app_netif->netmask));
			(void)inet_aton(IP4_GATEWAY, &(app_netif->gw));
		}
	}

	ipaddr.addr = app_netif->ip_addr.addr;
	gw.addr = app_netif->gw.addr;
	netmask.addr = app_netif->netmask.addr;
#endif
#endif

	//Print connection settings
#if (LWIP_IPV6 == 0)
	print_ip_settings(&ipaddr, &netmask, &gw);
#else
	print_ip6("Board IPv6 address ", &app_netif->ip6_addr[0].u_addr.ip6);
#endif

	//Gratuitous ARP to announce MAC/IP address to network
	etharp_gratuitous(app_netif);

#if 1
	//Setup connection
	setup_client_conn();

	//Event loop
	while (1) {
		//Call tcp_tmr functions
		//Must be called regularly
		if (TcpFastTmrFlag) {
			tcp_fasttmr();
			TcpFastTmrFlag = 0;
		}
		if (TcpSlowTmrFlag) {
			tcp_slowtmr();
			TcpSlowTmrFlag = 0;
		}

		//Process data queued after interupt
		xemacif_input(app_netif);

		//ADD CODE HERE to be repeated constantly
		// Note - should be non-blocking
		// Note - can check is_connected global var to see if connection open

		//END OF ADDED CODE
	}
#endif

	//Never reached
	cleanup_platform();

	return 0;
}


#if LWIP_IPV6==1
void print_ip6(char *msg, ip_addr_t *ip) {
	print(msg);
	xil_printf(" %x:%x:%x:%x:%x:%x:%x:%x\n",
			IP6_ADDR_BLOCK1(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK2(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK3(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK4(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK5(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK6(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK7(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK8(&ip->u_addr.ip6));

}
#else
void print_ip(char *msg, ip_addr_t *ip) {
	print(msg);
	xil_printf("%d.%d.%d.%d\n", ip4_addr1(ip), ip4_addr2(ip), ip4_addr3(ip), ip4_addr4(ip));
}

void print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw) {
	print_ip("Board IP: ", ip);
	print_ip("Netmask : ", mask);
	print_ip("Gateway : ", gw);
}
#endif

int setup_client_conn() {
	struct tcp_pcb *pcb;
	err_t err;
	ip_addr_t remote_addr;

	xil_printf("Setting up client connection\n");

#if LWIP_IPV6==1
	remote_addr.type = IPADDR_TYPE_V6;
	err = inet6_aton(DEST_IP6_ADDR, &remote_addr);
#else
	err = inet_aton(DEST_IP4_ADDR, &remote_addr);
#endif

	if (!err) {
		xil_printf("Invalid Server IP address: %d\n", err);
		return -1;
	}

	//Create new TCP PCB structure
	pcb = tcp_new_ip_type(IPADDR_TYPE_ANY);
	if (!pcb) {
		xil_printf("Error creating PCB. Out of Memory\n");
		return -1;
	}

	//Bind to specified @port
	err = tcp_bind(pcb, IP_ANY_TYPE, SRC_PORT);
	if (err != ERR_OK) {
		xil_printf("Unable to bind to port %d: err = %d\n", SRC_PORT, err);
		return -2;
	}

	//Connect to remote server (with callback on connection established)
	err = tcp_connect(pcb, &remote_addr, DEST_PORT, tcp_client_connected);
	if (err) {
		xil_printf("Error on tcp_connect: %d\n", err);
		tcp_client_close(pcb);
		return -1;
	}

	is_connected = 0;

	xil_printf("Waiting for server to accept connection\n");

	return 0;
}

static void tcp_client_close(struct tcp_pcb *pcb) {
	err_t err;

	xil_printf("Closing Client Connection\n");

	if (pcb != NULL) {
		tcp_sent(pcb, NULL);
		tcp_recv(pcb,NULL);
		tcp_err(pcb, NULL);
		err = tcp_close(pcb);
		if (err != ERR_OK) {
			/* Free memory with abort */
			tcp_abort(pcb);
		}
	}
}

static err_t tcp_client_connected(void *arg, struct tcp_pcb *tpcb, err_t err) {
	if (err != ERR_OK) {
		tcp_client_close(tpcb);
		xil_printf("Connection error\n");
		return err;
	}

	xil_printf("Connection to server established\n");

	//Store state (for callbacks)
	c_pcb = tpcb;
	is_connected = 1;

	//Set callback values & functions
	tcp_arg(c_pcb, NULL);
	tcp_recv(c_pcb, tcp_client_recv);
	tcp_sent(c_pcb, tcp_client_sent);
	tcp_err(c_pcb, tcp_client_err);

	//ADD CODE HERE to do when connection established

	//END OF ADDED CODE

	return ERR_OK;
}

static err_t tcp_client_recv(void *arg, struct tcp_pcb *tpcb, struct pbuf *p, err_t err) {
	//If no data, connection closed
	if (!p) {
		xil_printf("No more data to receive\n");
		tcp_client_close(tpcb);
		return ERR_OK;
	}

	//************** ADD CODE HERE to do on packet reception *************
	 //xil_printf("Packet received, %d bytes\n", p->tot_len);

	if(curr_recv == img_packet_tot_size) {
		curr_recv = 0;
		curr_addr = 0;
	}

	curr_recv += p->tot_len;

	 u8_t apiflags;



	 if(curr_recv == img_packet_tot_size) {

		 xil_printf("\nReceived Image From DESL Server.\n");

		/* start neural core by triggering a DMA transfer */
		char ret = -2;

		// start timer here

		//usleep(1);
		ret = start_dma_transfer();


		// end timer here


//		XIntc_Disconnect(&intrc_inst, neural_core_irq);
//		XIntc_Disconnect(&intrc_inst, dma_irq);
//		XAxiDma_IntrDisable(&dma_inst, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
//		Xil_ExceptionDisable();
//		XIntc_Stop(&intrc_inst);

		memset(send_buf, 0, TCP_SEND_BUFSIZE);
		send_buf[0] = ret;

		// Clear buffer
		//memset(send_buf, 0, TCP_SEND_BUFSIZE);
		//strcpy(send_buf,"client:recvd_packet\n");

		//Just send a single packet
		apiflags = TCP_WRITE_FLAG_COPY | TCP_WRITE_FLAG_MORE;

		//Loop until enough room in buffer (should be right away)
		while (tcp_sndbuf(c_pcb) < TCP_SEND_BUFSIZE);
		//Enqueue some data to send
		err = tcp_write(c_pcb, send_buf, TCP_SEND_BUFSIZE, apiflags);
		if (err != ERR_OK) {
			xil_printf("TCP client: Error on tcp_write: %d\n", err);
			return err;
		}

		//send the data packet
		err = tcp_output(c_pcb);
		if (err != ERR_OK) {
			xil_printf("TCP client: Error on tcp_output: %d\n",err);
			return err;
		}
	 }

	//***************** store packet in DDR DRAM *****************
	//int len = p->tot_len / 2; // div2 since reading halfwords
	//for(u16_t i = 0; i < len; i+=2) {
	//	Xil_Out16(input_image + curr_addr, *((u16_t *)(p->payload + i)));
	//	curr_addr+=2;
	//}
	
	int len = p->tot_len; // div2 since reading halfwords
	for(u16_t i = 0; i < len; i+=1) {

		char curr_char = *(char *)(p->payload + i);
		uint8_t char_to_num;
		// I tried strtol but I think it's too compute heavy so just do manually
		if(curr_char == '0') char_to_num = (uint8_t)(0);
		else if(curr_char == '1') char_to_num = (uint8_t)1;
		else if(curr_char == '2') char_to_num = (uint8_t)2;
		else if(curr_char == '3') char_to_num = (uint8_t)3;
		else if(curr_char == '4') char_to_num = (uint8_t)4;
		else if(curr_char == '5') char_to_num = (uint8_t)5;
		else if(curr_char == '6') char_to_num = (uint8_t)6;
		else if(curr_char == '7') char_to_num = (uint8_t)7;
		else if(curr_char == '8') char_to_num = (uint8_t)8;
		else if(curr_char == '9') char_to_num = (uint8_t)9;
		else if(curr_char == 'a') char_to_num = (uint8_t)10;
		else if(curr_char == 'b') char_to_num = (uint8_t)11;
		else if(curr_char == 'c') char_to_num = (uint8_t)12;
		else if(curr_char == 'd') char_to_num = (uint8_t)13;
		else if(curr_char == 'e') char_to_num = (uint8_t)14;
		else if(curr_char == 'f') char_to_num = (uint8_t)15;
		Xil_Out8(input_image + curr_addr, char_to_num);
		curr_addr+=1;
	}
	
	
	//*********************** END OF ADDED CODE ***********************

	//Indicate done processing
	tcp_recved(tpcb, p->tot_len);

	//Free the received pbuf
	pbuf_free(p);

	return 0;
}

static err_t tcp_client_sent(void *arg, struct tcp_pcb *tpcb, u16_t len) {

	//ADD CODE HERE to do on packet acknowledged
	//Print message
	#if DEBUG==1
		xil_printf("Packet sent successfully, %d bytes\n", len);
	#endif
	//END OF ADDED CODE

	return 0;
}

static void tcp_client_err(void *arg, err_t err) {
	LWIP_UNUSED_ARG(err);
	tcp_client_close(c_pcb);
	c_pcb = NULL;
	xil_printf("TCP connection aborted\n");
}

/***************** DMA and Interrupt Related Functions *******************/

int start_dma_transfer() {

	u32 status;

	/***********************************************************************************************/
	// initialize interrupt controller
	status = init_intr_ctrl(&intrc_inst);
	if(status != XST_SUCCESS) {
		xil_printf("Interrupt controller initialization failed.\n");
		return XST_FAILURE;
	}

	// configure DMA controller
	status = config_dma(&dma_inst);
	if(status != XST_SUCCESS) {
		xil_printf("DMA configuration failed.\n");
		return XST_FAILURE;
	}

	// enable interrupts and connect ISRs
	status = enable_interrupts(&intrc_inst);
	if(status != XST_SUCCESS) {
		xil_printf("Failed to enable interrupts and connect ISRs.\n");
		return XST_FAILURE;
	}
	/***********************************************************************************************/

	/***********************************************************************************************/
	xil_printf("------------------------------------------------------------------------\n");
	xil_printf("Starting Neural Core DMA Transfer ...\n");
	xil_printf("------------------------------------------------------------------------\n");

	// configure DMA Controller to start sending data
	// receive data from neural core and store in max_neuron_index (somewhere in DDR)
	// length=1 since NC return value is just one byte (index between 0-43)
	status = XAxiDma_SimpleTransfer(&dma_inst,(u32)&max_neuron_index, 1, XAXIDMA_DEVICE_TO_DMA);
	if(status != XST_SUCCESS) {
		xil_printf("Failed to initiate simple dma transfer, direction: XAXIDMA_DEVICE_TO_DMA.\n");
		return XST_FAILURE;
	}

	// send the image from DDR to neural core
	status = XAxiDma_SimpleTransfer(&dma_inst,(u32)input_image, img_size, XAXIDMA_DMA_TO_DEVICE);
	if(status != XST_SUCCESS) {
		xil_printf("Failed to initiate simple dma transfer, direction: XAXIDMA_DMA_TO_DEVICE.\n");
		return XST_FAILURE;
	}
	/***********************************************************************************************/

	/***********************************************************************************************/
	// wait for entire image to be processed
	//int timeout = 10;
	while((!nc_done | !dma_done) /*&& timeout*/) {
		//xil_printf("still running ...\n");
		//--timeout;
		//usleep(1); // 1us
	}

	xil_printf("Neural Core DMA Transfer Done.\n", nc_done, dma_done);

//	return max_neuron_index;

	// check max_neuron_index to confirm successful transfer
	if (max_neuron_index == -1) {
		//xil_printf("Error: max_neuron_index = %d\n", max_neuron_index);
		return XST_FAILURE;
	}
	else {
		//xil_printf("max_neuron_index = %d\n", max_neuron_index);
		return max_neuron_index;
	}
	/***********************************************************************************************/

	return XST_SUCCESS;
}

// initialize the interrupt controller
XStatus init_intr_ctrl(XIntc *intrc_inst_ptr) {
	u32 status;

	status = XIntc_Initialize(intrc_inst_ptr, intr_ctrl_device_id);

	if(status != XST_SUCCESS) {
		xil_printf("Interrupt controller initialization failed.\n");
		return XST_FAILURE;
	}

	// start the interrupt controller by enabling the output from the controller to processor
	status = XIntc_Start(intrc_inst_ptr, XIN_REAL_MODE);

	if(status != XST_SUCCESS) {
		xil_printf("Failed to start the interrupt controller properly (interface with processor).\n");
		return XST_FAILURE;
	}

	// link the interrupt controller with the operating system
	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XIntc_InterruptHandler, (void *)intrc_inst_ptr);
	Xil_ExceptionEnable();

	return XST_SUCCESS;
}

// configure the DMA controller
XStatus config_dma(XAxiDma *dma) {
	u32 status;
	XAxiDma_Config *dma_config;

	// is dma hardware defined in project?
	dma_config = XAxiDma_LookupConfigBaseAddr(dma_base_addr);
	if (!dma_config) {
		xil_printf("No config found for dma with device id: %d\n", dma_device_id);
		return XST_FAILURE;

	}

	// init dma
	status = XAxiDma_CfgInitialize(dma, dma_config);
	if(status != XST_SUCCESS) {
		xil_printf("DMA initialization failed\n");
		return XST_FAILURE;
	}

	// make sure SG mode is not enabled
	if(XAxiDma_HasSg(dma)) {
		xil_printf("SG cannot be enabled in interrupt mode.\n");
		return XST_FAILURE;
	}

	// DMA self-test
	status = XAxiDma_Selftest(dma);
	if(status != XST_SUCCESS) {
		xil_printf("DMA self-test failed\n");
		return XST_FAILURE;
	}

	// disable all dma interrupts
	XAxiDma_IntrDisable(dma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);

	// enable DMA controller to issue interrupts (Input/Output interrupt are enabled here)
	// XAXIDMA_DEVICE_TO_DMA -> need to catch o_intrrupt signal coming out of neural core
	XAxiDma_IntrEnable(dma, XAXIDMA_IRQ_IOC_MASK, XAXIDMA_DEVICE_TO_DMA);

	return XST_SUCCESS;
}

// enable interrupts and connect interrupt service routines
XStatus enable_interrupts(XIntc *intrc_inst_ptr) {
	Xil_AssertNonvoid(intrc_inst_ptr != NULL);
	Xil_AssertNonvoid(intrc_inst_ptr->IsReady == XIL_COMPONENT_IS_READY);

	u32 status;
	// setup ISR callback for neural core
	status = XIntc_Connect(intrc_inst_ptr, neural_core_irq, (XInterruptHandler)neural_core_ISR, (void *)&dma_inst);

	if(status != XST_SUCCESS) {
		xil_printf("Interrupt controller IRQ connection failed: neural_core_irq.\n");
		return XST_FAILURE;
	}

	// enable neural core to issue interrupts
	XIntc_Enable(intrc_inst_ptr, neural_core_irq);

	// setup ISR callback for DMA
	status = XIntc_Connect(intrc_inst_ptr, dma_irq, (XInterruptHandler)dma_s2mm_ISR, (void *)&dma_inst);

	if(status != XST_SUCCESS) {
		xil_printf("Interrupt controller IRQ connection failed: dma_irq.\n");
		return XST_FAILURE;
	}

	// enable DMA controller to issue interrupts
	XIntc_Enable(intrc_inst_ptr, dma_irq);

	return XST_SUCCESS;
}

void neural_core_ISR(void *callback) {
	// disable interrupt before starting the function
	XIntc_Disable(&intrc_inst, neural_core_irq);

	XIntc_Acknowledge(&intrc_inst, neural_core_irq);
	nc_done = 1;

	xil_printf("neural_core_ISR: done\n");

	// re-enable interrupt before returning
	XIntc_Enable(&intrc_inst, neural_core_irq);
}

void dma_s2mm_ISR(void *callback) {

	u32 irq_status;
	XAxiDma *dma_inst_ptr = (XAxiDma *)callback;

	// read all the pending DMA interrupts
	irq_status = XAxiDma_IntrGetIrq(dma_inst_ptr, XAXIDMA_DEVICE_TO_DMA);

	// acknowledge pending interrupts
	XAxiDma_IntrAckIrq(dma_inst_ptr, irq_status, XAXIDMA_DEVICE_TO_DMA);

	// no interrupts -> exit the handler
	if (!(irq_status & XAXIDMA_IRQ_ALL_MASK)) {
		xil_printf("No interrupts pending for the DMA controller.\n");
		return;
	}

#if 0
	// if error interrupt is asserted, raise error flag, reset hardware to recover from the error
	int timeout;
	if (irq_status & XAXIDMA_IRQ_ERROR_MASK) {
		xil_printf("XAXIDMA_IRQ_ERROR_MASK is asserted; resetting DMA hardware ...\n");
		XAxiDma_Reset(dma_inst_ptr);
		timeout = 1000;
		while (timeout--) {
			if(XAxiDma_ResetIsDone(dma_inst_ptr)) {
				xil_printf("DMA reset done.\n");
				break;
			}
		}
		xil_printf("ch3: dma busy = %d\n", XAxiDma_Busy(dma_inst_ptr,XAXIDMA_DEVICE_TO_DMA));
		return;
	}
#endif

	// if the IO interrupt mask of dma is high and pending -> done
	if ((irq_status & XAXIDMA_IRQ_IOC_MASK)) {
		xil_printf("dma_s2mm_ISR: done\n");
		dma_done = 1;
	}
}
