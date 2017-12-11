% Bruce Nelson
% Lecture 09

%Surf function for detecting toys

close all; clear all; clc;

imgArr = [];

I1 = imread('base.jpg');
I2 = imread('sub.jpg');
I3 = imread('toy.jpg');
I4 = imread('toy1.jpg');
I5 = imread('toy2.jpg');
I6 = imread('toy3.jpg');
I7 = imread('toys.jpg');

MySurf(I1,I2);
pause();
MySurf(I7,I3);
pause();
MySurf(I7,I4);
pause();
MySurf(I7,I5);
pause();
MySurf(I7,I6);
pause();