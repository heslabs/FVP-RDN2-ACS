# AI on Arm


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
