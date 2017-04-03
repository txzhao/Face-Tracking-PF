# FaceTracking_PF
============= "code" folder ==============
contains all the matlab file used for implementing face tracking. By running "main_ICM.m", you could generate the corresponding video with tracking bounding box
- center2corner.m: calculate a upper-left coordinate given a center coordinate
- colorDistribute.m: get color histogram of an image region
- corner2center.m: calculate a center coordinate given a upper-left coordinate
- faceDetect.m: detect a face region and return its state
- init_clr.m: initialize particles for color-based PF and histogram for the target
- init_mnt.m: initialize particles for moment-based PF and moment invariants for target
- init_particle.m: initialize particles and their states
- likelihood_clr.m: compute the similarity between a particle and the target for the color-based PF
- likelihood_mnt.m: compute the similarity between a particle and the target for the moment-based PF
- main_clr.m: main code with a simple color-based PF
- main_ICM.m: main code with an integrated PF
- momentDistribute.m: get moment invariants of an image region
- multinomial_resample.m: vanilla resampling
- propagate.m: prediction model used for propagating particles
- stateFusion.m: fuse method used for combining two posterior states into a final estimation
- systematic_resample.m: systematic resampling
- weight_clr.m: compute weights for particles of color-based observation model
- weight_mnt.m: compute weights for particles of moment-based observation model


============= "videos" folder ==============
- out_color+moment.avi: output video with color-based PF and moment-based PF; no particles are shown
- out_color+moment_particles.avi: output video with color-based PF and moment-based PF; particles are shown
- out_integrated_1.avi: output video with integrated PF, color-based PF and moment-based PF; input is in_1.mp4
- out_integrated_2.avi: output video with integrated PF, color-based PF and moment-based PF; input is in_2.mp4

