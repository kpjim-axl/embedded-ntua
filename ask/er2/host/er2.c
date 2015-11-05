#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <errno.h>
#include <termios.h>
#include <string.h>

#define SERIALDEVICE "/dev/pts/2"
#define BRATE B9600

int main(void){
	struct termios oldtty, newtty;
	int ttyfd, i=0;
	char *inp = malloc(64*sizeof(char));
	char c;
	
	ttyfd = open(SERIALDEVICE, O_RDWR | O_NOCTTY);
	if (ttyfd < 0){
		perror(SERIALDEVICE);
		exit(-1);
	}
	
	/* Prepare serial port for write-read */
	tcgetattr(ttyfd, &oldtty);			// save current port settings
	memset(&newtty, 0, sizeof(newtty));		// initiate newtty with 0s
	newtty.c_cflag = BRATE | CS8 | CLOCAL | CREAD;
	newtty.c_iflag = IGNPAR | ICRNL;
	newtty.c_oflag = 0;
	newtty.c_lflag = 0;	// theloume non-canonical input (e3hgw para katw gt)
	
	/* ola ta ypoloipa einai hdh 0 apo to memset */
	newtty.c_cc[VEOF] = 4;
	newtty.c_cc[VMIN] = 1;
	
	/* clear serial port line and activate */
	tcflush(ttyfd, TCIFLUSH);
	tcsetattr(ttyfd, TCSANOW, &newtty);
	
	/* diavase to poly 63 charakthres (sto telos nc) */
	i = read(1, inp, 63);
	inp[i+1]='\0';

	/* grapse thn eisodo sth serial port */
	write(ttyfd, inp, 64);
	
	/* katharise th serial kai perimene 1sec */
	tcflush(ttyfd, TCIFLUSH);
	
	/* diavase mexri na synanthseis '\0' kai to poly 64 chars. Vasika to mynhma einai akoma mikrotero */
	/* tha diavazoume char-char se non canonical mode, gt an htan canonical tha stamatouse sto '\n'
	 * twra mporei na diavasei kai thn allagh grammhs wste na typwsei to mynhma swsta! */
	for (i=0; i<64; i++){
		read(ttyfd, &inp[i], 1);
		if (inp[i] == '\0')
			break;
	}
	
	printf("%s", inp);
	
	tcsetattr(ttyfd, TCSANOW, &oldtty);
	return 0;
}