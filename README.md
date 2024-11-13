# Cuda Image Filter

This project is a CUDA-based image processing application that allows users to convert images to grayscale and mirror them horizontally. It utilizes the OpenCV library for image processing and the Boost library for command-line argument parsing.

## Theory
This program demonstrates basic image processing using CUDA for parallel computing. It allows two transformations on an image: grayscale conversion and horizontal mirroring. The program accelerates these operations using the GPU, significantly improving performance, especially for large images. The key components are:                                                              

CUDA Kernels:                                                                                               

rgbtogray: Converts an RGB image to grayscale using the weighted sum method for each pixel (Gray = 0.299*R + 0.587*G + 0.114*B).                                             
mirrorImage: Mirrors the image horizontally by swapping pixels from the left side with those on the right side.                                          
Image Processing on GPU:                                                              

The program allocates memory on the GPU for the input and output images.                                                     
It processes the image in parallel using CUDA threads, where each thread works on a single pixel or a group of pixels, depending on the grid/block configuration.                                            
OpenCV:                                                                        

OpenCV is used to load the input image and save the processed image after the CUDA kernel has completed.                                                             
Command-Line Interface:                                                                      

The program uses Boost Program Options to allow users to specify the input image, output image, and the desired transformation (grayscale or mirror).                                            
By leveraging CUDA, the program can process large images much faster than traditional CPU-based approaches by taking advantage of parallelism on the GPU.                               

## Algorithm                                                                                               
1.Parse command-line arguments for input file, output file, and transformation options (mirror/gray).                                                                    
2.Load input image using OpenCV.                                                              
3.Allocate memory on GPU for input and output images.                                                      
4.Copy input image from host to device (GPU).                                                             
5.Launch CUDA kernel:                                                                            
6.If --mirror option is set, apply mirror transformation.                                                            
7.If --gray option is set, convert the image to grayscale.                                                         
8.Synchronize GPU to ensure the kernel finishes processing.                                                         
9.Copy output image from device back to host.                                               
10.Save output image to file using OpenCV.                                                              
11.Free GPU memory.                                                                           
12.Exit the program.

## Outputs

Original image:
<p align="center">
  <img  src="animal.jpg" alt="alt text" width="50%" height="50%" title="Box filtering using GPU">
</p>
Filtered image (Grayscale): 
<p align="center">
  <img  src="animal-gray.jpg" alt="alt text" width="50%" height="50%" title="Box filtering using GPU">
</p>
Filtered image (Mirror): 
<p align="center">
  <img  src="animal-mirror.jpg" alt="alt text" width="50%" height="50%" title="Box filtering using GPU">
</p>

## Result
The program converts the input image to either grayscale or a mirrored version based on the user's choice. The result is saved as an output image file, either in grayscale or with the left-right mirrored transformation applied.
