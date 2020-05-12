/*
 * greyTest.c
 *
 *  Created on: Apr 30, 2020
 *      Author: VIPIN
 */

#include <stdio.h>
#include "xil_io.h"
#include "xparameters.h"
#include "xaxidma.h"
#include "xscugic.h"
#include "xil_cache.h"


#define inputImageWidth 512
#define inputImageHeight 512

#define scale 2

#define outputImageWidth 512/scale
#define outputImageHeight 512/scale

XScuGic IntcInstance;


u32 checkHalted(u32 baseAddress,u32 offset);

char inputImage[inputImageWidth*inputImageHeight*3];
char outputImage[outputImageWidth*outputImageHeight];

int main(){
	XAxiDma myDma;
	u32 status;
	char c;
	XAxiDma_Config *myDmaConfig;
	myDmaConfig = XAxiDma_LookupConfigBaseAddr(XPAR_AXI_DMA_0_BASEADDR);
	status = XAxiDma_CfgInitialize(&myDma, myDmaConfig);
	if(status != XST_SUCCESS){
		print("DMA initialization failed\n");
		return -1;
	}
	//Configure image size converter
	Xil_Out32(XPAR_IMAGESIZECONVERTER_0_S00_AXI_BASEADDR,inputImageWidth);
	Xil_Out32(XPAR_IMAGESIZECONVERTER_0_S00_AXI_BASEADDR+4,inputImageHeight);
	Xil_Out32(XPAR_IMAGESIZECONVERTER_0_S00_AXI_BASEADDR+8,scale);
	Xil_Out32(XPAR_IMAGESIZECONVERTER_0_S00_AXI_BASEADDR+12,scale);

	xil_printf("Input image Buffer address %0x\n\r",inputImage);
	xil_printf("Output image Buffer address %0x\n\r",outputImage);
	xil_printf("Send image and after press enter key\n\r");

	scanf("%c",&c);
	Xil_DCacheInvalidate();
	for(int i=0;i<12;i++)
		xil_printf("%0x\n\r",inputImage[i]);
	status = XAxiDma_SimpleTransfer(&myDma, (u32)outputImage,(outputImageWidth*outputImageHeight),XAXIDMA_DEVICE_TO_DMA);
	if(status != XST_SUCCESS)
		xil_printf("DMA failed\n\r",status);
	status = XAxiDma_SimpleTransfer(&myDma, (u32)inputImage,(inputImageWidth*inputImageHeight*3),XAXIDMA_DMA_TO_DEVICE);
	if(status != XST_SUCCESS)
		xil_printf("DMA failed\n\r",status);
	status = checkHalted(XPAR_AXI_DMA_0_BASEADDR,0x4);
	while(status != 1){
	    status = checkHalted(XPAR_AXI_DMA_0_BASEADDR,0x4);
	}
	status = checkHalted(XPAR_AXI_DMA_0_BASEADDR,0x34);
	while(status != 1){
	    status = checkHalted(XPAR_AXI_DMA_0_BASEADDR,0x34);
	}
	print("DMA transfer success..\n\r");
	/*for(int i=0;i<12;i++)
		xil_printf("%0x\n\r",outputImage[i]);*/
	return 0;
}



u32 checkHalted(u32 baseAddress,u32 offset){
	u32 status;
	status = (XAxiDma_ReadReg(baseAddress,offset))&XAXIDMA_HALTED_MASK;
	return status;
}
