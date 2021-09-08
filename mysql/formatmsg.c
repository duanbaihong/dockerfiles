#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<sys/ioctl.h>
#include<termios.h>
#include<signal.h>
#include<unistd.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

struct winsize info;
int fd;

void outtitle(unsigned short cols)
{
    char title[cols];
    for(int i=0; i<cols; i++){
        title[i]='#';
    }
    title[cols]='\0';
    fprintf(stdout,"%s\n",title);
}

int main(int argc,char *argv[]){
    fd = open("/dev/stdout",O_RDWR);
    ioctl(fd,TIOCGWINSZ,&info);
    char *argvstr=argv[1];
    if(argvstr)
    {
        if (!strcasecmp(argvstr,"title"))
        {
            outtitle(info.ws_col);
        }
        else if(!strcasecmp(argvstr,"help"))
        {
            outtitle(info.ws_col);
            fprintf(stdout,"Example:\n");
            fprintf(stdout,"\t%s title; \t\t\tprint title.\n",argv[0]);
            fprintf(stdout,"\t%s status [0|1]; \t\tprint return status and return format string.\n",argv[0]);
            fprintf(stdout,"\t%s help; \t\t\tprint helps;\n\n",argv[0]);
        }
        else if(!strcasecmp(argvstr,"status"))
        {
            int status= atoi(argv[2]);
            if(status==0)
            {
                fprintf(stdout,"[  \033[32mOK\033[0m  ]\n");
            }else
            {
                fprintf(stdout,"[\033[31mFailed\033[0m]\n");
            }
        }
        else
        {
            fprintf(stdout,"%-*s",info.ws_col-8,argv[1]);

        }
        
    }else
    {
        fprintf(stdout,"No parameters passed.\n");
        return 1;
    }
    return 0;
}