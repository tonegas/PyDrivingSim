//
// Created by tonegas on 04/04/2019.
//

#include <iostream>
#include <chrono>

template <class T>
void printTableAlign(std::string str, T value, int level){
    int pos = 70;
    std::string line = ">";
    for (int i = 0; i < 2; i++){
        line += " ";
    }
    //if(level != 0){
        for (int i = 0; i < level*2; i++){
            line += " ";
        }
        line += "- ";
    //}
    line += str;
    std::cout << line <<":" ;
    std::cout.width((pos-line.length()-1));
    std::cout << value;
    std::cout.width(81-pos);
    std::cout << "<\n";
}

template <class T>
void printTableAlignError(std::string str, T value, int level, std::string error="WRONG"){
    int pos = 70;
    std::string line = ">";
    for (int i = 0; i < 2; i++){
        line += " ";
    }
    if(level != 0){
        for (int i = 0; i < level*2; i++){
            line += " ";
        }
        line += "- ";
    }
    line += str;
    std::cout << line <<":" ;
    std::cout.width((pos-line.length()-1));
    std::cout << value;
    std::cout.width(81-pos);
    std::cout << error+"!<\n";
}

template <class T>
void printLogVar(int id, std::string message, T var){
    static clock_t start = clock();
    printf("[%10f][%5d] ",(double)(clock() - start) / CLOCKS_PER_SEC,id);
    std::cout << message << " = " << var << "\n";
}