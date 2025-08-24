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
cd mlperf_inference/vision/classification_and_detection
wget -q https://zenodo.org/record/2535873/files/resnet50_v1.pb 
./tools/make_fake_imagenet.sh
    
## Set MODEL_DIR and DATA_DIR environment variables
export MODEL_DIR=~/mlperf_inference/vision/classification_and_detection
export DATA_DIR=~/mlperf_inference/vision/classification_and_detection/fake_imagenet
```

#### Launch mlperf testing
```
cd ~/mlperf/mlperf_inference/vision/classification_and_detection
./run_local.sh tf resnet50 cpu
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


---
### RDN2 MLPerf Results

```

```

---
### RPI5 MLPerf Results

```
demo@rx66h:~/mlperf$ make run
export MODEL_DIR=/home/demo/mlperf/mlperf_inference/vision/classification_and_detection && \
export DATA_DIR=/home/demo/mlperf/mlperf_inference/vision/classification_and_detection/fake_imagenet && \
cd ~/mlperf/mlperf_inference/vision/classification_and_detection && \
./run_local.sh tf resnet50 cpu
python3 python/main.py --profile resnet50-tf --model "/home/demo/mlperf/mlperf_inference/vision/classification_and_detection/resnet50_v1.pb" --dataset-path /home/demo/mlperf/mlperf_inference/vision/classification_and_detection/fake_imagenet --output "/home/demo/mlperf/mlperf_inference/vision/classification_and_detection/output/tf-cpu/resnet50"
INFO:main:Namespace(dataset='imagenet', dataset_path='/home/demo/mlperf/mlperf_inference/vision/classification_and_detection/fake_imagenet', dataset_list=None, data_format=None, profile='resnet50-tf', scenario='SingleStream', max_batchsize=32, model='/home/demo/mlperf/mlperf_inference/vision/classification_and_detection/resnet50_v1.pb', output='/home/demo/mlperf/mlperf_inference/vision/classification_and_detection/output/tf-cpu/resnet50', inputs=['input_tensor:0'], outputs=['ArgMax:0'], backend='tensorflow', device=None, model_name='resnet50', threads=4, qps=None, cache=0, cache_dir=None, preprocessed_dir=None, use_preprocessed_dataset=False, accuracy=False, find_peak_performance=False, debug=False, user_conf='user.conf', audit_conf='audit.config', time=None, count=None, performance_sample_count=None, max_latency=None, samples_per_query=8)
INFO:imagenet:Preprocessing 8 images using 4 threads
INFO:imagenet:loaded 8 images, cache=0, already_preprocessed=False, took=0.1sec
WARNING:tensorflow:From /home/demo/mlperf/mlperf_inference/vision/classification_and_detection/python/backend_tf.py:55: FastGFile.__init__ (from tensorflow.python.platform.gfile) is deprecated and will be removed in a future version.
Instructions for updating:
Use tf.gfile.GFile.
WARNING:tensorflow:From /home/demo/.local/lib/python3.11/site-packages/tensorflow/python/tools/strip_unused_lib.py:84: extract_sub_graph (from tensorflow.python.framework.graph_util_impl) is deprecated and will be removed in a future version.
Instructions for updating:
This API was designed for TensorFlow v1. See https://www.tensorflow.org/guide/migrate for instructions on how to migrate your code to TensorFlow v2.
WARNING:tensorflow:From /home/demo/.local/lib/python3.11/site-packages/tensorflow/python/tools/optimize_for_inference_lib.py:136: remove_training_nodes (from tensorflow.python.framework.graph_util_impl) is deprecated and will be removed in a future version.
Instructions for updating:
This API was designed for TensorFlow v1. See https://www.tensorflow.org/guide/migrate for instructions on how to migrate your code to TensorFlow v2.
2025-08-24 13:59:12.032363: I tensorflow/compiler/mlir/mlir_graph_optimization_pass.cc:388] MLIR V1 optimization pass is not enabled
INFO:main:starting TestScenario.SingleStream
TestScenario.SingleStream qps=7.13, mean=0.1400, time=600.354, queries=4282, tiles=50.0:0.1395,80.0:0.1411,90.0:0.1421,95.0:0.1432,99.0:0.1523,99.9:0.1907
```
