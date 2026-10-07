/**
  Generated Main Source File

  Company:
    Microchip Technology Inc.

  File Name:
    main.c

  Summary:
    This is the main file generated using PIC10 / PIC12 / PIC16 / PIC18 MCUs

  Description:
    This header file provides implementations for driver APIs for all modules selected in the GUI.
    Generation Information :
        Product Revision  :  PIC10 / PIC12 / PIC16 / PIC18 MCUs - 1.81.8
        Device            :  PIC16F15323
        Driver Version    :  2.00
*/

/*
    (c) 2018 Microchip Technology Inc. and its subsidiaries. 
    
    Subject to your compliance with these terms, you may use Microchip software and any 
    derivatives exclusively with Microchip products. It is your responsibility to comply with third party 
    license terms applicable to your use of third party software (including open source software) that 
    may accompany Microchip software.
    
    THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER 
    EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY 
    IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS 
    FOR A PARTICULAR PURPOSE.
    
    IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE, 
    INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND 
    WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP 
    HAS BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO 
    THE FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL 
    CLAIMS IN ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT 
    OF FEES, IF ANY, THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS 
    SOFTWARE.
*/

#include "mcc_generated_files/mcc.h"

/*
                         Main application
 */
void main(void)
{
    uint8_t count;
    uint16_t convertedValue;        //variable for storing ADC result
    
    // initialize the device
    SYSTEM_Initialize();

    // When using interrupts, you need to set the Global and Peripheral Interrupt Enable bits
    // Use the following macros to:

    // Enable the Global Interrupts
    //INTERRUPT_GlobalInterruptEnable();

    // Enable the Peripheral Interrupts
    //INTERRUPT_PeripheralInterruptEnable();

    // Disable the Global Interrupts
    //INTERRUPT_GlobalInterruptDisable();

    // Disable the Peripheral Interrupts
    //INTERRUPT_PeripheralInterruptDisable();
        LED1_SetLow();
        LED2_SetHigh();
        LED3_SetLow();
        LED4_SetHigh();
        LED5_SetLow();
        LED6_SetHigh();
        LED7_SetLow();
        LED8_SetHigh();
        __delay_ms(500);
        LED1_SetHigh();
        LED2_SetLow();
        LED3_SetHigh();
        LED4_SetLow();
        LED5_SetHigh();
        LED6_SetLow();
        LED7_SetHigh();
        LED8_SetLow();
        __delay_ms(500);
        
        ADC_SelectChannel(5);       //use ADC channel 5 (pin 2)
        
    while (1)
    {
        // Add your application code
        ADC_StartConversion();                          //read value of potentiometer (ADC range is between 0 and 1023)
        while(ADC_IsConversionDone());                  //wait for result
        convertedValue = ADC_GetConversionResult();     //store value from ADC into variable
        count = convertedValue / 20;	//count = sound level / cal, increment count for every 0.1v analogue input voltage
        
        if (count > 8)			//if count > 8 light all LEDs
        count = 8;

    switch (count)			//switch on count value to illuminate 8 leds
        {
	case 0:
	{PORTA=0b00010100;
	 PORTC=0b00111111;
	 break;}
	case 1:
	{PORTA=0b00010100;
	 PORTC=0b00111110;
	 break;}
	case 2:
	{PORTA=0b00010100;
	 PORTC=0b00111100;
	 break;}
	case 3:
	{PORTA=0b00010100;
	 PORTC=0b00111000;
	 break;}
	case 4:
	{PORTA=0b00010100;
	 PORTC=0b00110000;
	 break;}
    case 5:
	{PORTA=0b00010100;
	 PORTC=0b00100000;
	 break;}
	case 6:
	{PORTA=0b00010100;
	 PORTC=0b00000000;
	 break;}
	case 7:
	{PORTA=0b00010000;
	 PORTC=0b00000000;
	 break;}
	case 8:
	{PORTA=0b00000000;
	 PORTC=0b00000000;
	 break;}
	default:
	{PORTA=0b00010100;
	 PORTC=0b00111111;
	break;}
	}
    }
}
/**
 End of File
*/