# Works on 3x RTX 3090/4090/A5000 (24G)
python run_clm.py \
--model_name_or_path='EleutherAI/polyglot-ko-5.8b' \
--train_file='./KoAlpaca_v1.1a_textonly.json' \
--num_train_epochs=1 \
--block_size=1024 \
--per_device_train_batch_size=1 \
--gradient_accumulation_steps=8 \
--fp16 \
--output_dir='polyglot-5.8b-koalpaca-v1.1a-rtx3090' \
--do_train \
--optim='adafactor' \
--learning_rate='2e-5' \
--logging_strategy='steps' \
--logging_first_step \
--run_name='polyglot-5.8b-koalpaca-v1.1a-rtx3090' \
--low_cpu_mem_usage
