from colorama import init as colorama_init, Fore, Style
import math
import plotext as plt
import time

# Demo 5: artillery trajectory
# ".. it is classified as secret"
# ".. the ENIAC did in 15 seconds what a mathematician would require
# several weeks to do."
def demo5(dragfunc):
    print(f"{Fore.GREEN}5. artillary sim{Style.RESET_ALL}")

    # 1550 ft/s, 22.5 deg
    v=1550
    a=22.5
    # time step dt, gravity
    dt=0.02
    g=32

    t=0
    x=0
    y=0
    print("{0:2} {1:6} {2:6}".format("t_", "___x__", "___y__"))

    xv = v * math.cos(a/180*math.pi)
    yv = v * math.sin(a/180*math.pi)

    x_dat = []
    y_dat = []

    # xv = 'x velocity' = x'
    # dx = 'delta x' = change in x this time step
    # xa = 'x acceleration' = xv' = x''

    start_t = time.perf_counter()
    while y >= 0:
        print("{0:2.0f} {1:6.0f} {2:6.0f}".format(t, x, y))
        x_dat.append(x)
        y_dat.append(y)

        for i in range(50):
            dx = xv*dt
            dy = yv*dt
            v = math.sqrt(xv*xv+yv*yv)
            e = dragfunc(v)

            xa = -(e*xv)*dt
            ya = -(e*yv+g)*dt
            x=x+dx
            y=y+dy
            xv=xv+xa
            yv=yv+ya
            t=t+dt

    print("{0:2.0f} {1:6.0f} {2:6.0f}".format(t, x, y))
    x_dat.append(x)
    y_dat.append(y)

    end_t = time.perf_counter()
    print("{:.5f} seconds".format((end_t-start_t)/60.0))

    return x_dat,y_dat


    
# * My own drag table *

# I used references from Stuart's paper, extracted the actual data, and 
# calculate the E(v) table here. I can't quite figure out how to build
# the E(v^2) table like Stuart, so I'm calculating actual v in the sim.

# "Handbook of ballistic and engineering data for ammunition, volume II"
# US Army Ballistic Research Laboratories, Aberdeen Proving Ground, Maryland
# Tech. Rep., July 1950.
# [Online]. Available: https://apps.dtic.mil/dtic/tr/fulltext/u2/a955369.pdf
# -drag chart on PDF page 189
#  -Converted to data using WebPlotDigitizer
#   https://apps.automeris.io/wpd/

# drag coefficient chart
# in: p,tc,sm,sd -- hard coded here
# out: e(100) - drag factors
# out: fne(v) - convert v to drag factor

x_axis = [0.44, 0.04] #x-axis (Mach): origin, delta
y_axis = [ #y-axis (K-D) follows:
    0.06, 0.0559, 0.0537, 0.0524, 0.052,
    0.0521, 0.0527, 0.0536, 0.055, 0.057,
    0.0599, 0.0641, 0.0703, 0.0828, 0.1358,
    0.15, 0.1568, 0.1607, 0.1635, 0.1656,
    0.1666, 0.1676, 0.1681, 0.1679, 0.1673,
    0.1655, 0.1629, 0.16, 0.1573, 0.1543,
    0.1517, 0.1489, 0.1466, 0.144, 0.1416,
    0.1393, 0.1371, 0.135, 0.133, 0.1311,
    0.1294, 0.1276, 0.1257, 0.1241, 0.1227,
    0.1213, 0.1199, 0.1186, 0.1176, 0.1167,
    0.1159, 0.115, 0.1144, 0.1137, 0.1133,
    0.1129, 0.1127
]

# E=pvK/C
#   E = drag value
#   p = air density; v = velocity, K is drag coef (above table)
#   C = ballistic coef of shell = mass/(diameter^2)

# https://www.omnicalculator.com/physics/speed-of-sound#speed-of-sound-in-air
#  -ss=(331 m/s)*sqr(1+T_C/273) : T_C = temp in degrees Celsius
#  -claims speed does not depend on pressure or density
#  -sea level, 59°F (15°C), 14.7 psi (1013.25 hPa) -> density is 0.0765 lb/(cu ft) (1.225 kg/(m^3))
#  -As a rule of thumb, you can expect a drop of 0.0022−0.0023 lb/ft3 (0.035−0.036 kg/m3) per 1000 ft of altitude change.
# https://en.wikipedia.org/wiki/Ballistic_coefficient
#  -for small and large arms projectiles only is as follows: C=m/d^2*i
#   -I assume i~=1
#  -BC is kg/m2 or lb/in2
# Handbook:
#  -p195 ballistic coef varies per elevation and initial velocity
#   -1550 f/s, 22.5 deg -> 2.15
#   -wikipedia says use m/d^2 -> 1.93

# compute drag table
def makeDragTable():

    p = .0765 #air density (lb/ft3)

    tc = 15 #temp (deg c)
    ss = 1087*math.sqrt(1+tc/273) #speed of sound (ft/s)

    sm = 33 #shell mass (lb)
    sd = 4.134 #diameter (in)
    c = sm/sd/sd #shell ballistic coef (lb/in2)

    e = []

    m0,dm = x_axis
    m = m0
    for k in y_axis:
        v = m * ss #velocity
        e.append(p*k/c) #drag factor (lb/ft3)
        m = m + dm

    v0 = m0*ss
    v9 = (m - dm) * ss
    dv = (v9-v0)/(len(e)-1)

    return lambda v: e[int((v-v0)/dv)]


if __name__ == "__main__":
    colorama_init()
    x,y = demo5(makeDragTable())

    plt.plot(x,y)
    #plt.title("Line Plot")
    plt.show()
