close all;
clear;
clc;

addpath(genpath('source_code/'));

img = imread('08_ori.png');

figure;
imshow([double(img)/255,IFDH_rev_no_pyramid_v3(img)]);
