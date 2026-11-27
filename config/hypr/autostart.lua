-- Extra autostart processes.
-- Pre-warm local AI blocker model into memory on login (zero cold-start latency)
o.exec_on_start("curl -s http://127.0.0.1:11434/api/chat -d '{\"model\": \"qwen2.5:1.5b\", \"keep_alive\": -1}' > /dev/null 2>&1 &")

-- Auto-mount internal NTFS partitions on login (Storage & Windows)
o.exec_on_start("udisksctl mount -b /dev/disk/by-uuid/96DC57B5DC578E7D --no-user-interaction >/dev/null 2>&1 &")
o.exec_on_start("udisksctl mount -b /dev/disk/by-uuid/DCCC6B8CCC6B602E --no-user-interaction >/dev/null 2>&1 &")


-- MindGate: morning journal gate + site watcher. `--start` launches both under decoy process
-- names; each restarts the other if it dies. See ~/Work/mindgate/src/mindgate/guard.py.
o.exec_on_start("$HOME/.local/bin/mindgate --start >/dev/null 2>&1 &")
