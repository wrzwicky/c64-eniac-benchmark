# c64-eniac-benchmark
ENIAC demo benchmark, ported to Commodore 64. Code and ideas taken from Brian L. Stuart.

Project developed with CBM Prg Studio, and tested with VICE.

Everyone seems to say that the "first" computer was used to compute ballistic trajectories for cannon fire, but nobody provides references or code. That was until just a few years ago, when Brian L. Stuart reverse-engineered the unveiling demonstration of the ENIAC computer. Original data was hard to find, but Stuart found reports of the event and pictures of the machine, and was able to build something pretty close to that demonstration.

* [Stuart's reenactment of the demo](https://www.youtube.com/watch?v=SGBT2Danh-g)
* [The corresponding paper](https://www.techrxiv.org/articles/preprint/Reconstructing_the_Unveiling_Demonstration_of_the_ENIAC/14538117)
* [Code for the demo](ENIAC sim and demo: https://github.com/blstuart/eniac-simulator)
* [Stuart's ENIAC page](https://www.cs.drexel.edu/~bls96/eniac/)

Given the time scales involved, I thought it might be fun to reproduce this software on my favorite home computer to compare the performance of a giant room-filling computer to a toy 8-bit computer. The result is that the Commodore is a dream  to program due to it's vast 64k of RAM and friendly BASIC language environment. But the ENIAC is still quite a bit faster due to:
* ENIAC has hardware multipliers, and is apparently able to run some operations in parallel
* Commodore has no library for integer math; all numbers are processed as floating point.
