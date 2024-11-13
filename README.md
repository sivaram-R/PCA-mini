# Cuda Image Filter

This project is a CUDA-based image processing application that allows users to convert images to grayscale and mirror them horizontally. It utilizes the OpenCV library for image processing and the Boost library for command-line argument parsing.

## Example

Original image:
<p align="center">
  <img  src="output/animal.jpg" alt="alt text" width="50%" height="50%" title="Box filtering using GPU">
</p>
Filtered image (Grayscale): 
<p align="center">
  <img  src="output/animal-gray.jpg" alt="alt text" width="50%" height="50%" title="Box filtering using GPU">
</p>
Filtered image (Mirror): 
<p align="center">
  <img  src="output/animal-mirror.jpg" alt="alt text" width="50%" height="50%" title="Box filtering using GPU">
</p>

## Prerequisites

Before running the program, ensure you have the following dependencies installed:

- NVIDIA CUDA Toolkit
- OpenCV (>= 2.4)

## Compilation

Compile the code using NVCC with the following command:

```bash
nvcc -arch=sm_37 imageFilter.cu -o imageFilter -lboost_program_options `pkg-config opencv --cflags --libs`
```

The -arch=sm_37 flag specifies the compute capability of the GPU architecture targeted for compilation. In this case, it targets devices with compute capability 3.7. Adjust this flag according to your GPU's compute capability if necessary. You can find the compute capability of your GPU in the NVIDIA documentation.

## Usage
Run the compiled executable with the following command:
```bash
./imageFilter input_image [options]
```

Replace input_image with the path to your input image. You can also specify the following options:

-   -o, --output: Specify the output file name (default is "output.jpg").
-   -m, --mirror: Mirror the input image.
-   -g, --gray: Convert the input image to grayscale.

For example:

```bash
./imageFilter input.jpg -o output.jpg -m
```
