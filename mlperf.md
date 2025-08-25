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
root@rdn2:~/mlperf# make run
export MODEL_DIR=/root/mlperf/mlperf_inference/vision/classification_and_detection && \
export DATA_DIR=/root/mlperf/mlperf_inference/vision/classification_and_detection/fake_imagenet && \
cd ~/mlperf/mlperf_inference/vision/classification_and_detection && \
./run_local.sh tf resnet50 cpu
python3 python/main.py --profile resnet50-tf --model "/root/mlperf/mlperf_inference/vision/classification_and_detection/resnet50_v1.pb" --dataset-path /root/mlperf/mlperf_inference/vision/classification_and_detection/fake_imagenet --output "/root/mlperf/mlperf_inference/vision/classification_and_detection/output/tf-cpu/resnet50"
INFO:main:Namespace(dataset='imagenet', dataset_path='/root/mlperf/mlperf_inference/vision/classification_and_detection/fake_imagenet', dataset_list=None, data_format=None, profile='resnet50-tf', scenario='SingleStream', max_batchsize=32, model='/root/mlperf/mlperf_inference/vision/classification_and_detection/resnet50_v1.pb', output='/root/mlperf/mlperf_inference/vision/classification_and_detection/output/tf-cpu/resnet50', inputs=['input_tensor:0'], outputs=['ArgMax:0'], backend='tensorflow', device=None, model_name='resnet50', threads=16, qps=None, cache=0, cache_dir=None, preprocessed_dir=None, use_preprocessed_dataset=False, accuracy=False, find_peak_performance=False, debug=False, user_conf='user.conf', audit_conf='audit.config', time=None, count=None, performance_sample_count=None, max_latency=None, samples_per_query=8)
2025-08-24 02:55:09.584249: I tensorflow/core/util/port.cc:153] oneDNN custom operations are on. You may see slightly different numerical results due to floating-point round-off errors from different computation orders. To turn them off, set the environment variable `TF_ENABLE_ONEDNN_OPTS=0`.
2025-08-24 02:55:09.769036: I tensorflow/core/util/port.cc:153] oneDNN custom operations are on. You may see slightly different numerical results due to floating-point round-off errors from different computation orders. To turn them off, set the environment variable `TF_ENABLE_ONEDNN_OPTS=0`.
INFO:imagenet:Preprocessing 8 images using 8 threads
INFO:imagenet:loaded 8 images, cache=0, already_preprocessed=False, took=0.0sec
WARNING:tensorflow:From /root/mlperf/mlperf_inference/vision/classification_and_detection/python/backend_tf.py:55: FastGFile.__init__ (from tensorflow.python.platform.gfile) is deprecated and will be removed in a future version.
Instructions for updating:
Use tf.gfile.GFile.
WARNING:tensorflow:From /usr/local/lib/python3.12/dist-packages/tensorflow/python/tools/strip_unused_lib.py:84: extract_sub_graph (from tensorflow.python.framework.graph_util_impl) is deprecated and will be removed in a future version.
Instructions for updating:
This API was designed for TensorFlow v1. See https://www.tensorflow.org/guide/migrate for instructions on how to migrate your code to TensorFlow v2.
WARNING:tensorflow:From /usr/local/lib/python3.12/dist-packages/tensorflow/python/tools/optimize_for_inference_lib.py:138: remove_training_nodes (from tensorflow.python.framework.graph_util_impl) is deprecated and will be removed in a future version.
Instructions for updating:
This API was designed for TensorFlow v1. See https://www.tensorflow.org/guide/migrate for instructions on how to migrate your code to TensorFlow v2.
WARNING: All log messages before absl::InitializeLog() is called are written to STDERR
I0000 00:00:1756004124.350247   10114 mlir_graph_optimization_pass.cc:437] MLIR V1 optimization pass is not enabled
```


---
<img width="1200" height="1446" alt="image" src="https://github.com/user-attachments/assets/e5c2f1e7-350e-4814-a656-152b09ff722e" />

---
<img width="1200" height="1574" alt="image" src="https://github.com/user-attachments/assets/6497a11c-ba5f-4894-9c6f-9c315d2df3a5" />


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


---
### RPI5 Log file 

```
### ~/mlperf/mlperf_inference/vision/classification_and_detection/output/tf-cpu/resnet50
================================================
MLPerf Results Summary
================================================
SUT name : PySUT
Scenario : SingleStream
Mode     : PerformanceOnly 
90.0th percentile latency (ns) : 142341090
Result is : VALID
  Min duration satisfied : Yes
  Min queries satisfied : Yes
  Early stopping satisfied: Yes
Early Stopping Result:
 * Processed at least 64 queries (4282).
 * Would discard 381 highest latency queries.
 * Early stopping 90.0th percentile estimate: 142483489
 * Early stopping 99.0th percentile estimate: 170929776

================================================
Additional Stats
================================================
QPS w/ loadgen overhead         : 7.13
QPS w/o loadgen overhead        : 7.13

Min latency (ns)                : 133968450
Max latency (ns)                : 195128903
Mean latency (ns)               : 140157741
50.00 percentile latency (ns)   : 139674517
90.00 percentile latency (ns)   : 142341090
95.00 percentile latency (ns)   : 143368221
97.00 percentile latency (ns)   : 144165979
99.00 percentile latency (ns)   : 154753629
99.90 percentile latency (ns)   : 191204452

================================================
Test Parameters Used
================================================
samples_per_query : 1
target_qps : 100
target_latency (ns): 0
max_async_queries : 1
min_duration (ms): 600000
max_duration (ms): 0
min_query_count : 100
max_query_count : 0
qsl_rng_seed : 1780908523862526354
sample_index_rng_seed : 14771362308971278857
schedule_rng_seed : 18209322760996052031
accuracy_log_rng_seed : 0
accuracy_log_probability : 0
accuracy_log_sampling_target : 0
print_timestamps : 0
performance_issue_unique : 0
performance_issue_same : 0
performance_issue_same_index : 0
performance_sample_count : 1024

No warnings encountered during test.

No errors encountered during test.
```

---

<img width="1200" height="1443" alt="image" src="https://github.com/user-attachments/assets/2883b4c4-4d3e-4a22-b211-026bcbe26b17" />

---

<img width="1200" height="1681" alt="image" src="https://github.com/user-attachments/assets/4549682f-6ebb-4fbb-920f-953214b1b663" />


