// Reproduction of (some of) demo46h.bas as C code for CC65 compiler.
// CC65 does not support floats, so artillary sim is missing.

#include <stdio.h>
#include <time.h>
#include <cbm_petscii_charmap.h>


#define C_WHITE   0x05
#define C_LTGREEN 0x99
#define C_CLS     0x93
#define C_HOME    0x13
#define C_RED     0x1c
#define C_GREEN   0x1e
#define C_BLUE    0x1f
#define C_DKPURP  0x81
#define C_BLACK   0x90
#define C_BROWN   0x95
#define C_PINK    0x96
#define C_DKCYAN  0x97
#define C_GRAY    0x98
#define C_GREY    0x98
#define C_LTBLUE  0x9a
#define C_LTGRAY  0x9b
#define C_PURPLE  0x9c
#define C_YELLOW  0x9e
#define C_CYAN    0x9f

void printtime(clock_t total) {
    int secs = total / CLOCKS_PER_SEC;
    // no floats :( compute 3 decimal places
    int decimal = ((unsigned long)(total % CLOCKS_PER_SEC)) * 1000 / 60;

    // round to 2 places
    decimal = (decimal + 5) / 10;
    if(decimal > 99) {
        decimal -= 100;
        secs++;
    }
    
    printf(" %d.%02d seconds\n", secs, decimal);
}


// Demo 1: addition
// -eniac took 1 sec
void demo1(void) {
    //unsigned is slower!
    long x, y;
    int i;
    clock_t start, end;

    printf("%c1. addition%c\n", C_LTGREEN, C_WHITE);

    x = 97367; y = 0;
    start = clock();
    for(i=0; i<5000; i++)
        y += x;
    end = clock();

    printf(" Sum: %ld\n", y);
    printtime(end-start);
}


// Demo 2: multiplication
// -eniac took 1 sec
void demo2(void) {
    long w, x, y;
    int i;
    clock_t start, end;

    printf("%c2. multiplication%c\n", C_LTGREEN, C_WHITE);

    w = 13975;
    start = clock();
    for(i=0; i<500; i++) {
        x = w*w;
        y = y+x;
    }
    end = clock();

    printf(" Sum: %ld\n", y);
    printtime(end-start);
}


// Demo 3: squares and cubes
// eniac did 1-100 in 1/10th sec
// "Each square was generated from the previous number (x) and its square (x^2)
// by means of the formula,
//   (x+1)^2 = x^2 + 2x + 1
// [..] and its cube (x^3) by means of the formula, 
//   (x + 1)^3 = x^3 + 3x^2 + 3x + 1."
void demo3(void) {
    int i;
    clock_t start, end;
    int x=1, x2=1; long x3=1;

    printf("%c3. squares and cubes%c\n", C_LTGREEN, C_WHITE);

    start = clock();
    //printf("%3s %5s %7s\n", "x", "x^2", "x^3");
    //printf("%3d %5d %7ld\n", x, x2, x3);
    for(i=2; i<=100; i++) {
        x3 = x3 + 3*x2 + 3*x + 1;
        x2 = x2 + 2*x + 1;
        x = x + 1;
        //printf("%3d %5d %7ld\n", x, x2, x3);
    }
    end = clock();

    printtime(end-start);
}


/*
Implements the 5-order polynomial approximation to sin(x).
@param i   angle (with 2^15 units/circle)
@return    16 bit fixed point Sine value (4.12) (ie: +4096 = +1 & -4096 = -1)

The result is accurate to within +- 1 count. ie: +/-2.44e-4.
https://www.nullhardware.com/blog/fixed-point-sine-and-cosine-for-embedded-systems/
*/
#define int16_t int
#define uint16_t unsigned int
#define uint32_t unsigned long
int16_t fpsin(int16_t i)
{
    uint32_t c, y;
    
    /* Convert (signed) input to a value between 0 and 8192. (8192 is pi/2, which is the region of the curve fit). */
    /* ------------------------------------------------------------------- */
    i <<= 1;
    c = i<0; //set carry for output pos/neg

    if(i == (i|0x4000)) // flip input value to corresponding value in range [0..8192)
        i = (1<<15) - i;
    i = (i & 0x7FFF) >> 1;
    /* ------------------------------------------------------------------- */

    /* The following section implements the formula:
     = y * 2^-n * ( A1 - 2^(q-p)* y * 2^-n * y * 2^-n * [B1 - 2^-r * y * 2^-n * C1 * y]) * 2^(a-q)
    Where the constants are defined as follows:
    */
    #define A1 3370945099UL
    #define B1 2746362156UL
    #define C1 292421UL
    #define n 13
    #define p 32
    #define q 31
    #define r 3
    #define a 12

    y = (C1*((uint32_t)i))>>n;
    y = B1 - (((uint32_t)i*y)>>r);
    y = (uint32_t)i * (y>>n);
    y = (uint32_t)i * (y>>n);
    y = A1 - (y>>(p-q));
    y = (uint32_t)i * (y>>n);
    y = (y+(1UL<<(q-a-1)))>>(q-a); // Rounding

    return c ? -y : y;
}

//Cos(x) = sin(x + pi/2)
#define fpcos(i) fpsin((int16_t)(((uint16_t)(i)) + 8192U))


// Demo 4: sines and cosines
// -- no float support here, code not ported
void demo4(void) {
    int i;
    clock_t start, end;
    int x=0, dx=100;
    
    printf("%c4. sines and cosines%c\n", C_LTGREEN, C_WHITE);
    x = 0;      printf(" sin(%d) = %d\n", x, fpsin(x));
    x = 100;    printf(" sin(%d) = %d\n", x, fpsin(x));
    x = 1000;   printf(" sin(%d) = %d\n", x, fpsin(x));
    x = 2<<12;  printf(" sin(%d) = %d\n", x, fpsin(x));

    start = clock();
    for(i=0; i<100; i++) {
        fpsin(x);
        fpcos(x);
        x += dx;
    }
    end = clock();

    printf(" %d sin+cos pairs\n", i);
    printtime(end-start);
}


void main(void)
{
    printf("%c%cENIAC Benchmark\n", C_CLS, C_WHITE);

    demo1();
    demo2();
    demo3();
    demo4();
}
