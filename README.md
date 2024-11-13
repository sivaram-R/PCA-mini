# Cuda Image Filter

This project is a CUDA-based image processing application that allows users to convert images to grayscale and mirror them horizontally. It utilizes the OpenCV library for image processing and the Boost library for command-line argument parsing.

## Algorithm
Initialize Libraries:

Initialize OpenCV for reading and writing images.
Initialize Boost to handle command-line options.
Parse Command-Line Arguments:

Parse input arguments for:
The image file to process.
Output file name.
Whether to mirror or convert to grayscale.
Read Input Image:

Use OpenCV to load the image into a Mat object.
Memory Allocation:

Allocate memory on the GPU for the input and output image using cudaMalloc.
Copy the input image from the host (CPU) memory to device (GPU) memory using cudaMemcpy.
CUDA Kernels:

If the --mirror option is provided, launch the mirrorImage kernel to mirror the image horizontally on the GPU.
If the --gray option is provided, launch the rgbtogray kernel to convert the image from RGB to grayscale on the GPU.
Synchronization:

Ensure the GPU kernels complete using cudaDeviceSynchronize.
Copy Output to Host:

Copy the processed image data from device memory back to host memory using cudaMemcpy.
Free Memory:

Free the allocated GPU memory with cudaFree.
Write Output Image:

Use OpenCV to write the processed image to disk.
Exit Program.
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

For example:

```bash
./imageFilter input.jpg -o output.jpg -m
```
