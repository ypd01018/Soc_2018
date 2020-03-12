#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <math.h>
#include <time.h>
#include "amazon2_sdk.h"
#include "graphic_api.h"
#include "uart_api.h"
#include "robot_protocol.h"
#include "Robotics.h"
#include "robotmotion.h"

#define AMAZON2_GRAPHIC_VERSION		"v0.5"
#define SOURCE_VESION               "v0.1"
#define MADE_DATE                   "2018-07-22"

#include <termios.h>
static struct termios inittio, newtio;
//���� Ŀ�ǵ� �Լ�ȭ
void delay(clock_t n)
{
	clock_t start = clock();
	while (clock() - start < n);
}
void Attack()
{
	Send_Command(0x13, 0xEC);
	delay(700);
	return;
}

void TurnLeft()
{
	Send_Command(0x08, 0xF7);
	return;
}

void TurnRight()
{
	Send_Command(0x09, 0xF6);
	return;
}

void GoStraight()
{
	Send_Command(0x18, 0xE7);
	return;
}

void Kick() {
	Send_Command(0x2A, 0xD5);
	return;
}
void Walk() {
	Send_Command(0x32, 0xCD);
	return;
}
void Ultimate() {
	Send_Command(0x3E, 0xC1);
}
void BackWalk() {
	Send_Command(0x33, 0xCC);
	return;
}
void Quick() {
	Send_Command(0x7B, 0x84);
	return;
}
void init_console(void)
{
    tcgetattr(0, &inittio);
    newtio = inittio;
    newtio.c_lflag &= ~ICANON;
    newtio.c_lflag &= ~ECHO;
    newtio.c_lflag &= ~ISIG;
    newtio.c_cc[VMIN] = 1;
    newtio.c_cc[VTIME] = 0;

    cfsetispeed(&newtio, B115200);

    tcsetattr(0, TCSANOW, &newtio);
}

U16 input[21600] = {0};

int main(void)
{
    short i, j;
    int x, y;
    int r,L_B, L_D, R_B, R_D, g, b, h, s, v;
    short cntBp, cntDp;
    short cnt[3][2] = {0};
    x = y = r = g = b = h = s = v= L_B= L_D= R_B= R_D= cntBp = cntDp = 0;

    int ret;
    if(open_graphic() < 0)return -1;
    direct_camera_display_off();
    clear_screen();
    init_console();
    ret = uart_open();
	uart_config(UART1, 57600, 8, UART_PARNONE, 1);
    if(ret < 0) return EXIT_FAILURE;
    Send_Command(0x01,0xFE);
    while(1)
    {
		delay(700);
		s=r=cnt[0][0] = cnt[0][1] = cnt[1][0] = cnt[1][1] = cnt[2][0] = cnt[2][1]= 0; //���� �ʱ�ȭ
		clear_screen();
		
		read_fpga_video_data(input);
		//ȭ�� ���� 24���
		for (r = 0; r < 4; r++) {
			for (g = 0; g < 6; g++) {
				cntBp = cntDp = 0;//�ʱ�ȭ�� ���� ĭ ������ �� ����
				//ĭ�� 30*30
				for (i = 30 * r; i < 30 * r + 30; i++) {
					for (j = 30 * g; j < 30 * g + 30; j++) {
						//�Ķ� ī����
						if ((input[pos(i, j)] == 0x001F)) {
							cntBp += 1;
						}
						//���� ī����
						else if ((input[pos(i, j)] == 0x0000)) {
							cntDp += 1;
						}
					}
				}
				//ĭ ���� ����,�Ķ� �� ������ ĭ ��ü ħ��
				if (cntBp + cntDp <= 200) {
					for (i = 30 * r; i < 30 * r + 30; i++) {
						for (j = 30 * g; j < 30 * g + 30; j++) {
							input[pos(i, j)] = 0xffff;
						}
					}
				}
				//ĭ ���� �Ķ��� ���� �̻� ������ ĭ ��ü �Ķ�
				else if (cntBp > 150) {
					for (i = 30 * r; i < 30 * r + 30; i++) {
						for (j = 30 * g; j < 30 * g + 30; j++) {
							input[pos(i, j)] = 0x001f;
						}
					}
				}
			}
		}
		//�� �κ� ħ��
		for (i = 0; i < 30; i++) {
			for (j = 0; j < 180; j++) {
				input[pos(i, j)] = 0xffff;
			}
		}
		//�� �κ� ħ�ķ� ���� �� ȭ�� 3��� �� ���� �� �� ī����
		for (i = 30; i < 90; i++) {
			for (j = 0; j < 180; j++) {
				//������
				if (j < 40) {
					if (input[pos(i, j)] == 0x0000) {
						cnt[2][0] += 1;
					}
					if ((input[pos(i, j)] == 0x001F)) {
						cnt[2][1] += 1;
					}
					if ((input[pos(i, j)] == 0xF800)) {
						r += 1;
					}
				}
				//���
				else if (j < 140) {
					if (input[pos(i, j)] == 0x0000) {
						cnt[1][0] += 1;
					}
					if ((input[pos(i, j)] == 0x001F)) {
						cnt[1][1] += 1;
					}
					if ((input[pos(i, j)] == 0xF800)) {
						r += 1;
					}
				}
				//����
				else if (j < 180) {
					if (input[pos(i, j)] == 0x0000) {
						cnt[0][0] += 1;
					}
					if ((input[pos(i, j)] == 0x001F)) {
						cnt[0][1] += 1;
					}
					if ((input[pos(i, j)] == 0xF800)) {
						r += 1;
					}
				}
			}
		}
		if (v == 1) {
			//���� �ŵ� ��Ӵٰ� �����
			if ((cnt[0][0] + cnt[1][0] + cnt[2][0] <= 8000)&&(r<500)){
				printf("bright!\n");
				//��ȸ�� ��ũ��
				if (h < 12) {
					printf("spining\n");
					TurnRight();
					delay(700);
					h++;
					continue;
				}
				//���� �ѹ� �� Ż��
				else {
					printf("Go!\n");
					GoStraight();
					v = 0;
					h = 0;
					continue;
				}
				
			}
		}
		//������ ������ ��ο���
		if ((cnt[0][0] + cnt[1][0] + cnt[2][0] >= 8000)||(r>=500)) {
			Send_Command(0x01, 0xFE);
			printf("Stuned\n");
			v = 1;
			h = 0;
			continue;
		}
		//�� �ϴܺ� ������ ī����
		for (i = 0; i < 45; i++) {
			for (j = 50; j < 130; j++) {
				if (input[pos(i, j)] == 0x0000) {
					s += 1;
				}
			}
		}
		//���� �ھտ� ����
		if (s > 150&&s<400) {
			static int k = 0;
			if (k == 0) {
				Attack();
				k = 1;
			}
			if (k == 1) {
				Quick();
				k = 0;
			}
			printf("enemy in Top");
		}
		//���� ��𿡵� ����
		else if ((MAX3(cnt[0][0], cnt[1][0], cnt[2][0]) < 200) && (MAX3(cnt[0][1], cnt[1][1], cnt[2][1]) < 200)) {
			if (L_B == 1) {
				TurnLeft();
				delay(700);
			}
			else if (R_B == 1) {
				TurnRight();
				delay(700);
			}
			else if (L_D == 1) {
				TurnLeft();
				delay(700);
			}
			else if (R_D == 1) {
				TurnRight();
				delay(700);
			}
			else {
				TurnRight();
				delay(700);
			}
			printf("nothing in there\n");
		}
		//�������� ���ʿ� ���� ���
		else if (MAX3(cnt[0][0], cnt[1][0], cnt[2][0]) == cnt[0][0]) {
			L_B = L_D = R_B = R_D = 0;
			//�Ķ����� ���ʿ� ���� ���
			if (MAX3(cnt[0][1], cnt[1][1], cnt[2][1]) == cnt[0][1]){
				//�������� �Ķ��� �� ��
				if (cnt[0][0] > cnt[0][1]) {
					printf("enemy detected in LEFT!TURN LEFT!\n");
					TurnLeft();
					delay(700);
				    L_D = 1;
				}
				else {
					printf("blue detected in LEFT!TURN LEFT!\n");
					TurnLeft();
					delay(700);
					L_B = 1;
				}
			}
			//�Ķ����� ����� ���� ���
			else if (MAX3(cnt[0][1], cnt[1][1], cnt[2][1]) == cnt[1][1]) {
				if (cnt[0][0] > cnt[1][1]) {
					printf("enemy detected in LEFT!TURN LEFT!\n");
					TurnLeft();
					delay(700);
				    L_D = 1;
				}
				else {
					printf("blue detected in CENTER!GO STRAIGHT!\n");
                    GoStraight();
					delay(700);
				}

			}
			//�Ķ����� �����ʿ� ���� ���
			else if (MAX3(cnt[0][1], cnt[1][1], cnt[2][1]) == cnt[2][1]) {
				if (cnt[0][0] > cnt[2][1]) {
					printf("enemy detected in LEFT!TURN LEFT!\n");
					TurnLeft();
					delay(700);
				    L_D = 1;
				}
				else {
					printf("blue detected in RIGHT!TURN RIGHT!\n");
					TurnRight();
					delay(700);
					R_B = 1;
				}
			}
		}
		//�������� ��� ���� ���
		else if (MAX3(cnt[0][0], cnt[1][0], cnt[2][0]) == cnt[1][0]) {
			L_B = L_D = R_B = R_D = 0;
			//�Ķ����� ���ʿ� ���� ���
			if (MAX3(cnt[0][1], cnt[1][1], cnt[2][1]) == cnt[0][1]) {	
				if (cnt[1][0] > cnt[0][1]) {
					printf("enemy detected in CENTER!Attack!\n");
					Kick();
					delay(700);
					
				}
				else {
					printf("blue detected in LEFT!TURN LEFT!\n");
                   TurnLeft();
				   delay(700);
				   L_B = 1;
				}
			}
			//�Ķ����� ��� ���� ���
			else if (MAX3(cnt[0][1], cnt[1][1], cnt[2][1]) == cnt[1][1]) {
				if (cnt[1][0] > cnt[1][1]) {
					printf("enemy detected in CENTER!Attack!\n");
					Kick();
					delay(700);
				}
				else {
					printf("blue detected in CENTER!GO STRAIGHT!\n");
                    GoStraight();
				}
			}
			//�Ķ����� �����ʿ� ���� ���
			else if (MAX3(cnt[0][1], cnt[1][1], cnt[2][1]) == cnt[2][1]) {
				if (cnt[1][0] > cnt[2][1]) {
					printf("enemy detected in CENTER!Attack!\n");
					Kick();
					delay(700);
				}
				else {
					printf("blue detected in RIGHT!TURN RIGHT!\n");
                   TurnRight();
				   delay(700);
				   R_B = 1;
				}
			}
		}
		//�������� �����ʿ� ���� ���
		else if (MAX3(cnt[0][0], cnt[1][0], cnt[2][0]) == cnt[2][0]) {
			L_B = L_D = R_B = R_D = 0;
			//�Ķ����� ���ʿ� ���� ���
			if (MAX3(cnt[0][1], cnt[1][1], cnt[2][1]) == cnt[0][1]) {
				if (cnt[2][0] > cnt[0][1]) {
					printf("enemy detected in RIGHT!TURN RIGHT!\n");
					TurnRight();
					delay(700);
				    R_D = 1;
				}
				else {
					printf("blue detected in LEFT!TURN LEFT!\n");
                   TurnLeft();
				   delay(700);
				   L_B = 1;
				}
			}
			//�Ķ����� ����� ���� ���
			else if (MAX3(cnt[0][1], cnt[1][1], cnt[2][1]) == cnt[1][1]) {
				if (cnt[2][0] > cnt[1][1]) {
					printf("enemy detected in RIGHT!TURN RIGHT!\n");
					TurnRight();
					delay(700);
				    R_D = 1;
				}
				else {
					printf("blue detected in CENTER!GO STRAIGHT!\n");
					GoStraight();
				}

			}
			//�Ķ����� �����ʿ� ���� ���
			else if (MAX3(cnt[0][1], cnt[1][1], cnt[2][1]) == cnt[2][1]) {
				if (cnt[2][0] > cnt[2][1]) {
					printf("enemy detected in RIGHT!TURN RIGHT!\n");
					TurnRight();
					delay(700);
				    R_D = 1;
				}
				else {
					printf("blue detected in RIGHT!TURN RIGHT!\n");
                   TurnRight();
				   delay(700);
				   R_B = 1;
				}
			}
		}
        draw_fpga_video_data_full(input);
        flip();
    }
    close_graphic();
    uart_close();
    return 0;
}