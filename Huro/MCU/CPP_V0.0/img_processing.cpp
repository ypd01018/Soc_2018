#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <queue>
#include <stack>
#include <algorithm>

#include "img_processing.h"

#define Labeling1 vector<pair<pair<U32,POS>, Range> > area;
#define Labeling2 vector<pair<U32, POS> > area;

using namespace std;

//Range Check
bool IsVaild(U16 y, U16 x, Range range)
{
    return range.start_y<=y&&y<range.end_y&&range.start_x<=x&&x<range.end_x;
}

//RGB->HSV
HSV ChangetoHSV(U16 buf)
{
    RGB rgb;

    rgb.red = red5(buf);
    rgb.green = green6(buf);
    rgb.blue = blue5(buf);

    BYTE RED = rgb.red << 3 | rgb.red >> 2;
    BYTE GREEN = rgb.green << 2 | rgb.green >> 4;
    BYTE BLUE = rgb.blue << 3 | rgb.blue >> 2;

    HSV out;

    BYTE _max_, _min_;

    _max_ = max3(RED, GREEN, BLUE);
    _min_ = min3(RED, GREEN, BLUE);

    out.V = _max_;
    if(!out.V)
    {
        out.H = 0;
        out.S = 0;
        return out;
    }
    
    out.S = 255 * (long)(_max_ - _min_) / out.V;
    if(!out.S)
    {
        out.H = 0;
        return out;
    }

    if(_max_ == RED)
    {
        out.H = 0 + 43 * (GREEN - BLUE) / (_max_ - _min_);
    }
    else if(_max_ == GREEN)
    {
        out.H = 85 + 43 * (BLUE - RED) / (_max_ - _min_);
    }
    else
    {
        out.H = 171 + 43 * (RED - GREEN) / (_max_ - _min_);
    }
    return out;
}

//Check_Color
int FindColor(U16 rgb)
{
    if(ISBLACK(rgb))return IsBlack;
    if(ISRED(rgb))return IsRed;
    if(ISGREEN(rgb))return IsGreen;
    if(ISBLUE(rgb))return IsBlue;
    if(ISYELLOW(rgb))return IsYellow;
    if(ISORANGE(rgb))return IsOrange;
}

//BLACK_CHECK
// bool ISBLACK(U16 rgb)
// {
//     BYTE red = red5(rgb);
//     BYTE green = green6(rgb);
//     BYTE blue = blue5(rgb);

//     return (abs(blue-red) <= 2 && abs((green>>1) - blue) <= 3 && abs((red - (green>>1)) <= 3) && red < 8 && green < 15 && blue < 8);
// }

bool ISBLACK(U16 rgb)
{
    BYTE red = red5(rgb);
    BYTE green = green6(rgb);
    BYTE blue = blue5(rgb);

    if(abs(blue-red)<=4&&abs((green>>1)-blue)<=7&&abs(red-(green>>1))<=7&&red<24&&green<48&&blue<24)
    {
        return true;
    }
    return false;
}

//RED_CHECK
//NOT_YET
bool ISRED(U16 rgb)
{
    HSV hsv = ChangetoHSV(rgb);
    return (hsv.H <= 10 || hsv.H >= 225);
}

//GREEN_CHECK
bool ISGREEN(U16 rgb)
{
    HSV hsv = ChangetoHSV(rgb); 
    return (55<=hsv.H&&hsv.H<=120&&25<=hsv.S&&25<=hsv.V);
}

//BLUE_CHECK
bool ISBLUE(U16 rgb)
{
    HSV hsv = ChangetoHSV(rgb);
    return (120<=hsv.H&&hsv.H<=165&&35<=hsv.S&&30<=hsv.V&&hsv.V<=250);
}

//YELLOW_CHECK
bool ISYELLOW(U16 rgb)
{
    HSV hsv = ChangetoHSV(rgb);
    return (25<=hsv.H&&hsv.H<=55&&50<=hsv.S&&30<=hsv.V&&hsv.V<=250);
}

//ORANGE_CHECK
//NOT_YET
bool ISORANGE(U16 rgb)
{
    HSV hsv = ChangetoHSV(rgb);
    return ((230<=hsv.H||hsv.H<=15)&&hsv.H<=180);
}

//전체화면 라벨링
//vector<pair<pair<U32,POS>, Range> > &area
// -> U32에 해당하는건 넓이, POS는 (무게)중심 좌표
// -> Range는 각 라벨링 된 것의 x,y의 최대값과 최솟값
int ColorLabelingFULL(U16 color, vector<pair<pair<U32, POS>, Range> > &area, U16 *input)
{
   
    int count = 0;
    short i, j, k;
    pair<short, short> now;
    const int dx[] = {-1,1,0,0};
    const int dy[] = {0,0,-1,1};

    queue<pair<short, short> > q;
    U32 area_cal = 0, sum_x, sum_y;
    int *visit = (int*)malloc(sizeof(int)*height*width);
    memset(visit, 0, sizeof(visit));

    POS pos_input;
    Range range;
    BYTE MIN_X, MAX_X, MIN_Y, MAX_Y;
    BYTE DOWN_MIN_X, DOWN_MAX_X;
    BYTE UP_MIN_X, UP_MAX_X;

    for(i=0;i<height;i++)
    {
        for(j=0;j<width;j++)
        {
            MIN_X = MIN_Y = 255;
            MAX_X = MAX_Y = 0;
            DOWN_MIN_X = UP_MIN_X = 255;
            DOWN_MAX_X = UP_MAX_X = 0;
            if(input[pos(i,j)] == color && visit[pos(i,j)] == false)
            {
                ++count;
                area_cal = sum_x = sum_y = 0;
                q.push(make_pair(i,j));
                visit[pos(i,j)] = true;
                input[pos(i,j)] = count; // count
                while(!q.empty())
                {
                    ++area_cal;
                    now = q.front();
                    if(now.first < MIN_Y)MIN_Y = now.first;
                    if(now.first > MAX_Y)MAX_Y = now.first;
                    if(now.second < MIN_X)MIN_X = now.second;
                    if(now.second > MAX_X)MAX_X = now.second;
                    if(now.first == MIN_Y + 2)
                    {
                        if(now.second > DOWN_MAX_X)DOWN_MAX_X = now.second;
                        if(now.second < DOWN_MIN_X)DOWN_MIN_X = now.second;
                    }
                    if(now.first == MAX_Y - 2)
                    {
                        if(now.second > UP_MAX_X)UP_MAX_X = now.second;
                        if(now.second < UP_MIN_X)UP_MIN_X = now.second;
                    }
                    sum_x += now.second;
                    sum_y += now.first;
                    q.pop();
                    for(k=0;k<4;k++)
                    {
                        if(now.first + dy[k] < 0 || now.first + dy[k] >= height || now.second + dx[k] < 0 || now.second + dx[k] >= width)continue;
                        if(input[pos(now.first + dy[k],now.second + dx[k])] == color && visit[pos(now.first + dy[k],now.second + dx[k])] == false)
                        {
                            visit[pos(now.first + dy[k], now.second + dx[k])] = true;
                            input[pos(now.first + dy[k], now.second + dx[k])] = count; //count
                            q.push(make_pair(now.first + dy[k], now.second + dx[k]));
                        }
                    }
                }
                if(area_cal != 0){
                    pos_input.x = sum_x / area_cal;
                    pos_input.y = sum_y / area_cal;
                    range.start_x = DOWN_MAX_X;
                    range.end_x = UP_MAX_X;
                    range.start_y = DOWN_MIN_X;
                    range.end_y = UP_MIN_X;
                    area.push_back(make_pair(make_pair(area_cal, pos_input), range));
                }
            }
            else if(visit[pos(i,j)] == false)
            {
                if(color == 0x0000)
                    input[pos(i,j)] = 0xFFFF;
                else
                    input[pos(i,j)] = 0x0000;
            }
        }
    }

    free(visit);
    return count;
}

//Range_Labeling
int ColorLabeling(U16 color, vector<pair<U32, POS> > &area, Range &range, U16 *input)
{
    int count = 0;
    short i, j, k;
    pair<short, short> now;
    const int dx[] = {-1,1,0,0};
    const int dy[] = {0,0,-1,1};

    queue<pair<short, short> > q;
    U32 area_cal = 0, sum_x, sum_y;
    int *visit = (int*)malloc(sizeof(int)*height*width);
    memset(visit,0,sizeof(visit));

    POS pos_input;

    for(i=range.start_y;i<range.end_y;i++)
    {
        for(j=range.start_x;j<range.end_x;j++)
        {
            if(input[pos(i,j)] == color && visit[pos(i,j)] == false)
            {
                ++count;
                area_cal = sum_x = sum_y = 0;
                q.push(make_pair(i,j));
                visit[pos(i,j)] = true;
                input[pos(i,j)] = count;
                while(!q.empty())
                {
                    ++area_cal;
                    now = q.front();
                    sum_x += now.second;
                    sum_y += now.first;
                    q.pop();
                    for(k=0;k<4;k++)
                    {
                        if(now.first + dy[k] < range.start_y || now.first + dy[k] >= range.end_y || now.second + dx[k] < range.start_x || now.second + dx[k] >= range.end_x)continue;
                        if(input[pos(now.first + dy[k],now.second + dx[k])] == color && visit[pos(now.first + dy[k],now.second + dx[k])] == false)
                        {
                            input[pos(now.first + dy[k], now.second + dx[k])] = count;
                            visit[pos(now.first + dy[k], now.second + dx[k])] = true;
                            q.push(make_pair(now.first + dy[k], now.second + dx[k]));
                        }
                    }
                }
                if(area_cal != 0){
                    pos_input.x = sum_x / area_cal;
                    pos_input.y = sum_y / area_cal;
                    area.push_back(make_pair(area_cal, pos_input));
                }
            }
            else if(visit[pos(i,j)] == false)
            {
                if(color == 0x0000)
                    input[pos(i,j)] = 0xFFFF;
                else
                    input[pos(i,j)] = 0x0000;
            }
        }
    }

    free(visit);
    return count;
}

//GREENBRIGDE 6
void WalkOnGreenBrigde(int &number)
{
    short i, j;
    static bool LookDownCheck = false;
    U16 *input = (U16*)malloc(2*180*120);
    vector<pair<pair<U32, POS>, Range> > area;
    vector<Range> Pos_range;
    Range pos_range;
    
    U32 area_sum = 0;
    U32 temp_i;

    area.clear();
    area_sum = 0;
    temp_i = 0;     

    read_fpga_video_data(input);
    
    //if pixel is green, change to 0xFFFF(white)
    //if not, change to 0x0000(black)
    for(i=0;i<height;i++)
    {
        for(j=0;j<width;j++)
        {
            if(FindColor(input[pos(i,j)]) == IsGreen)
            {
                input[pos(i,j)] = 0xFFFF;
            }
            else
            {
                input[pos(i,j)] = 0x0000;
            }
        }
    }
    
    //Labeling about 0xFFFF(Green was changed to 0xFFFF)
    ColorLabelingFULL(0xFFFF, area, input);

    for(i=0;i<area.size();i++)
    {
        if(area_sum < area[i].first.first)
        {
            area_sum = area[i].first.first;
            temp_i = i + 1;
        }
    }

    BYTE L_MAX_Y = 0, L_MIN_Y = 255;
    BYTE MID_X = temp_i >= 1 ? area[temp_i - 1].first.second.x : 255;

    //Without big area, change to white
    for(i=0;i<height;i++)
    {
        for(j=0;j<width;j++)
        {
            if(temp_i >= 1 && (area[temp_i - 1].first.second.x == j || area[temp_i - 1].first.second.y == i)) input[pos(i,j)] = 0x07E0;
            else if(temp_i >= 1 && input[pos(i,j)] == temp_i)
            {
                if(L_MAX_Y < i)L_MAX_Y = i;
                if(L_MIN_Y > i)L_MIN_Y = i;
                input[pos(i,j)] = 0x0000;
            }
            else
            {
                input[pos(i,j)] = 0xFFFF;
            }
        }
    }

    U32 LINE_DOWN = 0, LINE_UP_COUNT = 0;
    U32 LINE_UP = 0, LINE_DOWN_COUNT = 0;
    U16 Mid_down, Mid_up;
    
    if(L_MAX_Y - 10 >= L_MIN_Y)
    {
        for(i=0;i<height;i++)
        {
            for(j=0;j<width;j++)
            {
                if(L_MAX_Y - 5 <= i && L_MAX_Y > i)
                {
                    if(input[pos(i,j)] == 0x0000)
                    {
                        LINE_UP += j;
                        LINE_UP_COUNT++;
                    }
                }
                else if(L_MIN_Y + 5 >= i)
                {
                    if(input[pos(i,j)] == 0x0000)
                    {
                        LINE_DOWN += j;
                        LINE_DOWN_COUNT++;
                    }
                }
            }
        }
        Mid_down = LINE_DOWN / LINE_DOWN_COUNT;
        Mid_up = LINE_UP / LINE_UP_COUNT;

        printf("MID_X : %d, Mid_down : %d, Mid_up : %d\n",MID_X, Mid_down, Mid_up);

        //http://ssu-gongdoli.tistory.com/19
        //password : soc_ssurobotics
        if(83 <= MID_X && MID_X <= 97)
        {
            if(abs(Mid_down - Mid_up) <= 5)
            {
                //GoGo
                printf("#1 GoGo\n");
                Send_Command(GOSTRAIGHT);
                wait_for_stop();
            }
            else
            {
                if(Mid_up <= MID_X && MID_X <= Mid_down)
                {
                    //Turn Right
                    printf("#2 Turn Right\n");
                    Send_Command(TURNRIGHT);
                    wait_for_stop();
                }
                else if(Mid_down <= MID_X && MID_X <= Mid_up)
                {
                    //Turn Left
                    printf("#3 Turn Left\n");
                    Send_Command(TURNLEFT);
                    wait_for_stop();
                }
            }
        }
        else if(MID_X < 83)
        {
            if(Mid_down > MID_X && Mid_up > MID_X)
            {
                if(MID_X >= 60)
                {
                    printf("#new6 Turn Right\n");
                    Send_Command(TURNRIGHT);
                    wait_for_stop();
                }
                else
                {
                    //Go Right
                    printf("#new3 Go Right\n");
                    Send_Command(GORIGHT);
                    wait_for_stop();
                }
            }
            else if(abs(Mid_down - Mid_up) <= 8)
            {
                //Go Right
                printf("#4 Go Right\n");
                Send_Command(GORIGHT);
                wait_for_stop();
            }
            else 
            {
                if(Mid_down > Mid_up)
                {
                    //Turn Right
                    printf("#5 Turn Right\n");
                    Send_Command(TURNRIGHT);
                    wait_for_stop();
                }
                else
                {
                    if(abs(MID_X - Mid_down) - abs(MID_X - Mid_up) <= 3)
                    {
                        printf("#new2 Go Right\n");
                        Send_Command(GORIGHT);
                        wait_for_stop();
                    }
                    else
                    {
                        //I don't know What situation is
                        printf("#6 Hmm....\n");
                    }
                }
            }
        }
        else
        {
            if(Mid_down < MID_X && Mid_up < MID_X)
            {
                //Go Left
                if(MID_X <= 123){
                    printf("#new5 Turn Left\n");
                    Send_Command(TURNLEFT);
                    wait_for_stop();
                }
                else
                {
                    printf("#new4 Go Left\n");
                    Send_Command(GOLEFT);
                    wait_for_stop();
                }
            }
            else if(abs(Mid_down - Mid_up) <= 8)
            {
                //Go Left
                printf("#7 Go Left\n");
                Send_Command(GOLEFT);
                wait_for_stop();
            }
            else
            {
                if(Mid_down < Mid_up)
                {
                    //Turn Left
                    printf("#8 Turn Left\n");
                    Send_Command(TURNLEFT);
                    wait_for_stop();
                }
                else
                {
                    if(abs(MID_X - Mid_down) - abs(MID_X - Mid_up) <= 3)
                    {
                        printf("#new1 Go Left\n");
                        Send_Command(GOLEFT);
                        wait_for_stop();
                    }
                    else
                    {
                        //I don't know what situation is
                        printf("#9 Hmm....\n");
                    }
                }
            }
        }
        
        for(i=0;i<height;i++)
        {
            input[pos(i,Mid_down)] = 0xF800;
            input[pos(i,Mid_up)] = 0x001F;
        }
    }
    draw_fpga_video_data_full(input);
    flip();

    free(input);
}

#define YellowGate_area_start 500
#define YellowGate_area_end 3500

//Not Use
void YellowGate(int &number)
{
    U16 *input = (U16*)malloc(2*180*120);
    read_fpga_video_data(input);
    short i,j;
    static bool Yellow_Gate_Check = false;

    for(i=0;i<height;i++)
    {
        for(j=0;j<width;j++)
        {
            if(ISYELLOW(input[pos(i,j)]))
            {
                input[pos(i,j)] = 0xFFFF;
            }
            else
            {
                input[pos(i,j)] = 0x0000;
            }
        }
    }   

    vector<pair<pair<U32,POS>,Range > > area;

    ColorLabelingFULL(0xFFFF,area,input);
    U16 Gate_Count = 0;
    U32 Max_area = 0;
    U16 temp_i = 0;

    for(i=0;i<area.size();i++)
    {
        if(Max_area < area[i].first.first && YellowGate_area_start<=area[i].first.first&&area[i].first.first<=YellowGate_area_end)
        {
            Max_area = area[i].first.first;
            temp_i = i + 1;
        }
    }

    //printf("%d %d\n",temp_i-1,area[temp_i-1].first.first);

    for(i=0;i<height;i++)
    {
        for(j=0;j<width;j++)
        {
            if(temp_i&&input[pos(i,j)] == temp_i)
            {
                Gate_Count++;
                input[pos(i,j)] = 0xFFFF;
            }
            else
            {
                input[pos(i,j)] = 0x0000;
            }
        }
    }

    if(Gate_Count>=1)
    {
        if(!Yellow_Gate_Check){
            Motion_Command(SoundPlay);
            Yellow_Gate_Check = true;
        }
    }
    else
    {
        if(Yellow_Gate_Check)
        {
            number++;
            Yellow_Gate_Check = false;
        }
    }

    draw_fpga_video_data_full(input);
    flip();
    free(input);
    return;
}

void BeforeStart(int &Stage)
{
   printf("0번\n");
   U16* input = (U16*)malloc(2 * 180 * 120);
   read_fpga_video_data(input);
   short i, j;
   short YellowCnt = 0;
   printf("1번:%d\n", YellowCnt);
   for (i = 0; i < 120; i++)
   {
      for (j = 0; j < 180; j++)
      {
         if (FindColor(input[pos(i,j)])==IsYellow) YellowCnt++;
      }
   }
   printf("2번%d\n", YellowCnt);
   if (YellowCnt > 3000) (Stage)++;//1st try:1000,2nd try:700
   printf("3번%d\n", Stage);
   draw_fpga_video_data_full(input);
   flip();
   free(input);
}

void StartBarigate(int &Stage)
{
   short i, j;
   short YellowCnt = 0, BlackCnt = 0;
   U16 *input = (U16*)malloc(2 * 180 * 120);
   read_fpga_video_data(input);
   for (i = 0; i < 120; i++)
   {
      for (j = 0; j < 180; j++)
      {
         if (FindColor(input[pos(i, j)]) == IsYellow) YellowCnt++;
      }
   }
   if (YellowCnt < 3000)
   {
      //walkslowly();
      //walkslowly();
      //walkslowly();
      Motion_Command(1);
      Motion_Command(1);
      Motion_Command(1);
      (Stage)++;
   }
   YellowCnt = 0;
   draw_fpga_video_data_full(input);
   flip();
   free(input);
}

//RED 2_1
void Red_Stair(int &number)
{
    U16 *input = (U16*)malloc(2*180*120);
    read_fpga_video_data(input);
    static bool Look_Down_Check = false;
    static bool Find_Red_Stair_Check = false;

    short i,j;

    for(i=0;i<height;i++)
    {
        for(j=0;j<width;j++)
        {
            if(ISRED(input[pos(i,j)]))
            {
                input[pos(i,j)] = 0xFFFF;
            }
            else
            {
                input[pos(i,j)] = 0x0000;
            }
        }
    }

    if(!Look_Down_Check){
        vector<pair<pair<U32, POS>, Range> > area;
        ColorLabelingFULL(0xFFFF,area,input);
        U32 max_area=0;
        U16 temp_i=0;

        for(i=0;i<area.size();i++)
        {
            if(area[i].first.first>=2000&&area[i].first.first>max_area)
            {
                max_area = area[i].first.first;
                temp_i = i + 1;
            }
        }
        
        for(i=0;i<height;i++)
        {
            for(j=0;j<width;j++)
            {
                if(input[pos(i,j)] == temp_i)
                {
                    input[pos(i,j)] = 0xFFFF;
                }
                else
                {
                    input[pos(i,j)] = 0x0000;
                }
            }
        }


        if(max_area == 0){
            Motion_Command(GOSTRAIGHT);
            draw_fpga_video_data_full(input);
            flip();
            free(input);
            return;
        }

        POS pos = area[temp_i-1].first.second;
        if(pos.y >= 90)
        {
            Motion_Command(GOSTRAIGHT);
        }
        else
        {
            Motion_Command(SoundPlay);
            Motion_Command(SoundPlay);
            Motion_Command(SoundPlay);
            Motion_Command(HEAD_DOWN_90);
            delay();
            read_fpga_video_data(input);
            draw_fpga_video_data_full(input);
            flip();
            free(input);
            Look_Down_Check = true;
            return;
        }
    }
    else if(Look_Down_Check)
    {
        vector<pair<U32,POS> > area;
        Range range;
        range.start_x = 0;
        range.end_x = 180;
        range.start_y = 60;
        range.end_y = 120;
        ColorLabeling(0xFFFF, area,range,input);

        U32 max_area = 0;
        U16 temp_i = 0;

        if(area.size() != 0)
        {
            for(i=0;i<area.size();i++)
            {
                if(max_area<area[i].first)
                {
                    max_area = area[i].first;
                    temp_i = i+1;
                }
            }

            for(i=range.start_y;i<range.end_y;i++)
            {
                for(j=range.start_x;j<range.end_x;j++)
                {
                    if(input[pos(i,j)]==temp_i)
                    {
                        input[pos(i,j)] = 0xFFFF;
                    }
                    else
                    {
                        input[pos(i,j)] = 0x0000;
                    }
                }
            }

            POS pos = area[temp_i - 1].second;
            printf("%d\n",max_area);
            if(max_area<=8500)
            {
                Motion_Command(GOSTRAIGHT_LOOKDOWN90);
            }
            else
            {
                draw_fpga_video_data_full(input);
                flip();
                number++;
                Find_Red_Stair_Check = true;
            }
        }
        else
        {
            Motion_Command(GOSTRAIGHT_LOOKDOWN90);
        }
    }


    draw_fpga_video_data_full(input);
    flip();
    free(input);
    return;
}

//RED 2_2
void Up_Red_Stair(int &number)
{
    //
    //Motion_Command(UP_RED_STAIR);
    U16 *input = (U16*)malloc(2*180*120);
    read_fpga_video_data(input);

    Motion_Command(SoundPlay);
    Motion_Command(GOSTRAIGHT_LOOKDOWN90);
    
    Motion_Command(RED_DUMBLING);
    number++;
    draw_fpga_video_data_full(input);
    flip();
    free(input);
    return;
}

//RED 2_3
void Go_Down_Red_Stair(int &number)
{
    U16 *input = (U16*)malloc(2*180*120);
    short i, j;
    static bool LOOKDOWN90_CHECK = false;

    if(!LOOKDOWN90_CHECK)
    {
        LOOKDOWN90_CHECK = true;
        Motion_Command(HEAD_DOWN_90);
        delay();
        read_fpga_video_data(input);
        draw_fpga_video_data_full(input);
        flip();
        free(input);
        return;
    }

    read_fpga_video_data(input);
    
    Range range;
    range.start_x = 0;
    range.end_x = 180;
    range.start_y = 60;
    range.end_y = 120;

    for(i=range.start_y;i<range.end_y;i++)
    {
        for(j=range.start_x;j<range.end_x;j++)
        {
            if(FindColor(input[pos(i,j)])==IsRed)
            {
                input[pos(i,j)] = 0xFFFF;
            }
            else
            {
                input[pos(i,j)] = 0x0000;
            }
        }
    }
    
    vector<pair<U32, POS> > area = vector<pair<U32, POS> >();
    
    ColorLabeling(0xFFFF, area, range,input);

    U32 max_area = 0;
    U16 temp_i = 0;
    
    for(i=0;i<area.size();i++)
    {
        if(max_area < area[i].first)
        {
            max_area = area[i].first;
            temp_i = i + 1;
        }
    }

    for(i=0;i<height;i++)
    {
        for(j=0;j<width;j++)
        {
            if(input[pos(i,j)] == temp_i)input[pos(i,j)]=0xFFFF;
            else input[pos(i,j)] = 0x0000;
        }
    }

    draw_fpga_video_data_full(input);
    flip();

    if(max_area <= 2600 || temp_i == 0)
    {
        
        Motion_Command(4);
        number++;
        free(input);
        return;
    }
    else
    {
        Motion_Command(GOSTRAIGHT_LOOKDOWN90);
    }



    free(input);
    return;
}

//BLUE 4
void Blue_Hurdle(int &number)
{
    static bool DOWN_CHECK = false;

    if(!DOWN_CHECK)
    {
        DOWN_CHECK = true;
        Motion_Command(HEAD_DOWN_90);
        delay();
    }

    U16 *input = (U16*)malloc(2*180*120);
    read_fpga_video_data(input);

    short i, j;
    Range range;
    range.start_x = 0;
    range.end_x = 180;
    range.start_y = 60;
    range.end_y = 120;
    for(i=0;i<height;i++)
    {
        for(j=0;j<width;j++)
        {
            if(IsVaild(i,j,range))
            {
                if(FindColor(input[pos(i,j)]) == IsBlue)
                {
                    input[pos(i,j)] = 0xFFFF;
                }
                else
                {
                    input[pos(i,j)] = 0x0000;
                }
            }
            else
            {
                input[pos(i,j)] = 0x0000;
            }
        }
    }
    
    //머리를 90도 밑으로 내리기 때문에 전체 라벨링 보단 일부 라벨링으로 돌리는게 더 낫다.
    vector<pair<U32, POS> > area;
    ColorLabeling(0xFFFF,area,range,input);
    //vector<pair<pair<U32,POS>,Range > > area;
    //ColorLabelingFULL(0xFFFF,area,input);

    U32 max_area = 0;
    U16 temp_i = 0;

    for(i=0;i<area.size();i++)
    {
        if(max_area < area[i].first)
        {
            max_area = area[i].first;
            temp_i = i + 1;
        }
    }

    for(i=0;i<height;i++)
    {
        for(j=0;j<width;j++)
        {
            if(input[pos(i,j)] == temp_i)
            {
                input[pos(i,j)] = 0x001F;
            }
            else
            {
                input[pos(i,j)] = 0x0000;
            }
        }
    }

    if(max_area >= 1000)
    {
        number++;
        Motion_Command(SoundPlay);
        Motion_Command(GOSTRAIGHT_LOOKDOWN90);
        Motion_Command(GOSTRAIGHT_LOOKDOWN90);
        Motion_Command(SoundPlay);
        Motion_Command(SoundPlay);
    }
    else
    {
        Motion_Command(GOSTRAIGHT_LOOKDOWN90);
    }

    draw_fpga_video_data_full(input);
    flip();
    free(input);
    return;
}

#define Mine_area_min 500
#define Mine_area_max 2000

void Find_Mine(int &number)
{
    short i, j;

    U16 *input = (U16*)malloc(2*180*120);
    read_fpga_video_data(input);

    vector<pair<U32, POS> > area;
    Range range;
    range.start_x = 40;
    range.end_x = 140;
    range.start_y = 40;
    range.end_y = 90;
    
    for(i=0;i<height;i++)
    {
        for(j=0;j<width;j++)
        {
            if(IsVaild(i,j,range))
            {
                if(FindColor(input[pos(i,j)]) == IsBlack)
                {
                    input[pos(i,j)] = 0xFFFF;
                }
                else
                {
                    input[pos(i,j)] = 0x0000;
                }
            }
            else
            {
                input[pos(i,j)] = 0x0000;
            }
        }
    }

    ColorLabeling(0xFFFF, area, range, input);
    POS mine_pos;
    U16 max_i = 255;
    bool MINE_EXIST = false;

    if(area.size()==0)
    {
        Motion_Command(GOSTRAIGHT_LOOKDOWN90);
    }
    else
    {
        for(i=0;i<area.size();i++)
        {
            if(Mine_area_min <= area[i].first && area[i].first <= Mine_area_max)
            {
                MINE_EXIST = true;
                if(area[i].second.y < max_i)
                {
                    max_i = area[i].second.y;
                    mine_pos = area[i].second;
                }
            }
        }

        if(!MINE_EXIST)
        {
            Motion_Command(GOSTRAIGHT_LOOKDOWN90);
        }
    }

    draw_fpga_video_data_full(input);
    flip();
    free(input);
    return;
}

U8 make_gray(U16 input)
{
	U8 gray;

	U8 red, green, blue;
	red = red5(input) << 3 | red5(input) >> 2;
	green = green6(input) << 2 | green6(input) >> 4;
	blue = blue5(input) << 3 | blue5(input) >> 2;

	gray = (red + green + blue) / 3;
	return gray;
}

U16 make_gray_16(U16 input)
{
	U8 gray = make_gray(input);
	U16 out_gray = ((gray >> 3) << 11) | ((gray >> 2) << 5) | (gray>>3);
	return out_gray;
}

U16 make_16(U16 gray)
{
	return ((gray >> 3) << 11) | ((gray >> 2) << 5) | (gray>>3);
}

void Line_Search(U16 *input)
{
    short i,j;
    U32 area_sum = 0;
    for(i=0;i<height;i++)
    {
        for(j=0;j<width;j++)
        {
            area_sum += make_gray(input[pos(i,j)]);
        }
    }
    U16 area_thred = area_sum / (height*width);
    for(i=0;i<height;i++)
    {
        for(j=0;j<width;j++)
        {
            if(input[pos(i,j)] <= make_16(area_thred))
            {
                input[pos(i,j)] = 0xFFFF;
            }
            else
            {
                input[pos(i,j)] = 0x0000;
            }
        }
    }
}

#define LINE_AREA_MIN 50
#define LINE_AREA_MAX 4000

void Line_Match(int &number)
{
    short i, j;
    //static 
    bool IsRight = true;
    U16 *input = (U16*)malloc(2*180*120);
    
    if(IsRight){
        Motion_Command(HEAD_RIGHT_90);
        delay();
        Motion_Command(HEAD_DOWN_60);
        delay();
        read_fpga_video_data(input);
        short i, j;
        
        for(i=0;i<height;i++)
        {
            for(j=0;j<width;j++)
            {
                if(FindColor(input[pos(i,j)]) ==IsYellow)
                {
                    input[pos(i,j)] = 0xFFFF;
                }
                else
                {
                    input[pos(i,j)] = 0x0000;
                }
            }
        }
        //Line_Search(input);



        vector<pair<U32, POS> > area;
        Range range;
        range.start_x = 0;
        range.end_x = 90;
        range.start_y = 0;
        range.end_y = 120;

        ColorLabeling(0xFFFF,area,range,input);
        
         if(area.size() == 0)
        {
            clear_screen();
            flip();
            free(input);
            IsRight = false;
            return;
        }

        U16 temp_i = 0;
        U32 Max_area = 0;

        for(i=0;i<area.size();i++)
        {
            if(LINE_AREA_MIN <= area[i].first && area[i].first <= LINE_AREA_MAX)
            {
                if(Max_area < area[i].first)
                {
                    Max_area = area[i].first;
                    temp_i = i+1;
                }
            }
        }

        if(temp_i == 0)
        {
            clear_screen();
            flip();
            free(input);
            return;
        }

        Range area_range = {255,0,255,0};

        for(i=0;i<height;i++)
        {
            for(j=0;j<width;j++)
            {
                if(input[pos(i,j)] == temp_i)
                {
                    input[pos(i,j)] = 0xFFFF;
                    if(i<area_range.start_y)area_range.start_y=i;
                    if(i>area_range.end_y)area_range.end_y=i;
                    if(j<area_range.start_x)area_range.start_x=j;
                    if(j>area_range.end_x)area_range.end_x=j;
                }
                else
                {
                    input[pos(i,j)] = 0x0000;
                }
            }
        }

        U16 right_y=0, left_y=0,mid_y=0;
        U32 right_y_cnt=0, right_y_sum=0;
        U32 left_y_cnt=0, left_y_sum=0;
        mid_y = area[temp_i-1].second.y;

        for(i=area_range.start_y;i<area_range.end_y;i++)
        {
            for(j=area_range.start_x;j<area_range.end_x;j++)
            {
                if(input[pos(i,j)] == 0xFFFF)
                {
                    if(j<=area_range.start_x+10)
                    {
                        right_y_cnt++;
                        right_y_sum+=i;
                    }
                    if(j>=area_range.start_x-10)
                    {
                        left_y_cnt++;
                        left_y_sum+=i;
                    }
                }
            }
        }

        right_y = right_y_sum / right_y_cnt;
        left_y = left_y_sum / left_y_cnt;

        printf("%d %d %d\n",mid_y, right_y, left_y);
        if(abs(mid_y - (right_y + left_y) / 2) <= 1)
        {
            //Line_Match;
            if(abs(left_y - right_y) <= 2){
                Motion_Command(SoundPlay);
            }
            else if(left_y < right_y)
            {
                Motion_Command(TURNLEFT);
            }
            else if(right_y > left_y)
            {
                Motion_Command(TURNRIGHT);
            }
        }
        else if(left_y < right_y)
        {
            //Turn left
            Motion_Command(TURNLEFT);
        }
        else
        {
            //Turn right
            Motion_Command(TURNRIGHT);
        }

        
        draw_fpga_video_data_full(input);
        flip();
        free(input);

        
    }
    else
    {
        IsRight = true;
        Motion_Command(HEAD_LEFT_90);
        delay();
        read_fpga_video_data(input);

        for(i=0;i<height;i++)
        {
            for(j=0;j<width;j++)
            {
                if(FindColor(input[pos(i,j)]) == IsBlack)
                {
                    input[pos(i,j)] = 0xFFFF;
                }
                else
                {
                    input[pos(i,j)] = 0x0000;
                }
            }
        }

        vector<pair<U32, POS> > area;
        Range range;

        range.start_x = 0;
        range.end_x = 90;
        range.start_y = 0;
        range.end_y = 120;

        ColorLabeling(0xFFFF,area,range,input);



        draw_fpga_video_data_full(input);
        flip();
        free(input);
    }
    return;
}

void ImageShow()
{
    short i, j;
    U16 *input = (U16*)malloc(2*180*120);
    read_fpga_video_data(input);
    U8 *gray = (U8*)malloc(180*120);
    U16 *histogram = (U16*)malloc(2*256);
    fill(histogram, histogram + 256, 0);

    U32 max_histo=0;

    for(i=0;i<height;i++)
    {
        for(j=0;j<width;j++)
        {
            gray[pos(i,j)]=make_gray(input[pos(i,j)]);
            if(gray[pos(i,j)]>max_histo)max_histo=gray[pos(i,j)];
            histogram[gray[pos(i,j)]]++;
            input[pos(i,j)] = 0x0000;
        }
    }
    
    for(i=0;i<height;i++)
    {
        for(j=0;j<width;j++)
        {
            if(i<=histogram[(U16)(j*1.5)])
            {
                input[pos(i,j)] = 0xFFFF;
            }
        }
    }

    draw_fpga_video_data_full(input);
    flip();
    free(input);
    free(gray);
    free(histogram);
    return;
}