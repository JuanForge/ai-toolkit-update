## Docker :
### Build :
  - ```docker build --no-cache -t ai-toolkit:0 .```

### Run :
  - ```touch ./aitk_db.db```
  - ```docker run --rm --name ai-toolkit --ipc=host --gpus '"device=0"' -e PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:2048 -e NODE_ENV=production -v ./datasets:/app/datasets -v ./output:/app/output -v ./config:/app/config -v ./cache/huggingface:/home/app/.cache/huggingface  -it --network host ai-toolkit:0```
  - ```docker run --rm --name ai-toolkit --ipc=host --gpus '"device=0"' -e PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:2048 -e NODE_ENV=production -v ./datasets:/app/datasets -v ./output:/app/output -v ./config:/app/config -v ./cache/huggingface:/home/app/.cache/huggingface  -it --network host ai-toolkit:my4``
