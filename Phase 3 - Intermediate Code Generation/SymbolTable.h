#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define SIZE 20

typedef struct list {
    int num;
    struct list* next;
} list;

typedef struct DataItem {
    char* type;   //Keyword or identifier
    char* name;  
    char* datatype;
    char* value;
    list* line;
} DataItem;

DataItem* hashArray[SIZE]; 

int hashCode(char* name) {
    return strlen(name) % SIZE;
}

void disp_line(list *l) {
    list* p=l;
    printf("[%d",l->num);
    while(p->next!=NULL) {
        p=p->next;
        printf(",%d",p->num);
    }
    printf("]\n");
    return;
}

void display_symbol() {
    int i = 0;
    printf("-------------------------------------------------\n");
    printf("TYPE \t TOKEN \t DATATYPE \t VALUE \t LINE NO.\n");
    printf("-------------------------------------------------\n");
    for(i = 0; i<SIZE; i++) {
        if(hashArray[i] != NULL) {
            printf("%-9s%-8s%-16s%-8s",hashArray[i]->type,hashArray[i]->name,hashArray[i]->datatype,hashArray[i]->value);
            disp_line(hashArray[i]->line);
        }
    }
    printf("\n");
}

DataItem *search(char* name) {
    int hashIndex = hashCode(name);  
    while(hashArray[hashIndex] != NULL) {
        if(!strcmp(hashArray[hashIndex]->name,name))
            return hashArray[hashIndex]; 
        ++hashIndex;
        hashIndex %= SIZE;
    }        
    return NULL;        
}

list* line_init(int line) {
    list *item = (list*)malloc(sizeof(list));
    item->num=line;
    item->next=NULL;
    return item;
}

char* string_init(char* str) {
    if(str==NULL)
        return NULL;
    char* new = (char*)malloc(sizeof(strlen(str)+1));
    strcpy(new,str);
    return new;
}

void line_insert(list* l, int line) {
    list* p=l;
    while(p->next!=NULL) {
        p=p->next;
    }
    p->next=line_init(line);
    return;
}

void insert_exist(DataItem* item, char* datatype, char* value, int line) {
    char* name=string_init(item->name);
    int hashIndex = hashCode(name);
    while(hashArray[hashIndex] != NULL) {
        if(!strcmp(hashArray[hashIndex]->name,name)) {
        	if(hashArray[hashIndex]->value!=NULL && value!=NULL)
            	strcpy(hashArray[hashIndex]->value,value);
            else if(value==NULL) {
                free(hashArray[hashIndex]->value);
                hashArray[hashIndex]->value = NULL;
            }
            else {
                hashArray[hashIndex]->value = string_init(value);
            }

            if(hashArray[hashIndex]->datatype!=NULL && datatype!=NULL)
            	strcpy(hashArray[hashIndex]->datatype,datatype);
            else if(datatype==NULL) {
                free(hashArray[hashIndex]->datatype);
                hashArray[hashIndex]->datatype = NULL;
            } else {
                hashArray[hashIndex]->datatype = string_init(datatype);
            }
            
            if(line!=-1)
                line_insert(item->line,line);
            return;
        }
        ++hashIndex;
        hashIndex %= SIZE;
    }      
}

void insert(char* type, char* name, char* datatype, char* value, int line) {
    DataItem* seek = search(name);
    if(seek!=NULL) {
        insert_exist(seek,datatype,value,line);
        return;    
    }
    DataItem *item = (DataItem*) malloc(sizeof(DataItem));
    item->type=string_init(type);
    item->name=string_init(name);
    item->datatype=string_init(datatype);
    item->value=string_init(value);
    item->line=line_init(line);
    
    int hashIndex = hashCode(name);
    while(hashArray[hashIndex] != NULL && hashArray[hashIndex]->name != NULL) {
        ++hashIndex;
        hashIndex %= SIZE;
    }
    hashArray[hashIndex] = item;
}

DataItem* del(DataItem* item) {
    char* name=string_init(item->name);
    int hashIndex = hashCode(name);
    while(hashArray[hashIndex] != NULL) {
        if(!strcmp(hashArray[hashIndex]->name,name)) {
            DataItem* temp = hashArray[hashIndex]; 
            hashArray[hashIndex]=NULL;
            return temp;
        }
        ++hashIndex;
        hashIndex %= SIZE;
    }      
    return NULL;
}
