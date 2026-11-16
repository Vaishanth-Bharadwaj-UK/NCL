#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <time.h>

#define BUFFER_SIZE 1024
#define FIFO_PATH "./motor/fifo_encoder_controller"
#define SERIAL_PORT "/dev/serial0"
#define BAUD_RATE 19200

int main(void) {

    double Finp = 0.0;
    char *freq = NULL;
    double Tsample = 0.0;
    char *samp = NULL;
    char buffer[BUFFER_SIZE];

    double Fref = 1.0;
    double I = 0.0;
    double Iold = 0.0;
    double Eold = 0.0;

    double Kp = 140.46;
    double Ki = 1692.29;
    double Kd = 0;
    double Km = 0.013420;
        Kp = Kp/Km;
        Ki = Ki/Km;
        Kd = Kd/Km;

    int count = 0;

        int fd = open(FIFO_PATH, O_RDONLY);
        if(fd == -1) {
                printf("\nError in opening file (fd).\n");
                fflush(stdout);
                exit(EXIT_FAILURE);
        }

        FILE *fp = fdopen(fd,"r");
        if(fp == NULL) {
                printf("\nError in opening file (fp).\n");
                fflush(stdout);
                close(fd);
                exit(EXIT_FAILURE);
        }

        while(fgets(buffer,sizeof(buffer),fp) != NULL) {
                printf("%s",buffer);
                fflush(stdout);
                freq = strtok(buffer," ");
                samp = strtok(NULL,"\n");

        if(freq == NULL || samp == NULL) {
                fprintf(stderr, "\n Mangled buffer: %s\n",buffer);
                continue;
        }

        Finp = atof(freq);
        Tsample = atof(samp);

        if (Tsample <= 0.0) {
            continue;
        }
        if(Finp == 0) {
                if(count <10) {
                        count++;
                        goto next;
                }
        }
        else count = 0;

        double E = Finp - Fref;
        Iold = I;
        I = I + E * Tsample;
        double D = (E - Eold) / Tsample;
        Eold = E;

        double PID = (Kp * E) + (Ki * I) + (Kd * D);

        int Y = (int)(737.0 + PID);
        if (Y < 137) {
                Y = 137;
                I = Iold;
        }
        if (Y > 1337) {
                Y = 1337;
                I = Iold;
        }

        next:

        printf("%d 1\\", Y);
        fflush(stdout);
    }

    fclose(fp);
        printf("Closed\n");
        fflush(stdout);
    return 0;
}