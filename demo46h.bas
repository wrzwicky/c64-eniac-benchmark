!- ENIAC benchmark
!- Inspired by
!- “Reconstructing the Unveiling Demonstration of the ENIAC”
!- Brian L. Stuart, Drexel University
!- https://www.cs.drexel.edu/~bls96/eniac/
!- https://www.techrxiv.org/articles/preprint/Reconstructing_the_Unveiling_Demonstration_of_the_ENIAC/14538117

!- Also interesting:
!-  1954 Ballistics Research Lab report #889
!-   "On the computational procedures for firing and bombing tables"
!-   S. Gorn and M. L. Juncosa, Ballistic Research Laboratories
!-   https://apps.dtic.mil/sti/pdfs/AD0027123.pdf
!-  Later 1967 report #1371
!-   "THE PRODUCTION OF FIRING TABLES FOR CANNON ARTILLERY"
!-   Elizabeth R. Dickinson, Computing Laboratory
!-   https://apps.dtic.mil/sti/pdfs/AD0826735.pdf

5 fast
10 print "{clear}{white}eniac benchmark"
30 gosub 9000 : gosub 10000
!- 40 goto 5000

!- Demo 1: addition
!- -eniac took 1 sec
1000 print "{light green}1. addition{white}"
1010 ti$="000000"

1020 x=97367
1030 for i=1 to 5000
1040 y=x+x
1050 next

1090 print ti/60;"seconds"

!- Demo 2: multiplication
!- -eniac took 1 sec
2000 print "{light green}2. multiplication{white}"
2010 ti$="000000"

2020 w=13975
2030 for i=1 to 500
2040 x=w*w
2050 y=y+x
2060 next

2080 print ti/60;"seconds"
2090 print "sum=";y

!- Demo 3: squares and cubes
!- eniac did 1-100 in 1/10th sec
!- "Each square was generated from the previous number (x) and its square (x^2)
!- by means of the formula,
!-   (x+1)^2 = x^2 + 2x + 1
!- [..] and its cube (x^3) by means of the formula, 
!-   (x + 1)^3 = x^3 + 3x^2 + 3x + 1."

3000 print "{light green}3. squares and cubes{white}"
3010 ti$="000000"
3020 x=1 : x2=1 : x3=1
3030 rem print "x","x^2","x^3"
3040 rem print x,x2,x3
3050 for i=2 to 100
3060 x3=x3+3*x2+3*x+1
3070 x2=x2+2*x+1
3080 x=x+1
3090 rem print x,x2,x3
3100 next
3190 print ti/60;"seconds"

!- Demo 4: sines and cosines
!- no time given for eniac
!-   from identity for sin(a+b):
!-   sin(x+dx) = sin(x)cos(dx) + cos(x)sin(dx)
4000 print "{light green}4. sines and cosines{white}"
4010 ti$="000000"

4020 dx=0.0001 : a=1-cos(dx) : b=sin(dx) : rem delta x, a, b
4030 x=0 : sx=0 : cx=1 : rem x angle, sin(x), cos(x)

4035 print "x","sin","cos"
4040 for i=1 to 100
!- for small enough dx, a is close enough to 0
!- -- dn=delta sin; 'ds' is reserved on C128
!- 4050 dn=-a*sx+b*cx
!- 4060 dc=-a*cx-b*sx
4050 dn=b*cx
4060 dc=-b*sx
4070 sx=sx+dn
4090 cx=cx+dc
4100 x=x+dx
4110 rem print x,sx,cx
4120 next
4130 print ti/60;"seconds"

4140 print "computed",sx,cx
4150 print "actual",sin(x),cos(x)

!- Demo 5: artillery trajectory
!- ".. it is classified as secret"
!- ".. the ENIAC did in 15 seconds what a mathematician would require
!- several weeks to do."

5000 print "{light green}5. artillary sim{white}"

5008 rem 1550 ft/s, 22.5 deg
5010 v=1550 : a=22.5
5018 rem time step dt, gravity
5020 dt=0.02 : g=32
5030 rem -----
5032 def fnr(x)=int(x*100)/100
5035 print "t","x","y"
5040 ti$="000000"
5050 t=0 : x=0 : y=0
5060 xv=v*cos(a/180*pi) : yv=v*sin(a/180*pi)
!- 129s with consts; 118s with these vars
5070 c1=1e5 : c2=23000 : rem consts for line 5120

!- xv = 'x velocity' = x'
!- dx = 'delta x' = change in x this time step
!- xa = 'x acceleration' = xv' = x''

5099 print fnr(t),fnr(x),fnr(y)
5100 for i=1 to 50
5110 dx=xv*dt : dy=yv*dt
!- these fudge factors got me close to authors x=~34000 ft
!-5120 e=e((xv*xv+yv*yv)/c1)/c2
5120 v=sqr(xv*xv+yv*yv) : e=fne(v)
5130 xa=-(e*xv)*dt : ya=-(e*yv+g)*dt
5140 x=x+dx : y=y+dy
5150 xv=xv+xa : yv=yv+ya
5160 t=t+dt
5170 next
5180 if y>=0 then 5099

5380 print fnr(t),fnr(x),fnr(y)
5390 print ti/60;"seconds"


!- -- DRAG COEFFICIENT --

!-  * Stuart's drag table *

8999 end
9000 rem drag table
!- table is E for each value of v^2

9010 rem dim e(100)
9020 for i=0 to 99
9030 read e :rem (i)
9040 next
9050 return

!- This is the table from Stuart's ENIAC source.
!- I'm guessing at how to interpret the source and use the values.

9099 rem 105mm M1 shell
9100 data 0,52,73,88,93,102,114,128,136,181
9110 data 275,331,376,419,454,490,524,561,599,623
9120 data 639,659,675,690,709,719,725,734,738,741
9130 data 742,748,750,752,758,759,760,765,770,774
9140 data 779,783,787,791,791,794,794,797,799,802
9150 data 804,806,807,815,816,817,818,819,820,820
9160 data 820,827,827,834,834,839,840,840,844,845
9170 data 849,850,855,859,861,863,865,867,869,873
9180 data 876,878,881,884,886,887,889,889,892,894
9190 data 899,900,902,903,904,904,905,907,908,908


!- * My own drag table *

!- I used references from Stuart's paper, extracted the actual data, and 
!- calculate the E(v) table here. I can't quite figure out how to build
!- the E(v^2) table like Stuart, so I'm calculating actual v in the sim.

!- "Handbook of ballistic and engineering data for ammunition, volume II"
!- US Army Ballistic Research Laboratories, Aberdeen Proving Ground, Maryland
!- Tech. Rep., July 1950.
!- [Online]. Available: https://apps.dtic.mil/dtic/tr/fulltext/u2/a955369.pdf
!- -drag chart on PDF page 189
!-  -Converted to data using WebPlotDigitizer
!-   https://apps.automeris.io/wpd/

10000 rem drag coefficient chart
10002 rem in: p,tc,sm,sd -- hard coded here
10004 rem out: e(100) - drag factors
10006 rem out: fne(v) - convert v to drag factor

10010 data 0.44,0.04 : REM x-axis (Mach): origin, delta
10015 rem y-axis (K-D) follows:
10020 data 0.06, 0.0559, 0.0537, 0.0524, 0.052
10030 data 0.0521, 0.0527, 0.0536, 0.055, 0.057
10040 data 0.0599, 0.0641, 0.0703, 0.0828, 0.1358
10050 data 0.15, 0.1568, 0.1607, 0.1635, 0.1656
10060 data 0.1666, 0.1676, 0.1681, 0.1679, 0.1673
10070 data 0.1655, 0.1629, 0.16, 0.1573, 0.1543
10080 data 0.1517, 0.1489, 0.1466, 0.144, 0.1416
10090 data 0.1393, 0.1371, 0.135, 0.133, 0.1311
10100 data 0.1294, 0.1276, 0.1257, 0.1241, 0.1227
10110 data 0.1213, 0.1199, 0.1186, 0.1176, 0.1167
10120 data 0.1159, 0.115, 0.1144, 0.1137, 0.1133
10130 data 0.1129, 0.1127, -1


!- E=pvK/C
!-   E = drag value
!-   p = air density; v = velocity, K is drag coef (above table)
!-   C = ballistic coef of shell = mass/(diameter^2)

!- https://www.omnicalculator.com/physics/speed-of-sound#speed-of-sound-in-air
!-  -ss=(331 m/s)*sqr(1+T_C/273) : T_C = temp in degrees Celsius
!-  -claims speed does not depend on pressure or density
!-  -sea level, 59°F (15°C), 14.7 psi (1013.25 hPa) -> density is 0.0765 lb/(cu ft) (1.225 kg/(m^3))
!-  -As a rule of thumb, you can expect a drop of 0.0022−0.0023 lb/ft3 (0.035−0.036 kg/m3) per 1000 ft of altitude change.
!- https://en.wikipedia.org/wiki/Ballistic_coefficient
!-  -for small and large arms projectiles only is as follows: C=m/d^2*i
!-   -I assume i~=1
!-  -BC is kg/m2 or lb/in2
!- Handbook:
!-  -p195 ballistic coef varies per elevation and initial velocity
!-   -1550 f/s, 22.5 deg -> 2.15
!-   -wikipedia says use m/d^2 -> 1.93

10200 rem compute drag table
10210 p=.0765 : rem air density (lb/ft3)

10220 tc=15 : rem temp (deg c)
10230 ss=1087*sqr(1+tc/273) : rem speed of sound (ft/s)

10240 sm=33 : rem shell mass (lb)
10250 sd=4.134 : rem shell diameter (in)
10260 c=sm/sd/sd : rem shell ballistic coef (lb/in2)

10265 dim e(100)

!-10267 print "f/s","e"
10270 read m0,dm : rem x-axis = mach number
10280 m=m0 : for i=0 to 56
10290 read k : rem drag coef
10310 v=m*ss : rem velocity
10320 e(i)=p*k/c : rem drag factor (lb/ft3)
!-10322 j=int((v*v-241320.537)/155562)
!-10325 print i,j,v*v,e(i)
10330 m=m+dm
10340 next

10380 read k
10390 if k<>-1 then print "not all drag data processed!" : stop

10400 v0=m0*ss : v9=(m-dm)*ss
10410 v1=(v9-v0)/(i-1)

10430 def fne(v)=e((v-v0)/v1)

10900 return
