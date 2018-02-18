/*
Used to translate programs to machine code
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* convFromHex(char str[], int length);

int main()
{
    FILE *pf1;
    FILE *pf2;
    int i;
    pf1=fopen("input.txt","r");
    pf2=fopen("output.txt","w");
    char instr[256][17];
    char cons[17];
    strcpy(cons,"0000000000000000");
    for(i=0;i<256;i++){
        strcpy(instr[i],cons);
    }
    int line=-1;
    char str1[16],str2[16],str3[16];
    while(fscanf(pf1,"%s",str1)>0){
        line++;
        if(line>255){
            printf("Error: Too many instructions!");
            getchar();
            exit(1);
        }
        if(strcmp(str1,"jump")==0){
            strcpy(instr[line],"100");
            fscanf(pf1,"%s",str2);
            if((strcmp(str2,"Z")==0)||(strcmp(str2,"NZ")==0)||(strcmp(str2,"C")==0)||(strcmp(str2,"NC")==0)){
                strcat(instr[line],"1");
                fscanf(pf1,"%s",str3);
                strcpy(str3,convFromHex(str3,2));
                if(strcmp(str2,"Z")==0)
                    strcat(instr[line],"00");
                else if(strcmp(str2,"NZ")==0)
                    strcat(instr[line],"01");
                else if(strcmp(str2,"C")==0)
                    strcat(instr[line],"10");
                else if(strcmp(str2,"NC")==0)
                    strcat(instr[line],"11");
                strcat(instr[line],"01");
                strcat(instr[line],str3);
            }
            else{
                strcat(instr[line],"011");
                strcpy(str2,convFromHex(str2,2));
                strcat(instr[line],"01");
                strcat(instr[line],str2);
            }
            instr[line][16]='\0';
        }
        else if(strcmp(str1,"call")==0){
            strcpy(instr[line],"100");
            fscanf(pf1,"%s",str2);
            if((strcmp(str2,"Z")==0)||(strcmp(str2,"NZ")==0)||(strcmp(str2,"C")==0)||(strcmp(str2,"NC")==0)){
                strcat(instr[line],"1");
                fscanf(pf1,"%s",str3);
                strcpy(str3,convFromHex(str3,2));
                if(strcmp(str2,"Z")==0)
                    strcat(instr[line],"00");
                else if(strcmp(str2,"NZ")==0)
                    strcat(instr[line],"01");
                else if(strcmp(str2,"C")==0)
                    strcat(instr[line],"10");
                else if(strcmp(str2,"NC")==0)
                    strcat(instr[line],"11");
                strcat(instr[line],"11");
                strcat(instr[line],str3);
            }
            else{
                strcat(instr[line],"011");
                strcpy(str2,convFromHex(str2,2));
                strcat(instr[line],"11");
                strcat(instr[line],str2);
            }
        }
        else if(strcmp(str1,"return")==0){
            strcpy(instr[line],"100");
            fscanf(pf1,"%s",str2);
            if(strcmp(str2,"UNC")==0)
                strcat(instr[line],"0110010000000");
            else{
                strcat(instr[line],"1");
                if(strcmp(str2,"Z")==0)
                    strcat(instr[line],"00");
                else if(strcmp(str2,"NZ")==0)
                    strcat(instr[line],"01");
                else if(strcmp(str2,"C")==0)
                    strcat(instr[line],"10");
                else if(strcmp(str2,"NC")==0)
                    strcat(instr[line],"11");
                strcat(instr[line],"0010000000");
            }
        }
        else if(strcmp(str1,"returni")==0){
            fscanf(pf1,"%s",str2);
            if(strcmp(str2,"enable")==0)
                strcpy(instr[line],"1000000011110000");
            else
                strcpy(instr[line],"1000000011010000");
        }
        else if(strcmp(str1,"enable")==0){
            fscanf(pf1,"%s",str2);
            if(strcmp(str2,"interrupt")==0)
                strcpy(instr[line],"1000000000110000");
        }
        else if(strcmp(str1,"disable")==0){
            fscanf(pf1,"%s",str2);
            if(strcmp(str2,"interrupt")==0)
                strcpy(instr[line],"1000000000010000");
        }
        else if(strcmp(str1,"load")==0){
            fscanf(pf1,"%s",str2);
            fscanf(pf1,"%s",str3);
            if(str3[0]=='s'){
                strcpy(instr[line],"1100");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3+1,1));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
                strcat(instr[line],"0000");
            }
            else{
                strcpy(instr[line],"0000");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3,2));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
            }
        }
        else if(strcmp(str1,"and")==0){
            fscanf(pf1,"%s",str2);
            fscanf(pf1,"%s",str3);
            if(str3[0]=='s'){
                strcpy(instr[line],"1100");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3+1,1));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
                strcat(instr[line],"0001");
            }
            else{
                strcpy(instr[line],"0001");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3,2));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
            }
        }
        else if(strcmp(str1,"or")==0){
            fscanf(pf1,"%s",str2);
            fscanf(pf1,"%s",str3);
            if(str3[0]=='s'){
                strcpy(instr[line],"1100");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3+1,1));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
                strcat(instr[line],"0010");
            }
            else{
                strcpy(instr[line],"0010");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3,2));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
            }
        }
        else if(strcmp(str1,"xor")==0){
            fscanf(pf1,"%s",str2);
            fscanf(pf1,"%s",str3);
            if(str3[0]=='s'){
                strcpy(instr[line],"1100");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3+1,1));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
                strcat(instr[line],"0011");
            }
            else{
                strcpy(instr[line],"0011");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3,2));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
            }
        }else if(strcmp(str1,"add")==0){
            fscanf(pf1,"%s",str2);
            fscanf(pf1,"%s",str3);
            if(str3[0]=='s'){
                strcpy(instr[line],"1100");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3+1,1));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
                strcat(instr[line],"0100");
            }
            else{
                strcpy(instr[line],"0100");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3,2));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
            }
        }
        else if(strcmp(str1,"addcy")==0){
            fscanf(pf1,"%s",str2);
            fscanf(pf1,"%s",str3);
            if(str3[0]=='s'){
                strcpy(instr[line],"1100");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3+1,1));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
                strcat(instr[line],"0101");
            }
            else{
                strcpy(instr[line],"0101");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3,2));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
            }
        }
        else if(strcmp(str1,"sub")==0){
            fscanf(pf1,"%s",str2);
            fscanf(pf1,"%s",str3);
            if(str3[0]=='s'){
                strcpy(instr[line],"1100");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3+1,1));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
                strcat(instr[line],"0110");
            }
            else{
                strcpy(instr[line],"0110");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3,2));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
            }
        }
        else if(strcmp(str1,"subcy")==0){
            fscanf(pf1,"%s",str2);
            fscanf(pf1,"%s",str3);
            if(str3[0]=='s'){
                strcpy(instr[line],"1100");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3+1,1));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
                strcat(instr[line],"0111");
            }
            else{
                strcpy(instr[line],"0111");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3,2));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
            }
        }
        else if(strncmp(str1,"sr",2)==0||strncmp(str1,"rr",2)==0){
            fscanf(pf1,"%s",str2);
            strcpy(str2,convFromHex(str2+1,1));
            strcpy(instr[line],"1101");
            strcat(instr[line],str2);
            strcat(instr[line],"00001");
            switch(str1[2]){
                case '0':
                    strcat(instr[line],"110");
                    break;
                case '1':
                    strcat(instr[line],"111");
                    break;
                case 'x':
                    strcat(instr[line],"100");
                    break;
                case 'a':
                    strcat(instr[line],"000");
                    break;
                case '\0':
                    strcat(instr[line],"010");
                    break;
            }
        }
        else if(strncmp(str1,"sl",2)==0||strncmp(str1,"rl",2)==0){
            fscanf(pf1,"%s",str2);
            strcpy(str2,convFromHex(str2+1,1));
            strcpy(instr[line],"1101");
            strcat(instr[line],str2);
            strcat(instr[line],"00000");
            switch(str1[2]){
                case '0':
                    strcat(instr[line],"110");
                    break;
                case '1':
                    strcat(instr[line],"111");
                    break;
                case 'x':
                    strcat(instr[line],"100");
                    break;
                case 'a':
                    strcat(instr[line],"000");
                    break;
                case '\0':
                    strcat(instr[line],"010");
                    break;
            }
        }
        else if(strcmp(str1,"input")==0){
            fscanf(pf1,"%s",str2);
            fscanf(pf1,"%s",str3);
            if(str3[0]=='s'){
                strcpy(instr[line],"1011");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3+1,1));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
                strcat(instr[line],"0000");
            }
            else{
                strcpy(instr[line],"1010");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3,2));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
            }
        }
        else if(strcmp(str1,"output")==0){
            fscanf(pf1,"%s",str2);
            fscanf(pf1,"%s",str3);
            if(str3[0]=='s'){
                strcpy(instr[line],"1111");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3+1,1));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
                strcat(instr[line],"0000");
            }
            else{
                strcpy(instr[line],"1110");
                strcpy(str2,convFromHex(str2+1,1));
                strcpy(str3,convFromHex(str3,2));
                strcat(instr[line],str2);
                strcat(instr[line],str3);
            }
        }
        else if(strcmp(str1,"ff")==0){
            fscanf(pf1,"%s",str2);
            strcpy(instr[255],"10001101");
            strcpy(str2,convFromHex(str2,2));
            strcat(instr[255],str2);
            line--;
        }
    }
    for(i=0;i<255;i++){
        fprintf(pf2,"\"%s\", \n",instr[i]);
    }
    fprintf(pf2,"\"%s\"",instr[255]);
    return 0;
}

char* convFromHex(char str[], int length)
{
    char bin[8];
    switch(str[0]){
        case '0':
            strcpy(bin,"0000");
            break;
        case '1':
            strcpy(bin,"0001");
            break;
        case '2':
            strcpy(bin,"0010");
            break;
        case '3':
            strcpy(bin,"0011");
            break;
        case '4':
            strcpy(bin,"0100");
            break;
        case '5':
            strcpy(bin,"0101");
            break;
        case '6':
            strcpy(bin,"0110");
            break;
        case '7':
            strcpy(bin,"0111");
            break;
        case '8':
            strcpy(bin,"1000");
            break;
        case '9':
            strcpy(bin,"1001");
            break;
        case 'A':
            strcpy(bin,"1010");
            break;
        case 'B':
            strcpy(bin,"1011");
            break;
        case 'C':
            strcpy(bin,"1100");
            break;
        case 'D':
            strcpy(bin,"1101");
            break;
        case 'E':
            strcpy(bin,"1110");
            break;
        case 'F':
            strcpy(bin,"1111");
            break;
    }
    if(length>1)
    switch(str[1]){
        case '0':
            strcat(bin,"0000");
            break;
        case '1':
            strcat(bin,"0001");
            break;
        case '2':
            strcat(bin,"0010");
            break;
        case '3':
            strcat(bin,"0011");
            break;
        case '4':
            strcat(bin,"0100");
            break;
        case '5':
            strcat(bin,"0101");
            break;
        case '6':
            strcat(bin,"0110");
            break;
        case '7':
            strcat(bin,"0111");
            break;
        case '8':
            strcat(bin,"1000");
            break;
        case '9':
            strcat(bin,"1001");
            break;
        case 'A':
            strcat(bin,"1010");
            break;
        case 'B':
            strcat(bin,"1011");
            break;
        case 'C':
            strcat(bin,"1100");
            break;
        case 'D':
            strcat(bin,"1101");
            break;
        case 'E':
            strcat(bin,"1110");
            break;
        case 'F':
            strcat(bin,"1111");
            break;
    }
    bin[8]='\0';
    strcpy(str,bin);
    return str;
}
