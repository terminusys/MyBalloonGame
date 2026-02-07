-- ==========================================
-- Supabase 数据库设置脚本
-- 用于多人实时飞行游戏
-- ==========================================

-- 1. 创建 balloon_positions 表（存储玩家气球位置）
CREATE TABLE IF NOT EXISTS public.balloon_positions (
    player_id TEXT PRIMARY KEY,          -- 玩家唯一ID
    player_name TEXT NOT NULL,           -- 玩家名字（如：飞行员 001）
    x INTEGER NOT NULL,                  -- 气球 X 坐标
    y INTEGER NOT NULL,                  -- 气球 Y 坐标
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()  -- 最后更新时间
);

-- 2. 启用实时功能（Realtime）
ALTER PUBLICATION supabase_realtime ADD TABLE public.balloon_positions;

-- 3. 设置行级安全策略（RLS）- 允许所有操作
ALTER TABLE public.balloon_positions ENABLE ROW LEVEL SECURITY;

-- 允许所有用户读取
CREATE POLICY "允许所有人查看气球位置"
ON public.balloon_positions
FOR SELECT
USING (true);

-- 允许所有用户插入
CREATE POLICY "允许所有人插入气球位置"
ON public.balloon_positions
FOR INSERT
WITH CHECK (true);

-- 允许所有用户更新
CREATE POLICY "允许所有人更新气球位置"
ON public.balloon_positions
FOR UPDATE
USING (true)
WITH CHECK (true);

-- 允许所有用户删除
CREATE POLICY "允许所有人删除气球位置"
ON public.balloon_positions
FOR DELETE
USING (true);

-- 4. 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_balloon_positions_updated_at 
ON public.balloon_positions (updated_at DESC);

-- 5. 创建自动清理函数（可选：自动删除10分钟未更新的记录）
CREATE OR REPLACE FUNCTION cleanup_inactive_balloons()
RETURNS void AS $$
BEGIN
    DELETE FROM public.balloon_positions
    WHERE updated_at < NOW() - INTERVAL '10 minutes';
END;
$$ LANGUAGE plpgsql;

-- 6. 创建定时任务（每5分钟清理一次）
-- 注意：需要在 Supabase Dashboard 的 Database > Cron Jobs 中手动启用
-- 或者使用 pg_cron 扩展（如果可用）

-- 完成！现在你的数据库已经准备好了 🎈
