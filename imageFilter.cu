#include<iostream>
#include<opencv2/core.hpp>
#include<opencv2/imgcodecs.hpp>
#include<opencv2/highgui.hpp>
#include <boost/program_options.hpp>

using namespace std;
using namespace cv;
using namespace boost::program_options;

__global__ void rgbtogray(unsigned char *input, unsigned char *output, int numRows, int numCols, int step) {
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    int row = blockIdx.y * blockDim.y + threadIdx.y;

    if (col >= numCols || row >= numRows) return;

    int tid = row * step + 3 * col;
    unsigned char r = input[tid];
    unsigned char g = input[tid + 1];
    unsigned char b = input[tid + 2];

    output[row * numCols + col] = static_cast<unsigned char>(r * 0.299f + g * 0.587f + b * 0.114f);
}

__global__ void mirrorImage(unsigned char* input, unsigned char* output, int numRows, int numCols, int channels, int step) {
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    int row = blockIdx.y * blockDim.y + threadIdx.y;

    if (col >= numCols || row >= numRows) return;

    int tid = row * step + (channels * col);
    int tid_new = row * step + (channels * (numCols - col - 1));

    for(int i = 0; i < channels; i++)
        output[tid_new + i] = input[tid + i];
}

void checkCudaError(cudaError_t result, const char *function) {
    if (result != cudaSuccess) {
        cerr << "CUDA Error in " << function << ": " << cudaGetErrorString(result) << endl;
        exit(-1);
    }
}

int main(int argc, char **argv) {
    options_description desc("Allowed Options");
    desc.add_options()
        ("help,h", "Display help screen")
        ("output,o", value<string>()->default_value("output.jpg"), "Specify output file name")
        ("mirror,m", "Mirror the image")
        ("gray,g", "RGB to grayscale conversion");

    variables_map vm;
    store(parse_command_line(argc, argv, desc), vm);
    notify(vm);

    if(vm.count("help") || argc < 2){
        cout << desc << "\n";
        return 1;
    }

    string input_file = argv[1];
    string output_file = vm["output"].as<string>();

    Mat input = imread(input_file, IMREAD_COLOR);
    if(input.empty()) {
        cerr << "Image Not Found: " << input_file << endl;
        return -1;
    }

    Mat output(input.rows, input.cols, input.type());
    dim3 block_size(16, 16);
    dim3 num_blocks((input.cols + block_size.x - 1) / block_size.x, (input.rows + block_size.y - 1) / block_size.y);

    unsigned char *d_input, *d_output;
    size_t numBytes = input.step * input.rows;
    checkCudaError(cudaMalloc<unsigned char>(&d_input, numBytes), "cudaMalloc d_input");
    checkCudaError(cudaMalloc<unsigned char>(&d_output, numBytes), "cudaMalloc d_output");
    checkCudaError(cudaMemcpy(d_input, input.ptr(), numBytes, cudaMemcpyHostToDevice), "cudaMemcpy HostToDevice");

    if(vm.count("mirror")) {
        mirrorImage<<<num_blocks, block_size>>>(d_input, d_output, input.rows, input.cols, input.channels(), input.step);
    } else if(vm.count("gray")) {
        rgbtogray<<<num_blocks, block_size>>>(d_input, d_output, input.rows, input.cols, input.step);
    }

    checkCudaError(cudaDeviceSynchronize(), "cudaDeviceSynchronize");
    checkCudaError(cudaMemcpy(output.ptr(), d_output, numBytes, cudaMemcpyDeviceToHost), "cudaMemcpy DeviceToHost");

    cudaFree(d_input);
    cudaFree(d_output);

    imwrite(output_file, output);

    return 0;
}