#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <pthread.h>
#include <poll.h>
#include <time.h>

#define FIFO_PATH "./motor/fifo_motor_encoder"
#define DATA_FILE_PATH "./motor/encoder_samples.dat"
#define OUTPUT_FIFO_PATH "./motor/fifo_encoder_controller"
#define BUFFER_SIZE 1024
#define ENCODER_CUTS 500
#define FREQ_TIMER 20000

char buffer[BUFFER_SIZE];
char buffer_init[BUFFER_SIZE];

int retless = 0;
int do_nothing = 1;
int turn_inc = 0;
double timestamp_val = 0.0f;
double timestamp_init_val = 0.0f;
int edge_val = 0;
int gpio_val = 0;
int edge_flag = 0;
int dir = 0;
int dir_temp = 0;
float freq = 0.0f;
int fd_enc;
int fd_fifo;
int thread_flag = 1;
int read_thread_run = 0;
int ret = 0;
int ret_freq = 0;

pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

int find_dir(void) {
        //printf("\n --STARTING FIND_DIR-- \n");
        //fflush(stdout);

        if(edge_val==1) {
                edge_flag = 0;
                dir_temp = 0;
        }
        if(edge_val==2) {
                if(edge_flag == 1) {
                        dir_temp -= gpio_val;
                        return dir_temp;
                }
                else {
                        dir_temp += gpio_val;
                        edge_flag = 1;
                }
        }
        return (freq == 0)? 0:dir;
}

void *find_freq_func(void *arg) {

        while(thread_flag == 1) {
                do_nothing = 1;
        }

        printf("\n --STARTING FIND_FREQ_FUNC-- \n");
        fflush(stdout);
        fd_enc = open(DATA_FILE_PATH, O_WRONLY | O_CREAT | O_TRUNC, 0644);
        fd_fifo = open(OUTPUT_FIFO_PATH, O_WRONLY | O_CREAT | O_TRUNC, 0644);
        int turn_inc_temp = 0;
        int ret_temp = 0;
        int read_thread_run_temp = 0;
        double timestamp_val_temp = 0.0f;
        struct timespec ts;

        while(thread_flag != 1) {
                usleep(FREQ_TIMER);

                //printf("\n --RUN FREQ CALC-- \n");
                //fflush(stdout);

                pthread_mutex_lock(&lock);

                clock_gettime(CLOCK_MONOTONIC, &ts);
                read_thread_run_temp = read_thread_run;
                ret_temp = ret_freq;
//              printf("|%d - %d|",read_thread_run_temp,ret_temp);
//              fflush(stdout);
                timestamp_val_temp = timestamp_val;
                turn_inc_temp = turn_inc;

                turn_inc = 0;
                read_thread_run = 0;

                pthread_mutex_unlock(&lock);

                if(read_thread_run_temp == 1) {
//                      printf("\n --CALCULATING FREQUENCY-- \n");
//                      fflush(stdout);
                        if((ret_temp == 0 && turn_inc_temp == 0)) {
                                if(timestamp_init_val == timestamp_val_temp || retless > 9) {
                                        timestamp_val_temp = ts.tv_sec + (ts.tv_nsec / 1e9);
                                        freq = ((((float)turn_inc_temp)/(ENCODER_CUTS*4.0f))/((float)(timestamp_val_temp - timestamp_init_val)));
//                                      printf("OUTPUT (0): %f %.4f %d %d %f\n",timestamp_val_temp, freq, dir, turn_inc_temp, timestamp_val_temp-timestamp_init_val);
//                                      fflush(stdout);
                                        dprintf(fd_enc, "%f %.4f %d %f\n",timestamp_val_temp, freq, dir, (timestamp_val_temp - timestamp_init_val));
                                        dprintf(fd_fifo, "%.4f %f\n", freq, (timestamp_val_temp - timestamp_init_val));
                                        timestamp_init_val = timestamp_val_temp;
                                }
                                else {
                                        //printf("IGNORED\n");
                                        //fflush(stdout);
//                                      pthread_mutex_unlock(&lock);
//                                      continue;
                                        do_nothing = 1;
                                }
                        }
                        else {
                                if(timestamp_init_val < timestamp_val_temp) {
                                        freq = ((((float)turn_inc_temp)/(ENCODER_CUTS*4.0f))/((float)(timestamp_val_temp - timestamp_init_val)));
//                                      printf("OUTPUT (1): %f %.4f %d %d %f\n",timestamp_val_temp, freq, dir, turn_inc_temp, timestamp_val_temp-timestamp_init_val);
//                                      fflush(stdout);
                                        dprintf(fd_enc, "%f %.4f %d %f\n",timestamp_val_temp, freq, dir,(timestamp_val_temp - timestamp_init_val));
                                        dprintf(fd_fifo, "%.4f %f\n", freq, (timestamp_val_temp - timestamp_init_val));
                                        timestamp_init_val = timestamp_val_temp;
                                }
                                else {
                                        do_nothing = 1;
                                }
                        }

                        //printf("\n--------\nFrequency: %.4f Hz | Direction: %d\n--------\n", freq, dir);
                        //fflush(stdout);

                        //printf("\n --RESET TURNS-- \n turn_inc: %d \n --SLEEP-- \n",turn_inc);
                        //fflush(stdout);
                }
                else {
                        printf("\n BYPASSED \n");
                        fflush(stdout);
                        pthread_mutex_unlock(&lock);
                }
        }

        printf("\n --STOPPING FIND_FREQ_FUNC-- \n");
        fflush(stdout);
        close(fd_enc);

        pthread_mutex_unlock(&lock);

        exit(EXIT_SUCCESS);
}


void *inc_func(void *arg) {
        printf("\n --STARTING INC_FUNC-- \n");
        fflush(stdout);

        buffer[0] = '\0';
        buffer_init[0] = '\0';

        int fd;
        fd = open(FIFO_PATH, O_RDONLY | O_NONBLOCK);
        if(fd == -1) {
                close(fd);
                printf("\nError in opening file (fd).\n");
                //printf("%d",EXIT_FAILURE);
                fflush(stdout);

                thread_flag = 1;
                return NULL;
        }

        FILE *fp = fdopen(fd,"r");
        if(fp == NULL) {
                printf("Error in opening file (fp).\n");
                fflush(stdout);
                fclose(fp);

                thread_flag = 1;
                return NULL;
        }

        printf("\nFIFO: MOTOR-ENCODER ACTIVE\n");
        fflush(stdout);

        struct pollfd pfd;
        pfd.fd = fd;
        pfd.events = POLLIN;

        int flag = 0;
        int prev_gpio_val = 0;

        printf("\n --INIT READ-- \n");
                fflush(stdout);

        while(flag != 1) {
                ret = poll(&pfd,1,1);
//              printf("%d",ret);
//              fflush(stdout);
                if(ret>0 && (pfd.revents & POLLIN)) {
                        if((fgets(buffer_init, sizeof(buffer_init), fp)) != NULL) {
//                              printf("Buffer_INIT: %s",buffer_init);
//                              fflush(stdout);
                                char *timestamp_init = strtok(buffer_init, " ");
                                if(timestamp_init == NULL) {
                                        printf("\n Mangled Buffer \n");
                                        fflush(stdout);
                                        thread_flag = 1;
                                        exit(EXIT_FAILURE);
                                }
                                timestamp_init_val = atof(timestamp_init); //printf("%f timestamp_init_val\n",timestamp_init_val);
                        }
                        else {
                                printf("\n --INIT READ ERROR--\n");
                                fflush(stdout);
                                read_thread_run = 0;
                                thread_flag = 1;
                                exit(EXIT_FAILURE);
                        }
                        flag = 1;
                        prev_gpio_val = gpio_val;
                }
                else if(ret == 0) {
                        printf("\n --INIT READ - BUFFER EMPTY-- \n");
                        fflush(stdout);
                }
                else {
                        printf("\n --INIT READ FAILED-- \n");
                        //printf("%d",EXIT_FAILURE);
                        fflush(stdout);

                        thread_flag = 1;
                        exit(EXIT_FAILURE);
                }
        }

        printf("\n --STARTING LOOP READ-- \n");
        fflush(stdout);

        char *timestamp = NULL;
        char *edge = NULL;
        char *gpio = NULL;

//      printf("%d",ret);
//      fflush(stdout);

        ret = poll(&pfd,1,-1);

        thread_flag = 0;
        while(1) {
                if(ret>0 && (pfd.revents & POLLIN)) {
                        if((fgets(buffer, sizeof(buffer), fp)) != NULL) {
//                              printf("\n Buffer: %s \n",buffer);
//                              fflush(stdout);
                                retless = 0;
                                timestamp = strtok(buffer, " ");
                                edge = strtok(NULL, " ");
                                gpio = strtok(NULL, "\n");
                                if(timestamp == NULL || edge == NULL || gpio == NULL) {
                                        printf("\n Mangled Buffer: %s \n",buffer);
                                        fflush(stdout);
                                        thread_flag = 1;
                                        break;
                                }
                        }
                        else {
                                retless = 0;
                                thread_flag = 1;
                                printf("\n --LOOP READ ERROR--\n");
                                fflush(stdout);
                        }
                }
                else if(ret == 0) {
                        retless++;
                }
                else {
                        thread_flag = 1;
                        printf("\n --LOOP READ - BUFFER EMPTY-- \n");
                        fflush(stdout);
                        break;
                }

                pthread_mutex_lock (&lock);

//              ret_freq = ret;
                read_thread_run = 1;

                if(retless>=10) {
                        pthread_mutex_unlock(&lock);
                        while(ret >= 0) {
                                usleep(FREQ_TIMER/2000);
                                pthread_mutex_lock(&lock);
                                read_thread_run = 1;
                                pthread_mutex_unlock(&lock);
                                ret = poll(&pfd,1,0);
                                if(ret > 0 && (pfd.revents & POLLIN)) {
                                        retless = 0;
                                        pthread_mutex_lock(&lock);
                                        goto next;
                                }
                        }
                        goto yeet;
                }

                if(ret == 1) {
                        if(prev_gpio_val != gpio_val) {
                                dir = find_dir();
                        }
                        turn_inc++;
                        prev_gpio_val = gpio_val;
                        timestamp_val = atof(timestamp); //printf("%f timestamp_val\n",timestamp_val);
                        edge_val = atoi(edge); //printf("%d edge_val\n",edge_val);
                        gpio_val = atoi(gpio); //printf("%d gpio_val\n",gpio_val);
                }
                else {
//                      dir = 0;
                        edge_val = 0;
                        gpio_val = 0;
                }

                ret = poll(&pfd,1,FREQ_TIMER/2000);
                next:
                        ret_freq = ret;

                pthread_mutex_unlock(&lock);

//              printf("%d",ret);
//              fflush(stdout);

//              usleep(1);
        }

        yeet:
                printf("\n --STOPPING LOOP READ-- \n");
                fflush(stdout);

                fclose(fp);
                printf("\nFile closed.\n");
                //printf("%d",EXIT_SUCCESS);
                fflush(stdout);

                thread_flag = 1;

                return NULL;
}


int main(void) {
        printf("\n --MAIN-- \n");
        fflush(stdout);

        pthread_t t1, t2;

//      struct sched_param param;

        pthread_create(&t1, NULL, inc_func, NULL);
        pthread_create(&t2, NULL, find_freq_func, NULL);

//      param.sched_priority = 10;
//      pthread_setschedparam(t1, SCHED_FIFO, &param);

//      param.sched_priority = 30;
//      pthread_setschedparam(t2, SCHED_FIFO, &param);

        pthread_join(t1, NULL);
        pthread_join(t2, NULL);

        return 0;
}