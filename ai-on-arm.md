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
