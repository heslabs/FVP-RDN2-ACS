# AI on Arm


---
### RDN2

```
(zenv) root@rdn2:~/labs/AI-on-Arm# python3 ./bench_table.py
   mSize  Latency(s)  Latency(s)  Latency(s)  Latency(s)  Latency(s)  Latency(s)
0     32    0.000040         1.0    0.000003        13.0    0.000002        20.0
1     64    0.000317         1.0    0.000019        17.0    0.000010        32.0
2    128    0.002520         1.0    0.000149        17.0    0.000077        33.0
3    256    0.020093         1.0    0.001161        17.0    0.000591        34.0
4    512    0.160490         1.0    0.009167        18.0    0.004624        35.0
(zenv) root@rdn2:~/labs/AI-on-Arm# 

```

---
### Log

```
+-----------------------------------------------------
| Benchmarking - navie.c
+-----------------------------------------------------
gcc -O0 -S -march=armv8-a+simd src/c/kernels/naive.c -o bin/naive.s
gcc -O0 src/c/benchmark_naive.c -o bin/benchmark_naive -march=armv8-a+simd -lm
./bin/benchmark_naive
Naive Matrix Multiplication (Size 32): 0.000040 seconds
Naive Matrix Multiplication (Size 64): 0.000317 seconds
Naive Matrix Multiplication (Size 128): 0.002520 seconds
Naive Matrix Multiplication (Size 256): 0.020093 seconds
Naive Matrix Multiplication (Size 512): 0.160490 seconds

+-----------------------------------------------------
| Benchmarking - fp32_neon.c
+-----------------------------------------------------
gcc -O3 -S -march=armv8-a+simd src/c/kernels/fp32_neon.c -o bin/fp32_neon.s
gcc -O3 -ffast-math src/c/benchmark_fp32_neon.c -o bin/benchmark_fp32_neon -march=armv8-a+simd -lm
./bin/benchmark_fp32_neon
FP32 NEON Matrix Multiplication (Size 32): 0.000003 seconds
FP32 NEON Matrix Multiplication (Size 64): 0.000019 seconds
FP32 NEON Matrix Multiplication (Size 128): 0.000149 seconds
FP32 NEON Matrix Multiplication (Size 256): 0.001161 seconds
FP32 NEON Matrix Multiplication (Size 512): 0.009167 seconds



+-----------------------------------------------------
| Benchmarking - int8_neon.c
+-----------------------------------------------------
gcc -O3 -S -march=armv8-a+simd src/c/kernels/int8_neon.c -o bin/int8_neon.s
gcc -O3 -ffast-math src/c/benchmark_int8_neon.c -o bin/benchmark_int8_neon -march=armv8-a+simd -lm
./bin/benchmark_int8_neon
Int8 Neon Matrix Multiplication (Size 32): 0.000002 seconds
Int8 Neon Matrix Multiplication (Size 64): 0.000010 seconds
Int8 Neon Matrix Multiplication (Size 128): 0.000077 seconds
Int8 Neon Matrix Multiplication (Size 256): 0.000591 seconds
Int8 Neon Matrix Multiplication (Size 512): 0.004624 seconds

```

---
### Setup

```
apt install -y python3.12-venv
```

```
apt install -y gh
gh repo clone arm-university/AI-on-Arm
git clone https://github.com/arm-university/AI-on-Arm
```

```
python3.12 -m venv aienv
python3.12 -m pip install --upgrade pip
python3.12 -m pip install --upgrade \
    numpy \
    matplotlib \
    pandas \
    torch \
    transformers \
    jupyterlab \
    ipykernel \
    ipywidgets \
    seaborn \
    sentencepiece
```

#### Activate your environment using:
```
source pi5_env/bin/activate
```
