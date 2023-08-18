# Works on A100 80G x4
# torchrun --nproc_per_node=4 --master_port=34321 
accelerate launch run_clm.py \
--model_name_or_path='beomi/llama-2-ko-7b' \
--train_file='KoAlpaca_v1.1a_textonly.json' \
--num_train_epochs=2 \
--block_size=512 \
--per_device_train_batch_size=1 \
--gradient_accumulation_steps=1 \
--torch_dtype=bfloat16 \
--bf16 \
--output_dir='ds_zero3-nooffload' \
--deepspeed='ds_zero3-nooffload.json' \
--do_train \
--save_strategy='no' \
--logging_strategy='steps' \
--logging_steps=10 \
--logging_first_step \
--save_total_limit=1 \
--run_name='ds_zero3-nooffload'
