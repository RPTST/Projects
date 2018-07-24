#include <wiringPi.h> 
#include <wiringPiI2C.h> 
#include <stdio.h> 
#include <stdlib.h> 

int main( int argc, char *argv[]) {

  printf ("RPi - RDA5807SP FM Tuner v0.1 \n") ;

  unsigned char radio[5] = {0};
  unsigned char mine[5] = {0};
  int fd;
  int dID = 0x60; // i2c Channel the device is on
  unsigned char frequencyH = 0;
  unsigned char frequencyL = 0;
  unsigned int frequencyB;

  //read the frequency from the command line
  double frequency = strtod(argv[1],NULL);

  //should the radio be muted?
  int muted = strtod(argv[2],NULL);

  frequencyB=4*(frequency*1000000+225000)/32768; //calculating PLL word

  frequencyH=frequencyB>>8;

  frequencyL=frequencyB&0XFF;

  printf ("Frequency = "); printf("%f",frequency);

  printf("\n"); // data to be sent

  if(muted==1){
	frequencyH=0x80;
  }
  radio[0]=frequencyH; //FREQUENCY H
  radio[1]=frequencyL; //FREQUENCY L
  radio[2]=0xB0; //3 byte (0xB0): high side LO injection is on,. 
  radio[3]=0x10; //4 byte (0x10) : Xtal is 32.768 kHz 
  radio[4]=0x00; //5 byte0x00)

  if((fd=wiringPiI2CSetup(dID))<0){
    printf("error opening i2c channel\n\r");
  }

  write (fd, (unsigned int)radio, 5) ;
  
  //read(fd,mine,5);
  //printf("r0 %u\n",radio[0]);
  //printf("m0 %u\n",mine[0]);
  //printf("r1 %u\n",radio[1]);
  //printf("m1 %u\n",mine[1]);
  //printf("r2 %u\n",radio[2]);
  //printf("m2 %u\n",mine[2]);
  //printf("r3 %u\n",radio[3]);
  //printf("m3 %u\n",mine[3]);
  //printf("r4 %u\n",radio[4]);
  //printf("m4 %u\n",mine[4]);
  
  close(fd);
  return 0;
}
