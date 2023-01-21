//
// Created by tonegas on 04/04/2019.
//

#include <stdio.h>
#include <string.h>
#include <time.h>
#include "screen_print_c.h"
#define LINE_SIZE 80

void printLine(){
    printf("================================================================================\n");
}

void printAgent(int versionMajor, int versionMinor, int versionInterfaces){
    printf(
             "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
             "                      ______          __     _                   \n"
             "                     / ____/___  ____/ /____(_)   _____  _____   \n"
             "                    / /   / __ \\/ __  / ___/ / | / / _ \\/ ___/ \n"
             "                   / /___/ /_/ / /_/ / /  / /| |/ /  __/ /       \n"
             "                   \\____/\\____/\\__,_/_/  /_/ |___/\\___/_/    \n"
             "\n"
    );
    printAgentVersion(versionMajor,versionMinor,versionInterfaces);
    printf(
             ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
    );
    fflush(stdout);
}

void printCenter(const char* str){
    printf("%*s\n",(int)(LINE_SIZE / 2 + strlen(str) / 2), str );
    fflush(stdout);
}

void printAgentVersion(int versionMajor, int versionMinor, int versionInterfaces){
    printf("Agent version: %d.%d.%d\n",versionMajor,versionMinor,versionInterfaces );
    fflush(stdout);
}

void printError(const char * str){
    fprintf(stderr, "%.*s\n", LINE_SIZE, "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    fprintf(stderr, "%s\n", str);
    fprintf(stderr, "%.*s\n", LINE_SIZE, "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
}

void printInputSection(const char * str){
    printf("== %s %.*s \n",str,(int)(LINE_SIZE-strlen(str)-4),"================================================================================");
    fflush(stdout);
}

void printTableSection(const char * str){
    printf(">-- %s %.*s<\n" , str,(int)(LINE_SIZE - strlen(str) - 6), "--------------------------------------------------------------------------------");
    fflush(stdout);
}

void printTable(const char * str, int level){
    printf("> %*c%c %s %.*s<\n",(int)(level*2+1),' ','-',str,(int)(LINE_SIZE-strlen(str)-level*2-7),"                                                                                ");
    fflush(stdout);
}

//float calc_time_spent(std::chrono::system_clock::time_point start){
//    auto now = std::chrono::system_clock::now();
//    std::chrono::duration<double> diff = now - start;
//    return (float)diff.count();
//}

void printLog(int id, const char * message){
    static clock_t start = 0;
    if (start == 0) {
        start = clock();
    }
    printf("[%10f] %s\n",(double)(clock() - start) / CLOCKS_PER_SEC, message);
    fflush(stdout);
}

void printLogTitle(int id, const char * message){
    static clock_t start = 0;
    if (start == 0) {
        start = clock();
    }
    printf("[%10f][%5d] ",(double)(clock() - start) / CLOCKS_PER_SEC,id);
    printf("------------------%*s%*s------------------\n",(int)(12+strlen(message)/2),message,(int)(12-strlen(message)/2),"");
    fflush(stdout);
}


