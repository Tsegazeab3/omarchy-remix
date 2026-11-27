-- Extra autostart processes.

-- Pre-warm the local Ollama model into memory on login (zero cold-start latency
-- for ai-scratchpad and git-ai-commit).
o.exec_on_start("curl -s http://127.0.0.1:11434/api/chat -d '{\"model\": \"qwen2.5:1.5b\", \"keep_alive\": -1}' > /dev/null 2>&1 &")

-- Auto-mount internal NTFS partitions (dual-boot "Storage" and "Windows") on login.
-- Replace the UUIDs with yours: lsblk -o NAME,FSTYPE,LABEL,UUID
o.exec_on_start("udisksctl mount -b /dev/disk/by-uuid/96DC57B5DC578E7D --no-user-interaction >/dev/null 2>&1 &")
o.exec_on_start("udisksctl mount -b /dev/disk/by-uuid/DCCC6B8CCC6B602E --no-user-interaction >/dev/null 2>&1 &")

-- MindGate (morning journal gate; separate project, not in this repo).
-- Uncomment if you have it installed. hypr/mindgate.lua holds its keyboard lock.
-- o.exec_on_start("mindgate --start >/dev/null 2>&1 &")
