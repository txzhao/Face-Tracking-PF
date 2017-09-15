# Face-Tracking-PF
This is a repo for course project of [EL2320 Applied Estimation](https://www.kth.se/social/course/EL2320/) at KTH.

The project is an implementation of an [integrated face tracker](http://ieeexplore.ieee.org/abstract/document/5347867/) using [color-based](http://www.sciencedirect.com/science/article/pii/S0262885602001294) and moment-based particle filters. 

To test the functionality of the face tracker, videos of moving faces are fed into the system and particles as prediction are labeled in each frame of the video. Particles are in the represention of bounding boxes with different colors. The code is mainly done in Matlab. For more details, please read the [report](https://github.com/txzhao/Face-Tracking-PF/blob/master/doc/report.pdf).

## Pipeline

- Obtain initial state of the face target using Haar feature-based cascade classifier
- Generate particles around initial state and propagate them
- Measure histogram similarities between particles and face target for color-based and moment-based model
- Perform systematic resampling for particles
- Fuse estimations from color-based and moment-based model

## Contents

- In the "code" folder, run the script main_ICM.m to see how the integrated face tracker works; run the script main_clr.m to see how the color-based face tracker works alone.
- In the "videos" folder, "sample3.mp4" and "sample4.mp4" are input videos, and others are outputs from the face tracking system.
- In the "doc" folder, you can find the [report](https://github.com/txzhao/Face-Tracking-PF/blob/master/doc/report.pdf) with more details.

## Results

#### Color-based PF (left: with particles; right: without particles)
<p align="center">
<img src="https://github.com/txzhao/Face-Tracking-PF/blob/master/results/out_fast_particles.gif" width="300"/> <img src="https://github.com/txzhao/Face-Tracking-PF/blob/master/results/out_fast.gif" width="300"/>
</p>
*Red bounding boxes represent particles;* *blue bounding box represents posterior state.*

#### Integrated PF (left: with particles; right: without particles)
<p align="center">
<img src="https://github.com/txzhao/Face-Tracking-PF/blob/master/results/color-moment_particles.gif" width="300"/> <img src="https://github.com/txzhao/Face-Tracking-PF/blob/master/results/integrated_2.gif" width="300"/>
</p>
*Red and blue bounding boxes represent particles posterior state and from color-based model;* *yellow and black bounding boxes represent particles posterior state and from color-based model.*

#### Error performances of different particle filters
<p align="center">
<img src="https://github.com/txzhao/Face-Tracking-PF/blob/master/results/error.png"/>
</p>

## References

[color-based PF](http://www.sciencedirect.com/science/article/pii/S0262885602001294), [fusion method](http://ieeexplore.ieee.org/abstract/document/5347867/)
