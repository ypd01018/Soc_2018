'Made by Minsang
'Date : 2018-07-26
'�⺻ ���α׷� Ʋ ����

'RX_EXIT
'GOSUB_RX_EXIT

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM ����ӵ� AS BYTE
DIM �¿�ӵ� AS BYTE
DIM �¿�ӵ�2 AS BYTE
DIM ������� AS BYTE
DIM �������� AS BYTE
DIM ����üũ AS BYTE
DIM ����ONOFF AS BYTE
DIM ���̷�ONOFF AS BYTE
DIM ����յ� AS INTEGER
DIM �����¿� AS INTEGER

DIM ����� AS BYTE

DIM �Ѿ���Ȯ�� AS BYTE
DIM ����Ȯ��Ƚ�� AS BYTE
DIM ����Ƚ�� AS BYTE
DIM ����COUNT AS BYTE

DIM ���ܼ��Ÿ���  AS BYTE

DIM S11  AS BYTE
DIM S16  AS BYTE
'************************************************
DIM NO_0 AS BYTE
DIM NO_1 AS BYTE
DIM NO_2 AS BYTE
DIM NO_3 AS BYTE
DIM NO_4 AS BYTE

DIM NUM AS BYTE

DIM BUTTON_NO AS INTEGER
DIM SOUND_BUSY AS BYTE
DIM TEMP_INTEGER AS INTEGER

CONST �յڱ���AD��Ʈ = 0
CONST �¿����AD��Ʈ = 1
CONST ����Ȯ�νð� = 20  'ms


CONST min = 61	'�ڷγѾ�������
CONST max = 107	'�����γѾ�������
CONST COUNT_MAX = 3


CONST �Ӹ��̵��ӵ� = 10
'************************************************



PTP SETON 				'�����׷캰 ���������� ����
PTP ALLON				'��ü���� ������ ���� ����

DIR G6A,1,0,0,1,0,0		'����0~5��
DIR G6D,0,1,1,0,1,1		'����18~23��
DIR G6B,1,1,1,1,1,1		'����6~11��
DIR G6C,0,0,0,0,1,0		'����12~17��

'************************************************

OUT 52,0	'�Ӹ� LED �ѱ�
'***** �ʱ⼱�� '************************************************

������� = 0
����üũ = 0
����Ȯ��Ƚ�� = 0
����Ƚ�� = 5
����ONOFF = 0

'****�ʱ���ġ �ǵ��*****************************


TEMPO 230
MUSIC "cdefg"



SPEED 5
GOSUB MOTOR_ON

S11 = MOTORIN(11)
S16 = MOTORIN(16)

SERVO 11, 100
SERVO 16, S16



GOSUB �����ʱ��ڼ�
GOSUB �⺻�ڼ�


GOSUB ���̷�INIT
GOSUB ���̷�MID
GOSUB ���̷�ON



PRINT "VOLUME 200 !"
PRINT "SOUND 12 !" '�ȳ��ϼ���

GOSUB All_motor_mode3



GOTO MAIN	'�ø��� ���� ��ƾ���� ����

������:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
������:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
������:
    TEMPO 250
    MUSIC "FFF"
    RETURN
    '************************************************
    '************************************************
MOTOR_ON: '����Ʈ�������ͻ�뼳��

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    ����ONOFF = 0
    GOSUB ������			
    RETURN

    '************************************************
    '����Ʈ�������ͻ�뼳��
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    ����ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB ������	
    RETURN
    '************************************************
    '��ġ���ǵ��
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
    '��ġ���ǵ��
MOTOR_SET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
All_motor_Reset:

    MOTORMODE G6A,1,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1,1
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,,1

    RETURN
    '************************************************
All_motor_mode2:

    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,,2

    RETURN
    '************************************************
All_motor_mode3:

    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,,3

    RETURN
    '************************************************
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN
    '************************************************
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN

    '************************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '************************************************
Leg_motor_mode4:
    MOTORMODE G6A,3,2,2,1,3
    MOTORMODE G6D,3,2,2,1,3
    RETURN
    '************************************************
Leg_motor_mode5:
    MOTORMODE G6A,3,2,2,1,2
    MOTORMODE G6D,3,2,2,1,2
    RETURN
    '************************************************
Arm_motor_mode1:
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,,1
    RETURN
    '************************************************
Arm_motor_mode2:
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,,2
    RETURN

    '************************************************
Arm_motor_mode3:
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,,3
    RETURN
    '************************************************
    '***********************************************
    '***********************************************
    '**** ���̷ΰ��� ���� ****
���̷�INIT:

    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
    '**** ���̷ΰ��� ���� ****
���̷�MAX:

    GYROSENSE G6A,250,180,30,180,0
    GYROSENSE G6D,250,180,30,180,0

    RETURN
    '***********************************************
���̷�MID:

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
���̷�MIN:

    GYROSENSE G6A,200,100,30,100,0
    GYROSENSE G6D,200,100,30,100,0
    RETURN
    '***********************************************
���̷�ON:


    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0


    ���̷�ONOFF = 1

    RETURN
    '***********************************************
���̷�OFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0


    ���̷�ONOFF = 0
    RETURN

    '************************************************
�����ʱ��ڼ�:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0
    RETURN
    '************************************************
����ȭ�ڼ�:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0

    RETURN
    '******************************************	


    '************************************************
�⺻�ڼ�:


    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,,65,
    WAIT

    mode = 0

    RETURN
    '******************************************	
�⺻�ڼ�2:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT

    mode = 0
    RETURN
    '********************************************
�⺻�ڼ�3:

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,,,
    WAIT

	RETURN
    '******************************************	
�����ڼ�:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 2
    RETURN
    '******************************************
�����ڼ�:
    GOSUB ���̷�OFF
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 1

    RETURN
    '******************************************


    '******************************************
    '**********************************************
    '**********************************************
RX_EXIT:

    ERX 9600, A, MAIN

    GOTO RX_EXIT
    '**********************************************
GOSUB_RX_EXIT:

    ERX 9600, A, GOSUB_RX_EXIT2

    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN
    '**********************************************

�ڷ��Ͼ��:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB ���̷�OFF

    GOSUB All_motor_Reset

    SPEED 15
    GOSUB �⺻�ڼ�

    MOVE G6A,90, 130, ,  80, 110, 100
    MOVE G6D,90, 130, 120,  80, 110, 100
    MOVE G6B,150, 160,  10, 100, 100, 100
    MOVE G6C,150, 160,  10, 100, 100, 100
    WAIT

    MOVE G6B,170, 140,  10, 100, 100, 100
    MOVE G6C,170, 140,  10, 100, 100, 100
    WAIT

    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT
    SPEED 10
    MOVE G6A, 80, 155,  85, 150, 150, 100
    MOVE G6D, 80, 155,  85, 150, 150, 100
    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT



    MOVE G6A, 75, 162,  55, 162, 155, 100
    MOVE G6D, 75, 162,  59, 162, 155, 100
    MOVE G6B,188,  10, 100, 100, 100, 100
    MOVE G6C,188,  10, 100, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT
    GOSUB Leg_motor_mode3	
    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10
    GOSUB �⺻�ڼ�

    �Ѿ���Ȯ�� = 1

    DELAY 200
    GOSUB ���̷�ON

    RETURN


    '**********************************************
�������Ͼ��:


    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB ���̷�OFF

    HIGHSPEED SETOFF

    GOSUB All_motor_Reset

    SPEED 15
    MOVE G6A,100, 15,  70, 140, 100,
    MOVE G6D,100, 15,  70, 140, 100,
    MOVE G6B,20,  140,  15
    MOVE G6C,20,  140,  15
    WAIT

    SPEED 12
    MOVE G6A,100, 136,  35, 80, 100,
    MOVE G6D,100, 136,  35, 80, 100,
    MOVE G6B,20,  30,  80
    MOVE G6C,20,  30,  80
    WAIT

    SPEED 12
    MOVE G6A,100, 165,  70, 30, 100,
    MOVE G6D,100, 165,  70, 30, 100,
    MOVE G6B,30,  20,  95
    MOVE G6C,30,  20,  95
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 10
    MOVE G6A,100, 165,  45, 90, 100,
    MOVE G6D,100, 165,  45, 90, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 6
    MOVE G6A,100, 145,  45, 130, 100,
    MOVE G6D,100, 145,  45, 130, 100,
    WAIT


    SPEED 8
    GOSUB All_motor_mode2
    GOSUB �⺻�ڼ�
    �Ѿ���Ȯ�� = 1

    '******************************
    DELAY 200
    GOSUB ���̷�ON
    RETURN

    '******************************************
    '******************************************
    '******************************************
    '**************************************************

    '******************************************
    '******************************************	
    '**********************************************

�Ӹ�����30��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,70
    RETURN

�Ӹ�����45��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,55
    RETURN

�Ӹ�����60��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,40
    RETURN

�Ӹ�����90��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,10
    RETURN

�Ӹ�������30��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,130
    RETURN

�Ӹ�������45��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,145
    RETURN	

�Ӹ�������60��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,160
    RETURN

�Ӹ�������90��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,190
    RETURN

�Ӹ��¿��߾�:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,100
    RETURN

�Ӹ���������:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,100	
    SPEED 5
    GOSUB �⺻�ڼ�
    RETURN

    '******************************************
��������80��:

    SPEED 3
    SERVO 16, 80
    ETX 9600,35
    RETURN
    '******************************************
��������60��:

    SPEED 3
    SERVO 16, 65
    ETX 9600,36
    RETURN

    '******************************************


�յڱ�������:
    FOR i = 0 TO COUNT_MAX
        A = AD(�յڱ���AD��Ʈ)	'���� �յ�
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF A < MIN THEN
        GOSUB �����
    ELSEIF A > MAX THEN
        GOSUB �����
    ENDIF

    RETURN
    '**************************************************
�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A < MIN THEN GOSUB �������Ͼ��
    IF A < MIN THEN
        ETX  9600,16
        GOSUB �ڷ��Ͼ��

    ENDIF
    RETURN

�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A > MAX THEN GOSUB �ڷ��Ͼ��
    IF A > MAX THEN
        ETX  9600,15
        GOSUB �������Ͼ��
    ENDIF
    RETURN
    '**************************************************
�¿��������:
    FOR i = 0 TO COUNT_MAX
        B = AD(�¿����AD��Ʈ)	'���� �¿�
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB �⺻�ڼ�	
    ENDIF
    RETURN
    '******************************************
DumblingForward:
    'All_motor_mode3

    GOSUB ���̷�OFF
    SPEED 15
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,130,  30,  85, , , 100
    MOVE G6C,130,  30,  85,,10
    WAIT

    SPEED 10
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B, 187,  41, 101,  ,  ,
    MOVE G6C, 185,  45, 100,  ,  ,
    WAIT

    SPEED 7
    MOVE G6A, 100, 165,  55, 165, 100,
    MOVE G6D, 100, 165,  55, 165, 100,
    MOVE G6B, 187,  41, 101,  ,  ,
    MOVE G6C, 185,  45, 100,  ,  ,
    WAIT

    SPEED 15
    MOVE G6A, 100, 160, 110, 140, 100,
    MOVE G6D, 100, 160, 110, 140, 100,
    MOVE G6B, 144,  87,  51,  ,  ,
    MOVE G6C, 147,  77,  60,  ,  ,
    WAIT

    SPEED 15
    MOVE G6A, 100,  56, 110,  26, 100,
    MOVE G6D, 100,  71, 177, 162, 100,
    MOVE G6B, 190,  68,  62,  ,  ,
    MOVE G6C, 190,  68,  62,  ,  ,
    WAIT

    SPEED 15
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  70, 120, 30, 100, 100
    MOVE G6B, 190,  68,  62,  ,  ,
    MOVE G6C, 190,  68,  62,  ,  ,
    WAIT

    SPEED 15
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110,  15, 100, 100
    MOVE G6B,190,  68,  62
    MOVE G6C,190,  68,  62,,10
    WAIT
    DELAY 50

    SPEED 15
    MOVE G6A,100, 110, 70,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 160, 115
    MOVE G6C,190, 160, 115,,10
    WAIT

    SPEED 10
    MOVE G6A,100, 170,  70,  15, 100, 100
    MOVE G6D,100, 170,  70,  15, 100, 100
    MOVE G6B,190, 155, 120
    MOVE G6C,190, 155, 120,,10
    WAIT

    SPEED 10
    MOVE G6A,100, 170,  30,  110, 100, 100
    MOVE G6D,100, 170,  30,  110, 100, 100
    MOVE G6B,190,  40,  60
    MOVE G6C,190,  40,  60
    WAIT

    SPEED 12
    GOSUB �����ڼ�
    GOSUB ���̷�ON
    SPEED 10
    GOSUB �⺻�ڼ�
    '=============================================================
    '   GOSUB �ڷ��Ͼ��



    RETURN
    '************************************************************
DumblingForward_BLUE:
    'All_motor_mode3
    GOSUB ���̷�OFF

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  100,  80,
    MOVE G6C,100,  100,  80,,10,
    WAIT


    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,  15, 155, 140,  ,  ,
    MOVE G6C,  15, 155, 140,  ,  ,
    WAIT




    '    SPEED 15
    '    MOVE G6A,100,  76, 145,  93, 100, 100
    '    MOVE G6D,100,  76, 145,  93, 100, 100
    '    MOVE G6B,170,  90,  35, , , 100
    '    MOVE G6C,170,  90,  35,,10
    '    WAIT

    SPEED 10
    MOVE G6A,100,  76, 145,  110, 100, 100
    MOVE G6D,100,  76, 145,  110, 100, 100
    MOVE G6B,  15, 130, 140,  ,  ,
    MOVE G6C,  15, 130, 140,  ,  ,
    WAIT


    SPEED 15
    MOVE G6A,100,  76, 145,  160, 100, 100
    MOVE G6D,100,  76, 145,  160, 100, 100
    MOVE G6B, 15,  130, 140,  ,  ,
    MOVE G6C, 15,  130, 140,  ,  ,
    WAIT


    'DELAY 200

    '============================================
    '    SPEED 10
    '    MOVE G6A,100,  76, 145,  160, 100, 100
    '    MOVE G6D,100,  76, 145,  160, 100, 100
    '    MOVE G6B, 187,  41, 101,  ,  ,
    '    MOVE G6C, 185,  45, 100,  ,  ,
    '    WAIT

    '    SPEED 7
    '    MOVE G6A, 100, 165,  55, 165, 100,
    '    MOVE G6D, 100, 165,  55, 165, 100,
    '    MOVE G6B, 187,  41, 101,  ,  ,
    '    MOVE G6C, 185,  45, 100,  ,  ,
    '    WAIT

    '    SPEED 15
    '    MOVE G6A, 100, 160, 110, 140, 100,
    '    MOVE G6D, 100, 160, 110, 140, 100,
    '    MOVE G6B, 144,  87,  51,  ,  ,
    '    MOVE G6C, 147,  77,  60,  ,  ,
    '    WAIT

    SPEED 15
    MOVE G6A, 100,  56, 110,  10, 100,
    MOVE G6D, 100,  71, 177, 162, 100,
    MOVE G6B, 20,  130,  140,  ,  ,
    MOVE G6C, 20,  130,  140,  ,  ,
    WAIT

    SPEED 15
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  70, 120, 30, 100, 100
    MOVE G6B, 20,  130,  140,  ,  ,
    MOVE G6C, 20,  130,  140,  ,  ,
    WAIT

    SPEED 15
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,20,  130,  140
    MOVE G6C,20,  130,  140,,10
    WAIT

    'MOVE G6B,190, 100, 100
    'MOVE G6C,190, 100, 100,,10
    'WAIT


    DELAY 50

    SPEED 15
    MOVE G6A,100, 110, 70,  45, 100, 100
    MOVE G6D,100, 110, 70,  45, 100, 100
    MOVE G6B,190, 160, 115
    MOVE G6C,190, 160, 115,,10
    WAIT

    SPEED 15
    MOVE G6A,100, 90, 70,  65, 100, 100
    MOVE G6D,100, 90, 70,  65, 100, 100
    MOVE G6B,190, 180, 105
    MOVE G6C,190, 180, 105,,10
    WAIT

    SPEED 10
    MOVE G6A,100, 170,  70,  15, 100, 100
    MOVE G6D,100, 170,  70,  15, 100, 100
    MOVE G6B,190, 155, 120
    MOVE G6C,190, 155, 120,,10
    WAIT

    SPEED 10
    MOVE G6A,100, 170,  70,  15, 100, 100
    MOVE G6D,100, 170,  70,  15, 100, 100
    MOVE G6B,190, 190, 100
    MOVE G6C,190, 190, 100,,10
    WAIT

    SPEED 10
    MOVE G6A,100, 175,  75,  30, 100, 100
    MOVE G6D,100, 175,  75,  30, 100, 100
    MOVE G6B,190, 190, 100
    MOVE G6C,190, 190, 100,,10
    WAIT

    SPEED 10
    MOVE G6A,100, 170,  30,  110, 100, 100
    MOVE G6D,100, 170,  30,  110, 100, 100
    MOVE G6B,190,  40,  60
    MOVE G6C,190,  40,  60
    WAIT

    SPEED 12
    GOSUB �����ڼ�

    SPEED 10
    GOSUB �⺻�ڼ�
    GOSUB ���̷�ON
    RETURN

    '**********************************
��ܿ����߳�����2cm:
    '�⺻�ڼ�
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,,100,
    WAIT

    MOVE G6A,105,  76, 115,  133, 94, 100
    MOVE G6D,85,  76, 115, 133, 114, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,,100,
    WAIT

    SPEED 7
    MOVE G6D, 90,  30, 165, 158, 114,
    MOVE G6A,113,  95, 100,  128,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    SPEED 7
    MOVE G6D,  90, 10, 165, 170, 114,
    MOVE G6A,113,  115, 65,  144,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6D,90, 10, 170, 150, 105
    MOVE G6A,115,  155, 35, 125,100
    MOVE G6C,100,50
    MOVE G6B,140,40
    WAIT

    '****************************
    SPEED 8
    MOVE G6D,95, 30, 150, 150, 100
    MOVE G6A,108,  155, 60,  110,100
    MOVE G6C,140,50
    MOVE G6B,100,40
    WAIT

    SPEED 8
    MOVE G6D,100, 30, 150, 150, 100
    MOVE G6A,100,  155, 70,  100,100
    MOVE G6C,140,50
    MOVE G6B,100,40
    WAIT

    SPEED 10
    MOVE G6D,100, 50, 130, 135, 94
    MOVE G6A,90,  135, 130,  55,114
    MOVE G6C,170,50
    MOVE G6B,100,40
    WAIT

    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6D,114, 70, 130, 140, 94
    MOVE G6A,90,  125, 50,  140,114
    WAIT

    SPEED 10
    MOVE G6D,114, 70, 130, 135, 94
    MOVE G6A,90,  125, 50,  135,114
    WAIT

    SPEED 9
    MOVE G6D,114, 75, 130, 122, 94
    MOVE G6A,90,  85, 90,  152,114
    WAIT

    SPEED 8
    MOVE G6D,112, 80, 130, 110, 94
    MOVE G6A,90,  75,130,  115,114
    MOVE G6C,130,50
    MOVE G6B,100,40
    WAIT

    SPEED 6
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    GOSUB �⺻�ڼ�

    RETURN
    '********************************************************

��ܿ����߳�����4cm:
    '�⺻�ڼ�
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,,100,
    WAIT	

    '�ɱ�
    SPEED 4
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 4
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,50,  30,  80,
    MOVE G6C,50,  30,  80
    WAIT

    SPEED 4
    MOVE G6A,100, 105,  28, 145, 100, 100
    MOVE G6D,100, 105,  28, 145, 100, 100
    MOVE G6B,50,  30,  80,
    MOVE G6C,50,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,100, 105,  28, 145, 100, 100
    MOVE G6D,100, 50,  28, 175, 100, 100
    MOVE G6B,50,  30,  80,
    MOVE G6C,50,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,100, 105,  28, 145, 100, 100
    MOVE G6D,100, 50,  128, 175, 100, 100
    MOVE G6B,50,  30,  80,
    MOVE G6C,50,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,100, 105,  28, 145, 100, 100
    MOVE G6D,100, 55,  128, 128, 100, 100
    MOVE G6B,50,  30,  80,
    MOVE G6C,50,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,100, 55,  28, 175, 100, 100
    MOVE G6D,100, 55,  128, 115, 100, 100
    MOVE G6B,50,  30,  80,
    MOVE G6C,50,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,100, 55,  128, 175, 100, 100
    MOVE G6D,100, 55,  128, 115, 100, 100
    MOVE G6B,50,  30,  80,
    MOVE G6C,50,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,100, 55,  128, 115, 100, 100
    MOVE G6D,100, 55,  128, 115, 100, 100
    MOVE G6B,50,  30,  80,
    MOVE G6C,50,  30,  80
    WAIT

    '	SPEED 4
    '	MOVE G6A,95, 35,  90, 155, 100, 100
    '    MOVE G6D,100, 55,  128, 155, 100, 100
    '    MOVE G6B,30,  30,  80,
    '    MOVE G6C,30,  30,  80
    '    WAIT

    SPEED 5
    MOVE G6A,95, 35,  90, 155, 100, 100
    MOVE G6D,100, 35,  90, 155, 100, 100
    MOVE G6B,30,  30,  80,
    MOVE G6C,30,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,95, 35,  90, 155, 100, 100
    MOVE G6D,100, 35,  90, 155, 100, 100
    MOVE G6B,60,  30,  80,
    MOVE G6C,60,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,95, 35,  90, 170, 100, 100
    MOVE G6D,100, 35,  90, 170, 100, 100
    MOVE G6B,60,  30,  80,
    MOVE G6C,60,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,95, 80,  50, 170, 100, 100
    MOVE G6D,100, 80,  50, 170, 100, 100
    MOVE G6B,60,  30,  80,
    MOVE G6C,60,  30,  80
    WAIT

    '�ɱ�
    SPEED 4
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT

    '�⺻�ڼ�
    SPEED 4
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,,100,
    WAIT	



    RETURN
    '*****************************************************
��ܿ����߿�����2cm:
    'GOSUB All_motor_mode3
    '�⺻�ڼ�
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,,100,
    WAIT

    '    SPEED 4
    '    MOVE G6D, 88,  71, 152,  91, 110
    '    MOVE G6A,108,  77, 146,  93,  94
    '    MOVE G6B,100,40
    '    MOVE G6C,100,40
    '    WAIT

    SPEED 4
    MOVE G6D, 87,  70, 152,  91, 110
    MOVE G6A,106,  77, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6D, 90, 110, 100, 103, 114
    MOVE G6A,111,  78, 146,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6D, 90, 140, 35, 135, 114
    MOVE G6A,111,  71, 155,  87,  94
    WAIT


    SPEED 12
    MOVE G6D, 85, 75, 100, 160, 114,
    MOVE G6A,109,  70, 155,  86,  94
    WAIT

    SPEED 12
    MOVE G6D, 85, 35, 145, 145, 110,
    MOVE G6A,109,  70, 155,  78,  98
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6D, 105, 55, 110, 165, 100,
    MOVE G6A,90,  92, 165,  70, 100
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 6
    MOVE G6D, 114, 90, 90, 155,100,
    MOVE G6A,90,  100, 165,  65, 105
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6D, 112, 90, 100, 145,97,
    MOVE G6A,95,  130, 110,  90, 105
    WAIT

    SPEED 12
    MOVE G6D, 112, 90, 100, 140,95,
    MOVE G6A,90,  120, 40,  140, 108
    WAIT

    SPEED 10
    MOVE G6D, 114, 90, 110, 120,95,
    MOVE G6A,90,  95, 90,  145, 108
    MOVE G6C,140,50
    MOVE G6B,140,30
    WAIT

    SPEED 10
    MOVE G6D, 110, 90, 110, 120,95,
    MOVE G6A,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 5
    MOVE G6A, 98, 90, 110, 122,99,
    MOVE G6D,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 6
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    RETURN
    '***********************************************
������:
    '�⺻�ڼ�
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,,100,
    WAIT


    GOSUB Leg_motor_mode3
    SPEED 4

    MOVE G6A,108,  77, 145,  93,  92, 100	
    MOVE G6D, 85,  71, 152,  91, 114, 100
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,	
    WAIT

    SPEED 10
    MOVE G6A,108,  75, 145,  100,  95	
    MOVE G6D, 83,  85, 122,  105, 114
    WAIT

    GOSUB Leg_motor_mode2
    HIGHSPEED SETON

    SPEED 10
    MOVE G6A,108,  73, 148,  90,  95	
    MOVE G6D, 83,  20, 155,  135, 114
    MOVE G6C,50
    MOVE G6B,150
    WAIT


    DELAY 200

    HIGHSPEED SETOFF


    SPEED 10
    MOVE G6A,108,  72, 145,  97,  95
    MOVE G6D, 83,  58, 122,  130, 114
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,	
    WAIT	

    SPEED 8
    MOVE G6A,108,  77, 145,  95,  95	
    MOVE G6D, 80,  80, 142,  95, 114
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,
    WAIT	

    SPEED 8
    MOVE G6A,108,  77, 145,  93,  93, 100	
    MOVE G6D, 80,  71, 152,  91, 114, 100
    WAIT


    SPEED 3
    GOSUB �⺻�ڼ�	
    GOSUB Leg_motor_mode1
    DELAY 400

    RETURN
    '******************************************
�����δ���:
    'All_motor_mode3


    SPEED 15
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,130,  30,  85
    MOVE G6C,130,  30,  85,,10
    WAIT

    SPEED 10
    MOVE G6A, 100, 165,  55, 165, 100, 100
    MOVE G6D, 100, 165,  55, 165, 100, 100
    MOVE G6B,185,  10, 100
    MOVE G6C,185,  10, 100,,10
    WAIT

    SPEED 15
    MOVE G6A,100, 160, 110, 140, 100, 100
    MOVE G6D,100, 160, 110, 140, 100, 100
    MOVE G6B,140,  70,  20
    MOVE G6C,140,  70,  20,,10
    WAIT

    SPEED 15
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  71, 177, 162, 100, 100
    MOVE G6B,170,  40,  70
    MOVE G6C,170,  40,  70,,10
    WAIT

    SPEED 15
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  70, 120, 30, 100, 100
    MOVE G6B,170,  40,  70
    MOVE G6C,170,  40,  70,,10
    WAIT

    SPEED 15
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110,  15, 100, 100
    MOVE G6B,190,  40,  70
    MOVE G6C,190,  40,  70,,10
    WAIT
    DELAY 50

    SPEED 15
    MOVE G6A,100, 110, 70,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 160, 115
    MOVE G6C,190, 160, 115,,10
    WAIT

    SPEED 10
    MOVE G6A,100, 170,  70,  15, 100, 100
    MOVE G6D,100, 170,  70,  15, 100, 100
    MOVE G6B,190, 155, 120
    MOVE G6C,190, 155, 120,,10
    WAIT

    SPEED 10
    MOVE G6A,100, 170,  30,  110, 100, 100
    MOVE G6D,100, 170,  30,  110, 100, 100
    MOVE G6B,190,  40,  60
    MOVE G6C,190,  40,  60
    WAIT

    SPEED 12
    GOSUB �����ڼ�

    SPEED 10
    GOSUB �⺻�ڼ�
    '=============================================================
    '   GOSUB �ڷ��Ͼ��



    RETURN


    '****************************************
�����ʿ�����20: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,105,  76, 146,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6D,95,  76, 145,  93, 102, 100
    MOVE G6A,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB �⺻�ڼ�2
    GOSUB All_motor_mode3
    RETURN
    '*************

���ʿ�����20: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 104, 100
    MOVE G6D,105,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6A,95,  76, 145,  93, 102, 100
    MOVE G6D,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB �⺻�ڼ�2
    GOSUB All_motor_mode3
    RETURN

    '**********************************************
������10:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 5
    MOVE G6A,97,  86, 145,  83, 103, 100
    MOVE G6D,97,  66, 145,  103, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  86, 145,  83, 101, 100
    MOVE G6D,94,  66, 145,  103, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB �⺻�ڼ�2
    RETURN
    '**********************************************
��������10:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 5
    MOVE G6A,97,  66, 145,  103, 103, 100
    MOVE G6D,97,  86, 145,  83, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  103, 101, 100
    MOVE G6D,94,  86, 145,  83, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB �⺻�ڼ�2

    RETURN
    '**********************************************
������60:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
������60_LOOP:

    SPEED 15
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  116, 145,  53, 105, 100
    MOVE G6D,90,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    GOSUB �⺻�ڼ�2
    '  DELAY 50
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '    ERX 4800,A,������60_LOOP
    '    IF A_old = A THEN GOTO ������60_LOOP

    RETURN

    '**********************************************
��������60:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
��������60_LOOP:

    SPEED 15
    MOVE G6A,95,  36, 145,  133, 105, 100
    MOVE G6D,95,  116, 145,  53, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  36, 145,  133, 105, 100
    MOVE G6D,90,  116, 145,  53, 105, 100

    WAIT

    SPEED 10
    GOSUB �⺻�ڼ�2
    ' DELAY 50
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '    ERX 4800,A,��������60_LOOP
    '    IF A_old = A THEN GOTO ��������60_LOOP

    RETURN
    '****************************************
��������50:
    GOSUB Leg_motor_mode3

    ����COUNT = 0

    SPEED 4
    '�����ʱ���
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  94
    MOVE G6B,100,35
    MOVE G6C,100,35
    WAIT

    SPEED 10'����ӵ�
    '�޹ߵ��
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,113,  78, 146,  90,  94
    MOVE G6B,90
    MOVE G6C,110
    WAIT


��������50_1:

    SPEED 10
    '�޹߻�������
    MOVE G6A, 92,  44, 165, 113, 114
    MOVE G6D,110,  77, 146,  91,  94
    WAIT

    SPEED 4
    '�޹��߽��̵�
    MOVE G6A,110,  76, 144, 95,  93
    MOVE G6D,90, 94, 155,  71, 112
    WAIT

    SPEED 10
    '�����ߵ��10
    MOVE G6A,111,  77, 146,  88, 94
    MOVE G6D,90, 100, 105, 110, 114
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO ��������50_1_stop


    'ERX 9600,A, ��������50_2
    IF A <> A_old THEN
��������50_1_stop:
        HIGHSPEED SETOFF
        SPEED 5
        '���ʱ���2
        MOVE G6A, 106,  76, 146,  93,  96		
        MOVE G6D,  88,  71, 152,  91, 106
        MOVE G6B, 100,35
        MOVE G6C, 100,35
        WAIT	

        SPEED 3
        GOSUB �⺻�ڼ�
        GOSUB Leg_motor_mode1

        RETURN
    ENDIF
    '**********


��������50_2:

    SPEED 10
    '�����߻�������
    MOVE G6D,85,  54, 165, 110, 114
    MOVE G6A,110,  77, 146,  90,  94
    WAIT

    SPEED 4
    '�������߽��̵�
    MOVE G6D,110,  76, 144, 99,  93
    MOVE G6A, 85, 93, 155,  70, 112
    WAIT

    SPEED 10
    '�޹ߵ��10
    MOVE G6A, 90, 100, 105, 110, 114
    MOVE G6D,111,  77, 146,  93,  94
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO ��������50_2_stop

    'ERX 9600,A, ��������50_1
    IF A <> A_old THEN
��������50_2_stop:
        HIGHSPEED SETOFF
        SPEED 5
        '�����ʱ���2
        MOVE G6D, 106,  76, 146,  93,  96		
        MOVE G6A,  88,  71, 152,  91, 106
        MOVE G6C, 100,35
        MOVE G6B, 100,35
        WAIT

        SPEED 3
        GOSUB �⺻�ڼ�
        GOSUB Leg_motor_mode1
        RETURN
    ENDIF


    GOTO ��������50_1
    '************************************************
������������:
    �Ѿ���Ȯ�� = 0
    ����COUNT = 0
    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35, ,100
        WAIT

        GOTO ������������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO ������������_4
    ENDIF


    '**********************

������������_1:
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,106,  77, 146,  95,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


������������_2:
    MOVE G6A,95,  85, 130, 103, 104
    MOVE G6D,106,  79, 146,  90,  100
    WAIT

������������_3:
    MOVE G6A,103,   85, 130, 105,  100
    MOVE G6D, 95,  80, 146,  90, 102
    WAIT

    'GOSUB �յڱ�������
    'IF �Ѿ���Ȯ�� = 1 THEN
    '    �Ѿ���Ȯ�� = 0
    '    RETURN
    'ENDIF

    'ERX 4800,A, ������������_4
    'IF A <> A_old THEN  GOTO ������������_����
    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO ������������_����
    '*********************************

������������_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,106,  77, 146,  95,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


������������_5:
    MOVE G6D,95,  85, 130, 103, 104
    MOVE G6A,106,  79, 146,  90,  100
    WAIT

������������_6:
    MOVE G6D,103,   85, 130, 105,  100
    MOVE G6A, 95,  80, 146,  90, 102
    WAIT

    'GOSUB �յڱ�������
    'IF �Ѿ���Ȯ�� = 1 THEN
    '    �Ѿ���Ȯ�� = 0
    '    RETURN
    'ENDIF

    'ERX 4800,A, ������������_1
    'IF A <> A_old THEN  GOTO ������������_����
    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO ������������_����

    GOTO ������������_1


������������_����:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 10
    GOSUB �⺻�ڼ�

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT


    '***************************************************
�ؿ�������������:
    �Ѿ���Ȯ�� = 0
    ����COUNT = 0
    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  90, 101
        MOVE G6D,101,  77, 145,  90, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO �ؿ�������������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 145,  90, 101
        MOVE G6A,101,  77, 145,  90, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO �ؿ�������������_4
    ENDIF


    '**********************

�ؿ�������������_1:
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,106,  77, 146,  90,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


�ؿ�������������_2:
    MOVE G6A,95,  85, 130, 103, 104
    MOVE G6D,106,  79, 146,  88,  100
    WAIT

�ؿ�������������_3:
    MOVE G6A,103,   85, 130, 102,  100
    MOVE G6D, 95,  80, 146,  87, 102
    WAIT

    'GOSUB �յڱ�������
    'IF �Ѿ���Ȯ�� = 1 THEN
    '    �Ѿ���Ȯ�� = 0
    '    RETURN
    'ENDIF

    'ERX 4800,A, ������������_4
    'IF A <> A_old THEN  GOTO ������������_����
    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO �ؿ�������������_����
    '*********************************

�ؿ�������������_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,106,  77, 146,  90,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


�ؿ�������������_5:
    MOVE G6D,95,  85, 130, 103, 104
    MOVE G6A,106,  79, 146,  88,  100
    WAIT

�ؿ�������������_6:
    MOVE G6D,105,   85, 130, 102,  100
    MOVE G6A, 92,  80, 146,  87, 102
    WAIT

    'GOSUB �յڱ�������
    'IF �Ѿ���Ȯ�� = 1 THEN
    '    �Ѿ���Ȯ�� = 0
    '    RETURN
    'ENDIF

    'ERX 4800,A, ������������_1
    'IF A <> A_old THEN  GOTO ������������_����
    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO �ؿ�������������_����

    GOTO �ؿ�������������_1


�ؿ�������������_����:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 10
    GOSUB �⺻�ڼ�

    DELAY 400

    GOSUB Leg_motor_mode1
    RETURN
    '*****************************************************8
�ٴں�����������:
    �Ѿ���Ȯ�� = 0
    ����COUNT = 0
    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  90, 101
        MOVE G6D,101,  77, 145,  90, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35, , ,10 ,
        WAIT

        GOTO �ٴں�����������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 145,  90, 101
        MOVE G6A,101,  77, 145,  90, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35, , ,10,
        WAIT

        GOTO �ٴں�����������_4
    ENDIF


    '**********************

�ٴں�����������_1:
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,106,  77, 146,  89,  102
    MOVE G6B, 80
    MOVE G6C,120, , , , ,

    WAIT


�ٴں�����������_2:
    MOVE G6A,95,  85, 130, 103, 104
    MOVE G6D,106,  79, 146,  87,  100
    WAIT

�ٴں�����������_3:
    MOVE G6A,103,   85, 130, 102,  100
    MOVE G6D, 95,  80, 146,  87, 102
    WAIT

    'GOSUB �յڱ�������
    'IF �Ѿ���Ȯ�� = 1 THEN
    '    �Ѿ���Ȯ�� = 0
    '    RETURN
    'ENDIF

    'ERX 4800,A, ������������_4
    'IF A <> A_old THEN  GOTO ������������_����
    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO �ٴں�����������_����
    '*********************************

�ٴں�����������_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,106,  77, 146,  88,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


�ٴں�����������_5:
    MOVE G6D,95,  85, 130, 103, 104
    MOVE G6A,106,  79, 146,  87,  100
    WAIT

�ٴں�����������_6:
    MOVE G6D,105,   85, 130, 102,  100
    MOVE G6A, 92,  80, 146,  87, 102
    WAIT

    'GOSUB �յڱ�������
    'IF �Ѿ���Ȯ�� = 1 THEN
    '    �Ѿ���Ȯ�� = 0
    '    RETURN
    'ENDIF

    'ERX 4800,A, ������������_1
    'IF A <> A_old THEN  GOTO ������������_����
    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO �ٴں�����������_����

    GOTO �ٴں�����������_1


�ٴں�����������_����:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 10
    GOSUB �⺻�ڼ�3

    DELAY 400

    GOSUB Leg_motor_mode1
    RETURN







    '************************************************
MAIN: '�󺧼���

    ETX 9600, 38 ' ���� ���� Ȯ�� �۽� ��

MAIN_2:

    ERX 9600,A,MAIN_2	

    A_old = A


    '**** �Էµ� A���� 0 �̸� MAIN �󺧷� ����
    '**** 1�̸� KEY1 ��, 2�̸� key2��... ���¹�
    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32


    GOSUB �յڱ�������
    GOSUB �¿��������

    'GOSUB ���ܼ��Ÿ�����Ȯ��
    'GOSUB ���̷�OFF
    'DELAY 3000
    'GOSUB DumblingForward_BLUE
    'DELAY 500

    GOTO MAIN	
    '*******************************************
    '		MAIN �󺧷� ����
    '*******************************************



KEY1:
    ETX  9600,1
    GOTO �ؿ�������������

    GOTO MAIN
    '***************	
KEY2:
    ETX  9600,2
    GOTO �����δ���

    GOTO MAIN
    '***************
KEY3:
    ETX  9600,3
    GOTO ��ܿ����߳�����4cm

    GOTO MAIN
    '***************
KEY4:
    ETX  9600,4
    GOTO ������������

    GOTO MAIN
    '***************
KEY5:
    ETX  9600,5
    ����Ƚ�� = 3
    GOTO �ٴں�����������

    GOTO MAIN
    '***************
KEY6:
    ETX  9600,6


    GOTO MAIN
    '***************
KEY7:
    ETX  9600,7


    GOTO MAIN
    '***************
KEY8:
    ETX  9600,8
	GOSUB DumblingForward_BLUE

    GOTO MAIN
    '***************
KEY9:
    ETX  9600,9


    GOTO MAIN
    '***************
KEY10: '0
    ETX  9600,10


    GOTO MAIN
    '***************
KEY11: ' ��
    ETX  9600,11


    GOTO MAIN
    '***************
KEY12: ' ��
    ETX  9600,12


    GOTO MAIN
    '***************
KEY13: '��
    ETX  9600,13



    GOTO MAIN
    '***************
KEY14: ' ��
    ETX  9600,14



    GOTO MAIN
    '***************
KEY15: ' A
    ETX  9600,15


    GOTO MAIN
    '***************
KEY16: ' POWER
    ETX  9600,16


    GOTO MAIN
    '***************
KEY17: ' C
    ETX  9600,17


    GOTO MAIN
    '***************
KEY18: ' E
    ETX  9600,18	


    GOTO MAIN
    '***************
KEY19: ' P2
    ETX  9600,19


    GOTO MAIN
    '***************
KEY20: ' B	
    ETX  9600,20


    GOTO MAIN
    '***************
KEY21: ' ��
    ETX  9600,21


    GOTO MAIN
    '***************
KEY22: ' *	
    ETX  9600,22


    GOTO MAIN
    '***************
KEY23: ' G
    ETX  9600,23


    GOTO MAIN
    '***************
KEY24: ' #
    ETX  9600,24


    GOTO MAIN
    '***************
KEY25: ' P1
    ETX  9600,25


    GOTO MAIN
    '***************
KEY26: ' ��
    ETX  9600,26


    GOTO MAIN
    '***************
KEY27: ' D
    ETX  9600,27


    GOTO MAIN
    '***************
KEY28: ' ��
    ETX  9600,28


    GOTO MAIN
    '***************
KEY29: ' ��
    ETX  9600,29


    GOTO MAIN
    '***************
KEY30: ' ��
    ETX  9600,30


    GOTO MAIN
    '***************
KEY31: ' ��
    ETX  9600,31


    GOTO MAIN
    '***************

KEY32: ' F
    ETX  9600,32


    GOTO MAIN
    '***************
