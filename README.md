# Face-Tracking-PF

This is a repo for course project of [EL2320 Applied Estimation](https://www.kth.se/social/course/EL2320/) at KTH. This project is an implementation of an [integrated face tracker](http://ieeexplore.ieee.org/abstract/document/5347867/) using [color-based](http://www.sciencedirect.com/science/article/pii/S0262885602001294) and [moment-based](http://ieeexplore.ieee.org/abstract/document/5347867/) particle filters (PFs). 

To test the functionality of the face tracker, videos of moving faces are fed into the system and particles as prediction are labeled in each frame of the video. Particles are in the represention of bounding boxes with different colors. The code is mainly done in Matlab. For more details, please read the [report](https://github.com/txzhao/Face-Tracking-PF/blob/master/doc/report.pdf).

## Pipeline

- Obtain initial state of the face target using Haar feature-based cascade classifier
- Generate particles around initial state and propagate them
- Measure histogram similarities between particles and face target for color-based and moment-based model
- Perform systematic resampling for particles
- Fuse estimations from color-based and moment-based model

## Contents

- In the "code" folder, run the script ```main_ICM.m``` to see how the integrated face tracker works; run the script ```main_clr.m``` to see how the color-based face tracker works alone.
- In the "videos" folder, ```sample3.mp4``` and ```sample4.mp4``` are input videos, and the others are outputs from the face tracking system.
- In the "doc" folder, you can find the [report](https://github.com/txzhao/Face-Tracking-PF/blob/master/doc/report.pdf) with more details.

## Results

#### Color-based PF (left: particles + posterior state; right: posterior state)

*Red* bounding boxes represent *particles*; *blue* bounding box represents *posterior state*.
<p align="center">
<img src="https://github.com/txzhao/Face-Tracking-PF/blob/master/results/out_fast_particles.gif" width="300"/> <img src="https://github.com/txzhao/Face-Tracking-PF/blob/master/results/out_fast.gif" width="300"/>
</p>

#### Integrated PF (left: particles + posterior state; right: posterior state)

*Red* and *blue* bounding boxes represent *particles* and *posterior state* from color-based model; *yellow* and *black* bounding boxes represent *particles* and *posterior state* from color-based model.
<p align="center">
<img src="https://github.com/txzhao/Face-Tracking-PF/blob/master/results/color-moment_particles.gif" width="300"/> <img src="https://github.com/txzhao/Face-Tracking-PF/blob/master/results/integrated_2.gif" width="300"/>
</p>

#### Error performances of different particle filters

<p align="center">
<img src="https://github.com/txzhao/Face-Tracking-PF/blob/master/results/error.png"/>
</p>

## Findings

- Moment-based PF performs better dynamically and responds quickly when target changes its moving direction;
- Color-based PF is more stable but responds relatively slowly compared with moment-based PF;
- Integrated PF takes advantages of the above two PFs and outperforms them in general.

## References

**[1]** Nummiaro, Katja, Esther Koller-Meier, and Luc Van Gool. "**An adaptive color-based particle filter.**" Image and vision computing 21.1 (2003): 99-110. [[paper]](http://www.sciencedirect.com/science/article/pii/S0262885602001294)

**[2]** Junxiang, Gao, Zhou Tong, and Liu Yong. "**Face tracking using color histograms and moment invariants.**" Broadband Network & Multimedia Technology, 2009. IC-BNMT'09. 2nd IEEE International Conference on. IEEE, 2009. [[paper]](http://ieeexplore.ieee.org/abstract/document/5347867/)
