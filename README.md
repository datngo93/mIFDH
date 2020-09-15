# mIFDH

## Summary
This is the MATLAB source code of a haze removal algorithm, which dehazes a hazy input image using simple image enhancement techniques, such as detail enhancement, gamma correction, and single-scale image fusion. The computational flow is as follows:

***Input image*** **-->** ***Detail enhancement*** **-->** ***Gamma correction*** **-->** ***Dark channel prior-based weight maps calc.*** **-->** ***Single-scale image fusion*** **-->** ***Post-processing*** **-->** ***Output image***

This source code includes all computational steps, except for the adaptive tone remapping post-processing due to copyright restrictions.

## Run the code
Executing the file *mIFDH_demo.m* in **MATLAB R2019a** to view the hazy-dehazed results side-by-side.

## Qualitative results

*NOTE*: The results obtained by executing this source code are different from the qualitative results presented here. The reason is the exclusion of adaptive tone remapping post-processing.

![First](/results/more_results_1.jpg)
![Second](/results/more_results_2.jpg)
![Third](/results/more_results_3.jpg)
![Fourth](/results/more_results_4.jpg)
![Fifth](/results/more_results_5.jpg)
![Sixth](/results/more_results_6.jpg)
![Seventh](/results/more_results_7.jpg)

## Reference
In any publication related to the use of the source code, you are kindly requested to cite the following reference:
[Ngo, D.; Lee, S.; Nguyen, Q.-H.; Ngo, T.M.; Lee, G.-D.; Kang, B. Single Image Haze Removal from Image Enhancement Perspective for Real-Time Vision-Based Systems. Sensors 2020, 20, 5170.](https://www.mdpi.com/1424-8220/20/18/5170)
