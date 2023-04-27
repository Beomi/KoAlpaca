# Works on A100 80G x4
torchrun --nproc_per_node=4 --master_port=34321 run_clm.py \
--model_name_or_path='EleutherAI/polyglot-ko-12.8b' \
--train_file='./KoAlpaca_v1.1.json' \
--num_train_epochs=2 \
--block_size=1024 \
--per_device_train_batch_size=1 \
--gradient_accumulation_steps=64 \
--torch_dtype=float16 \
--fp16 \
--output_dir='polyglot-12.8b-koalpaca-v1.1b' \
--deepspeed=ds_zero3-nooffload.json \
--do_train \
--save_strategy='epoch' \
--logging_strategy='steps' \
--logging_first_step \
--save_total_limit=1 \
--run_name='polyglot-12.8b-koalpaca-v1.1b-ga64'
