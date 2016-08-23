# face-masker
Code (Matlab) for automatically putting a mask on a face in photographs. The code matches features between the mask and the face in the photo and warps the mask and merges it onto the face. Additionally, the code adds ears or a hat onto the photo.

In order to detect matching feature points in the faces and masks, a separate algorithm should be used (this repository does not include it). I have tested two feature detectors that worked well:
1. Face++ (http://www.faceplusplus.com/), in which feature detection is done in the cloud
2. Clandmark (http://cmp.felk.cvut.cz/~uricamic/clandmark/), an open source landmarking library

Masks should be stored as the basis image, feature points and blending mask (binary or gray scale weights).
The masks can also contain ears/hat/wig.
The feature points are detected by the same algorithm that you plan on using for photos, and can be shifted manually.
The blending masks are best when done manually with simple programs such as paint.

Read the report and look at the poster to learn more about this project.

!(https://cloud.githubusercontent.com/assets/19598320/17883585/3b96676c-68c8-11e6-9ae9-29140fca29ab.png)

