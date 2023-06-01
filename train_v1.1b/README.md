# Train KoAlpaca Polyglot-12.8b v1.1b using DeepSpeed

## 설치

```bash
pip install -r requirements.txt
```

## 데이터 설정

- 데이터는 `KoAlpaca_v1.1a_textonly.json` 파일을 사용합니다.
- 해당 데이터는 Root 디렉토리의 `KoAlpaca_v1.1.jsonl`을, `### 질문: ...\n\n### 답변: ...<|endoftext|>`꼴로 변환한 `text` 컬럼만 있는 json 파일입니다.

## polyglot-ko-5.8b 모델 학습 w/ 단일 GPU (A100 80G x1)

```bash
chmod +x train_polyglot5.8b_singleA100.sh
./train_polyglot5.8b_singleA100.sh
```

위 코드로 학습시 아래와 같이 약 70GB의 Vram을 사용합니다.

```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 520.61.05    Driver Version: 520.61.05    CUDA Version: 11.8     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA A100-SXM...  On   | 00000000:03:00.0 Off |                    0 |
| N/A   58C    P0   330W / 400W |  69061MiB / 81920MiB |    100%      Default |
|                               |                      |             Disabled |
+-------------------------------+----------------------+----------------------+
```

## polyglot-ko-12.8b 모델 학습 w/ DeepSpeed (A100 80G x4 or x8)

```bash
chmod +x train.sh
./train.sh
```

- 참고: Edit `--nproc_per_node=4`에서 4를 사용하고 있는 GPU의 개수로 변경해주세요.

위 코드로 학습시 각 GPU당 74GB의 Vram을 사용합니다.

```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 515.65.01    Driver Version: 515.65.01    CUDA Version: 11.7     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA A100-SXM...  On   | 00000000:06:00.0 Off |                    0 |
| N/A   75C    P0   409W / 400W |  74053MiB / 81920MiB |     92%      Default |
|                               |                      |             Disabled |
+-------------------------------+----------------------+----------------------+
|   1  NVIDIA A100-SXM...  On   | 00000000:07:00.0 Off |                    0 |
| N/A   63C    P0   410W / 400W |  74315MiB / 81920MiB |     97%      Default |
|                               |                      |             Disabled |
+-------------------------------+----------------------+----------------------+
|   2  NVIDIA A100-SXM...  On   | 00000000:08:00.0 Off |                    0 |
| N/A   67C    P0   382W / 400W |  74269MiB / 81920MiB |     98%      Default |
|                               |                      |             Disabled |
+-------------------------------+----------------------+----------------------+
|   3  NVIDIA A100-SXM...  On   | 00000000:09:00.0 Off |                    0 |
| N/A   73C    P0   400W / 400W |  74301MiB / 81920MiB |     99%      Default |
|                               |                      |             Disabled |
+-------------------------------+----------------------+----------------------+
|   4  NVIDIA A100-SXM...  On   | 00000000:0A:00.0 Off |                    0 |
| N/A   71C    P0   341W / 400W |  74351MiB / 81920MiB |     96%      Default |
|                               |                      |             Disabled |
+-------------------------------+----------------------+----------------------+
|   5  NVIDIA A100-SXM...  On   | 00000000:0B:00.0 Off |                    0 |
| N/A   65C    P0   350W / 400W |  74457MiB / 81920MiB |    100%      Default |
|                               |                      |             Disabled |
+-------------------------------+----------------------+----------------------+
|   6  NVIDIA A100-SXM...  On   | 00000000:0C:00.0 Off |                    0 |
| N/A   68C    P0   391W / 400W |  74485MiB / 81920MiB |     99%      Default |
|                               |                      |             Disabled |
+-------------------------------+----------------------+----------------------+
|   7  NVIDIA A100-SXM...  On   | 00000000:0D:00.0 Off |                    0 |
| N/A   78C    P0   413W / 400W |  74203MiB / 81920MiB |     98%      Default |
|                               |                      |             Disabled |
+-------------------------------+----------------------+----------------------+
```

## Known Issue

```
  File "/home/user/miniconda3/envs/jupyter/lib/python3.10/site-packages/torch/cuda/amp/grad_scaler.py", line 279, in unscale_
    optimizer_state["found_inf_per_device"] = self._unscale_grads_(optimizer, inv_scale, found_inf, False)
  File "/home/user/miniconda3/envs/jupyter/lib/python3.10/site-packages/torch/cuda/amp/grad_scaler.py", line 207, in _unscale_grads_
    raise ValueError("Attempting to unscale FP16 gradients.")
ValueError: Attempting to unscale FP16 gradients.
```

위와 같은 에러 발생시 --> `/home/user/miniconda3/envs/jupyter/lib/python3.10/site-packages/torch/cuda/amp/grad_scaler.py`(사용자별 경로는 다를 수 있음) 파일에서 

```python
# ...
optimizer_state["found_inf_per_device"] = self._unscale_grads_(optimizer, inv_scale, found_inf, False)
# ...
```

부분을

```python
# ...
optimizer_state["found_inf_per_device"] = self._unscale_grads_(optimizer, inv_scale, found_inf, True)
# ...
```

로, `False`를 `True`로 바꿔주시면 됩니다.
