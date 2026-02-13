-- ==========================================
-- 🔧 balloon_positions 表结构修复脚本
-- ==========================================
-- 此脚本将安全地修复表结构，不会丢失现有数据
--
-- 执行步骤：
-- 1. 在 Supabase Dashboard 中打开 SQL Editor
-- 2. 粘贴此脚本并执行
-- 3. 检查执行结果
-- ==========================================

-- 第一步：添加缺失的字段
-- ==========================================

-- 添加 id 字段（如果不存在）
-- 注意：如果表已有主键（如 player_id），则只添加 id 作为普通 UUID 字段
DO $$ 
BEGIN
    -- 检查是否已有 id 列
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'balloon_positions' AND column_name = 'id'
    ) THEN
        -- 添加 id 列，使用 UUID 并设置默认值
        -- 如果表已有主键，这里不会设为主键，只是一个唯一标识字段
        ALTER TABLE balloon_positions 
        ADD COLUMN id uuid DEFAULT gen_random_uuid() UNIQUE;
        
        RAISE NOTICE '✅ 已添加 id 字段（UUID）';
    ELSE
        RAISE NOTICE 'ℹ️ id 字段已存在，跳过';
    END IF;
END $$;

-- 添加 color 字段（如果不存在）
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'balloon_positions' AND column_name = 'color'
    ) THEN
        ALTER TABLE balloon_positions 
        ADD COLUMN color text DEFAULT '#FF6B6B';
        
        RAISE NOTICE '✅ 已添加 color 字段';
    ELSE
        RAISE NOTICE 'ℹ️ color 字段已存在，跳过';
    END IF;
END $$;

-- 第二步：修改 x, y 字段类型
-- ==========================================
-- 从 int4 改为 real（浮点数），使移动更平滑

DO $$ 
BEGIN
    -- 修改 x 字段类型
    BEGIN
        ALTER TABLE balloon_positions 
        ALTER COLUMN x TYPE real USING x::real;
        RAISE NOTICE '✅ 已将 x 字段类型改为 real';
    EXCEPTION 
        WHEN OTHERS THEN
            RAISE NOTICE '⚠️ x 字段类型转换失败或已是正确类型';
    END;
    
    -- 修改 y 字段类型
    BEGIN
        ALTER TABLE balloon_positions 
        ALTER COLUMN y TYPE real USING y::real;
        RAISE NOTICE '✅ 已将 y 字段类型改为 real';
    EXCEPTION 
        WHEN OTHERS THEN
            RAISE NOTICE '⚠️ y 字段类型转换失败或已是正确类型';
    END;
END $$;

-- 第三步：为现有数据生成随机颜色
-- ==========================================
DO $$ 
DECLARE
    colors text[] := ARRAY['#FF6B6B', '#4ECDC4', '#45B7D1', '#FFA07A', '#98D8C8', '#F7DC6F', '#BB8FCE', '#85C1E2'];
BEGIN
    -- 为没有颜色的记录随机分配颜色
    UPDATE balloon_positions 
    SET color = colors[1 + floor(random() * array_length(colors, 1))::int]
    WHERE color IS NULL OR color = '#FF6B6B';
    
    RAISE NOTICE '✅ 已为现有玩家分配随机颜色';
END $$;

-- 第四步：启用 Realtime
-- ==========================================

-- 确保 Realtime 已启用（使用 DO 块安全处理）
DO $$ 
BEGIN
    -- 尝试移除表（如果存在）
    BEGIN
        ALTER PUBLICATION supabase_realtime DROP TABLE balloon_positions;
        RAISE NOTICE '✅ 已从 publication 中移除 balloon_positions';
    EXCEPTION 
        WHEN OTHERS THEN
            RAISE NOTICE 'ℹ️ balloon_positions 不在 publication 中，继续';
    END;
    
    -- 添加表到 publication
    ALTER PUBLICATION supabase_realtime ADD TABLE balloon_positions;
    RAISE NOTICE '✅ 已将 balloon_positions 添加到 Realtime';
END $$;

-- 第五步：确保 RLS 策略正确
-- ==========================================

-- 启用 RLS
ALTER TABLE balloon_positions ENABLE ROW LEVEL SECURITY;

-- 删除旧策略（如果存在）
DROP POLICY IF EXISTS "Allow all operations" ON balloon_positions;
DROP POLICY IF EXISTS "Enable read access for all users" ON balloon_positions;
DROP POLICY IF EXISTS "Enable insert for all users" ON balloon_positions;
DROP POLICY IF EXISTS "Enable update for all users" ON balloon_positions;
DROP POLICY IF EXISTS "Enable delete for all users" ON balloon_positions;

-- 创建新的全局访问策略
CREATE POLICY "Allow all read access" ON balloon_positions 
    FOR SELECT USING (true);

CREATE POLICY "Allow all insert access" ON balloon_positions 
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow all update access" ON balloon_positions 
    FOR UPDATE USING (true);

CREATE POLICY "Allow all delete access" ON balloon_positions 
    FOR DELETE USING (true);

-- 第六步：创建索引以提高性能
-- ==========================================

-- 为 player_id 创建索引
CREATE INDEX IF NOT EXISTS idx_balloon_positions_player_id 
    ON balloon_positions(player_id);

-- 为 updated_at 创建索引（用于清理旧数据）
CREATE INDEX IF NOT EXISTS idx_balloon_positions_updated_at 
    ON balloon_positions(updated_at);

-- 第七步：验证配置
-- ==========================================

-- 显示最终表结构
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'balloon_positions'
ORDER BY ordinal_position;

-- 显示 Realtime 状态
SELECT 
    schemaname,
    tablename,
    CASE 
        WHEN tablename = ANY(
            SELECT tablename 
            FROM pg_publication_tables 
            WHERE pubname = 'supabase_realtime'
        ) THEN '✅ 已启用'
        ELSE '❌ 未启用'
    END as realtime_status
FROM pg_tables
WHERE tablename = 'balloon_positions';

-- 显示 RLS 策略
SELECT 
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE tablename = 'balloon_positions';

-- ==========================================
-- ✅ 修复完成！
-- ==========================================
-- 执行后请检查上方的验证结果
-- 然后继续部署更新的代码到 Vercel
-- ==========================================
