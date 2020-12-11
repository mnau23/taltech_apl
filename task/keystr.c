#include <stdio.h>
#include <string.h>
#include <sys/time.h>

int main(){
	struct timeval start, stop;
	int breakc, casec, constc, continuec, doc, doublec, elsec, forc, ifc, intc, switchc, whilec, varc, numc;
	breakc=casec=constc=continuec=doc=doublec=elsec=forc=ifc=intc=switchc=whilec=varc=numc=0;
	char buf[50];
	int i, isnum, isvar;

	gettimeofday(&start, NULL);

	while(!feof(stdin)){
		if(fscanf(stdin, "%s", buf) == 0)
			break;
		if(strcmp(buf, "break") == 0){
			breakc++;
			continue;
		}
		if(strcmp(buf, "case") == 0){
			casec++;
			continue;
		}
		if(strcmp(buf, "const") == 0){
			constc++;
			continue;
		}
		if(strcmp(buf, "continue") == 0){
			continuec++;
			continue;
		}
		if(strcmp(buf, "do") == 0){
			doc++;
			continue;
		}
		if(strcmp(buf, "double") == 0){
			doublec++;
			continue;
		}
		if(strcmp(buf, "else") == 0){
			elsec++;
			continue;
		}
		if(strcmp(buf, "for") == 0){
			forc++;
			continue;
		}
		if(strcmp(buf, "if") == 0){
			ifc++;
			continue;
		}
		if(strcmp(buf, "int") == 0){
			intc++;
			continue;
		}
		if(strcmp(buf, "switch") == 0){
			switchc++;
			continue;
		}
		if(strcmp(buf, "while") == 0){
			whilec++;
			continue;
		}
		isnum = isvar = 0;
		if(buf[0] >= '0' && buf[0] <= '9')
			isnum = 1;
		if(buf[0] >= 'a' && buf[0] <= 'z')
			isvar = 1;
		for(i = 0; i < strlen(buf); i++)
			if(buf[i] >= 'a' && buf[0] <= 'z')
				isnum = 0;
		if(isnum)
			numc++;
		if(isvar)
			varc++;
	}

	gettimeofday(&stop, NULL);
	
	double sec = stop.tv_sec + (stop.tv_usec/1000000.0) - (start.tv_sec + start.tv_usec/1000000.0);

	printf("Time\t%12.6f\n", sec);
	printf("break:%d case:%d const:%d continue:%d do:%d double:%d else:%d for:%d if:%d int:%d switch:%d while:%d var:%d numc:%d\n", breakc, casec, constc, continuec, doc, doublec, elsec, forc, ifc, intc, switchc, whilec, varc, numc);
	
	return 0;
}
