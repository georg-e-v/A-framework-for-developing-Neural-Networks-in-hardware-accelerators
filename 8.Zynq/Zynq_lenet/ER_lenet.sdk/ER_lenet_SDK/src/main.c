/*
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

/*
DATA FORMAT - TRANSMISSION PROTOCOL

HOST-PC:
<SOH><STX>label1<CR>
image1_pixel1<CR>
image1_pixel2<CR>
...
image1_pixel1024<CR>
<ETX>
(wait for Zynq response)
<STX>label2<CR>
image2_pixel1<CR>
image2_pixel2<CR>
...
image2_pixel1024<CR>
<ETX>
(wait for Zynq response)
...
<STX>labeln<CR>
imagen_pixel1<CR>
imagen_pixel2<CR>
...
imagen_pixel1024<CR>
<ETX>
(wait for Zynq response)
<EOT>

ZYNQ RESPONSES:
<ACK> when recognized label matches the true label
<NACK> otherwise
*/

#include <stdio.h>
#include <stdlib.h>
#include "platform.h"
#include "xparameters.h"
#include "xtmrctr.h"		  //Timer
#include "xuartps.h"		  //UART
#include "xactivatenetwork.h" //LeNet

#define IMAGE_DIM 32
#define IMAGE_SIZE (IMAGE_DIM * IMAGE_DIM)
#define TIM_CTR_NUM 0

//UART parsing constants
#define START_CHAR 1	   //SOH
#define IMAGE_START_CHAR 2 //STX
#define SEPARATION_CHAR '\r'
#define IMAGE_END_CHAR 3 //ETX
#define END_CHAR 4		 //EOT
#define ACK_CHAR 6		 //ACK
#define NACK_CHAR 7		 //BEL (used as NACK)

//LeNet
void lenet_init(void);
void lenet_testbench(void);

//UART
void image_receive(void);
void image_parse(void);
void image_respond(uint8_t label_match);

//Timer
uint32_t tim_start(void);
uint32_t tim_stop(void);
double tim_elapsed_time_seconds(uint32_t start_tick, uint32_t end_tick);

uint8_t rx_buf[IMAGE_SIZE * 10];
uint8_t img_buf[IMAGE_SIZE];
uint8_t true_label;
uint32_t img_cnt = 0;

uint8_t images[3][IMAGE_DIM][IMAGE_DIM] = {{{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 64, 138, 34, 0, 0, 0, 0, 0, 0, 0, 0,
											 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24,
											 125, 228, 253, 142, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 68, 254, 253, 253, 253,
											 127, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 13, 120, 254, 255, 254, 254, 254, 34, 0, 0, 0,
											 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 13, 151, 253, 253, 254, 253, 253, 185, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 51, 221, 253,
											 242, 146, 254, 253, 149, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 101, 234, 254, 236, 113,
											 127, 254, 236, 29, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 45, 204, 254, 254, 210, 50, 41, 229, 254,
											 152, 70, 70, 70, 87, 161, 69, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0,
											 0, 0, 0, 9, 55, 138, 245, 253, 248, 139, 38, 64, 190, 253, 254,
											 253, 253, 253, 254, 253, 253, 245, 0, 0, 0, 0, 0, 0},
											{0, 0,
											 0, 0, 0, 0, 15, 166, 253, 253, 254, 253, 249, 207, 237, 253,
											 253, 244, 171, 54, 46, 46, 46, 63, 137, 171, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 195, 253, 253, 253, 254, 202, 160, 128, 94, 245,
											 244, 103, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0,
											 0, 0, 0, 221, 241, 184, 151, 68, 0, 0, 26, 153, 254, 222, 50, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 23,
											 19, 0, 0, 0, 0, 5, 122, 254, 244, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 253, 247, 171, 17, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 51, 224, 253, 210, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 198, 254, 195,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 180, 223, 73, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 25, 25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
										   {{0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 180, 254,
											 255, 179, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 153, 253, 253, 253, 253, 30, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 185,
											 253, 253, 253, 181, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 51, 144, 251, 253, 253, 244, 83, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 139,
											 253, 253, 253, 253, 206, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 201, 253, 253, 253, 127, 35, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 32, 204, 253, 253, 253, 253, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 253, 253, 253, 249, 142, 6,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 247, 253, 253, 253, 142, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 166, 252, 253, 253, 227, 57,
											 78, 78, 92, 231, 96, 78, 42, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0,
											 0, 0, 0, 0, 0, 47, 253, 253, 253, 253, 176, 145, 253, 253, 253, 253,
											 253, 253, 218, 140, 9, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0,
											 0, 47, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253,
											 253, 92, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 47, 253,
											 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 227, 0,
											 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 47, 253, 253, 253, 253,
											 253, 253, 253, 239, 238, 237, 242, 253, 253, 253, 250, 98, 0, 0, 0, 0,
											 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 47, 253, 253, 253, 253, 253, 253,
											 193, 12, 0, 0, 70, 253, 253, 253, 253, 145, 0, 0, 0, 0, 0, 0},
											{0, 0,
											 0, 0, 0, 0, 0, 0, 0, 47, 253, 253, 253, 253, 253, 253, 154, 62, 62, 62,
											 208, 253, 253, 253, 246, 22, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0,
											 0, 0, 47, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253,
											 253, 253, 146, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 47,
											 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 161,
											 53, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 37, 199, 219,
											 253, 253, 253, 253, 253, 253, 253, 253, 253, 250, 128, 7, 0, 0, 0, 0, 0,
											 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 37, 99, 183, 253, 253,
											 253, 253, 253, 253, 117, 93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
										   {{0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 116, 125, 171, 255, 255, 150, 93, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 169, 253,
											 253, 253, 253, 253, 253, 218, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 169, 253, 253, 253, 213, 142, 176, 253,
											 253, 122, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0,
											 0, 0, 0, 0, 52, 250, 253, 210, 32, 12, 0, 6, 206, 253, 140, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0,
											 77, 251, 210, 25, 0, 0, 0, 122, 248, 253, 65, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 31, 18, 0, 0, 0, 0, 209, 253, 253, 65,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 117, 247, 253, 198, 10, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 76, 247, 253, 231, 63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 253, 253, 144, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 176, 246, 253, 159, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25, 234,
											 253, 233, 35, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 198, 253, 253, 141, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 78, 248, 253, 189, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 19, 200, 253, 253, 141, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 134, 253, 253, 173, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 248, 253,
											 253, 25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 248, 253, 253, 43, 20, 20, 20, 20, 5, 0,
											 5, 20, 20, 37, 150, 150, 150, 147, 10, 0, 0, 0},
											{0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 248, 253, 253, 253, 253, 253, 253, 253, 168,
											 143, 166, 253, 253, 253, 253, 253, 253, 253, 123, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 174, 253, 253, 253, 253, 253, 253,
											 253, 253, 253, 253, 253, 249, 247, 247, 169, 117, 117, 57, 0, 0,
											 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 118, 123, 123, 123, 166,
											 253, 253, 253, 155, 123, 123, 41, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0},
											{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}};

uint8_t labels[3] = {4, 6, 2};

//LeNet
XActivatenetwork lenet;
XActivatenetwork_Config *lenet_cfg;

//Timer
XTmrCtr tim;
XTmrCtr_Config tim_cfg;

int main()
{
	init_platform(); // Initializing the system
	lenet_init(); // Initializing the Neural Network

	while (!XActivatenetwork_IsReady(&lenet)); // Waiting until the NN is ready
	XActivatenetwork_Write_input_image_V_Bytes(&lenet, 0, (char *)images[2], IMAGE_SIZE); // Writing NN arguments

	XTmrCtr_Initialize(&tim, XPAR_TMRCTR_0_DEVICE_ID); // Initializing the timer
	uint32_t start_tick = tim_start(); // Getting a start timer tick before the network starts

	XActivatenetwork_Start(&lenet); // Starting the NN
	while (!XActivatenetwork_IsDone(&lenet)); // Polling - Waiting for the NN to finish calculations

	uint32_t end_tick = tim_stop(); // Getting an end timer tick after the NNs ends

	uint8_t label = XActivatenetwork_Get_return(&lenet); // Gathering the NN's output when ready

	double seconds = tim_elapsed_time_seconds(start_tick, end_tick); // Calculating total time elapsed
	printf("Label: %u\n", label);
	printf("LeNet run time in milliseconds: %.3f\n", 1000 * seconds);

	//start LeNet testbench
	while(1) lenet_testbench();

	cleanup_platform();
	return 0;
}

void lenet_init(void)
{
	lenet_cfg = XActivatenetwork_LookupConfig(XPAR_ACTIVATENETWORK_0_DEVICE_ID);
	if (!lenet_cfg)
		printf("Error loading configuration for LeNet\n");

	int status = XActivatenetwork_CfgInitialize(&lenet, lenet_cfg);
	if (status != XST_SUCCESS)
		printf("Error initializing LeNet\n");
}

void lenet_testbench(void)
{
	uint8_t byte_in = 0;
	uint8_t label;

	//wait until transmission start is detected
	while (XUartPs_RecvByte(STDIN_BASEADDRESS) != START_CHAR);

	while (byte_in != END_CHAR)
	{
		byte_in = XUartPs_RecvByte(STDIN_BASEADDRESS);

		//Receive and feed image to LeNet
		if (byte_in == IMAGE_START_CHAR)
		{
			img_cnt++;

			image_receive();
			image_parse();

			//Write LeNet arguments
			while (!XActivatenetwork_IsReady(&lenet));
			XActivatenetwork_Write_input_image_V_Bytes(&lenet, 0, (char *)img_buf, IMAGE_SIZE);

			//Run LeNet
			XActivatenetwork_Start(&lenet);

			//Poll for LeNet
			while (!XActivatenetwork_IsDone(&lenet));

			//Gather output when ready
			label = XActivatenetwork_Get_return(&lenet);

			//Respond with positive acknowledge if the image was correctly recognized
			//or with negative acknowledge if it was incorrectly recognized
			image_respond(label == true_label);
		}
	}
}

void image_receive(void)
{
	uint8_t byte_in;
	uint32_t byte_cnt = 0;

	while (byte_in != IMAGE_END_CHAR)
	{
		byte_in = XUartPs_RecvByte(STDIN_BASEADDRESS);
		rx_buf[byte_cnt++] = byte_in;
	}
}

void image_parse(void)
{
	uint8_t pixel_buf[10];
	uint32_t pixel_buf_ind = 0;
	uint32_t pixel_cnt = 0;

	uint8_t label_buf[10]; //kanonika thelei mono 2 theseis

	uint8_t rx_byte;

	label_buf[0] = rx_buf[0]; //first char received is the label
	label_buf[1] = '\0';
	true_label = strtol((char *)label_buf, NULL, 10);

	//pixels start after label
	for (uint32_t i = 2; rx_buf[i] != IMAGE_END_CHAR; i++)
	{
		rx_byte = rx_buf[i];
		if (rx_byte != SEPARATION_CHAR)
		{
			pixel_buf[pixel_buf_ind++] = rx_byte;
		}
		else
		{
			//number end found
			pixel_buf[pixel_buf_ind] = '\0';
			//reset index for next number
			pixel_buf_ind = 0;

			//convert number to int
			img_buf[pixel_cnt++] = strtol((char *)pixel_buf, NULL, 10);
		}
	}
}

void image_respond(uint8_t label_match)
{
	if (label_match)
		XUartPs_SendByte(STDOUT_BASEADDRESS, ACK_CHAR);
	else
		XUartPs_SendByte(STDOUT_BASEADDRESS, NACK_CHAR);
}

uint32_t tim_start(void)
{
	XTmrCtr_Reset(&tim, TIM_CTR_NUM);
	uint32_t tick = XTmrCtr_GetValue(&tim, TIM_CTR_NUM);
	XTmrCtr_Start(&tim, TIM_CTR_NUM);
	return tick;
}

uint32_t tim_stop(void)
{
	XTmrCtr_Stop(&tim, TIM_CTR_NUM);
	return XTmrCtr_GetValue(&tim, TIM_CTR_NUM);
}

double tim_elapsed_time_seconds(uint32_t start_tick, uint32_t end_tick)
{
	double period = 1.0 / tim.Config.SysClockFreqHz;
	return (double)((end_tick - start_tick) * period);
}
