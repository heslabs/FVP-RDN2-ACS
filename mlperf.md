# MLPerf

---
### Setup Environment

```
apt-get update  
apt-get install -y build-essential python3-pip git wget && \
rm -rf /var/lib/apt/lists/*
pip3 install pybind11
pip3 install pybind11 --break-system-package
```

#### Clone the mlcommons/inference repository  
```
git clone --depth 1 --recurse-submodules https://github.com/mlcommons/inference.git mlperf_inference
```
#### Compile and install loadgen
```
cd ./mlperf_inference/loadgen
export CFLAGS="-std=c++14"
python3 setup.py develop --user
```

#### Replace mlperf_loadgen with mlcommons_loadgen in setup.py to workaround module rename problem
```
cd mlperf_inference/vision/classification_and_detection
sed -i 's/mlperf_loadgen/mlcommons_loadgen/g' setup.py
python3 setup.py develop
```


#### Install TensorFlow and TensorFlow-IO
```
pip install tensorflow tensorflow-io
pip install tensorflow tensorflow-io --break-system-packages
```

#### Set environment variables
```
export TF_ENABLE_ONEDNN_OPTS=1
export ONEDNN_DEFAULT_FPMATH_MODE=BF16
```


#### Download the model file and create a fake ImageNet dataset

```
wget -q https://zenodo.org/record/2535873/files/resnet50_v1.pb 
./tools/make_fake_imagenet.sh
    
## Set MODEL_DIR and DATA_DIR environment variables
export MODEL_DIR=./mlperf_inference/vision/classification_and_detection
export DATA_DIR=./mlperf_inference/vision/classification_and_detection/fake_imagenet
```

#### Launch mlperf testing
```
cd ~/mlperf/mlperf_inference/vision/classiifcaiton_and_Detection
./run_local.sh tf resnet50 cpu
```

#### Test result

``` 
```

---
### Build the Docker image

Build the Docker image that includes all necessary dependencies for running ML inference:

```
docker build -t mlperf_image .
```

### Launch MLPerf

Start a Docker container from the image and run the ML inference script for TensorFlow, ResNet50, on the CPU:

```
docker run -it mlperf_image /bin/bash -c "./run_local.sh tf resnet50 cpu; exec bash" 
```
