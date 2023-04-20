# Train KoAlpaca Polyglot-12.8b v1.1b using DeepSpeed

## 설치

```bash
pip install -r requirements.txt
```

## 데이터 설정

```bash
cp ../KoAlpaca_v1.1.jsonl ./KoAlpaca_v1.1.json
```

- 참고: 업로드된 KoAlpaca 12.8B v1.1b는 위 데이터에서 추가 맥락으로서 URL의 '채택 답변' 본문을 `input` 으로 추가하여 학습한 모델입니다.

## 모델 학습 w/ DeepSpeed

```bash
chmod +x train.sh
./train.sh
```

- 참고: Edit `--nproc_per_node=4`에서 4를 사용하고 있는 GPU의 개수로 변경해주세요.
