-- ==========================================
-- 🔧 强制启用 Supabase Realtime
-- ==========================================
-- 此脚本将确保 balloon_positions 表的 Realtime 功能已正确启用
--
-- 执行步骤：
-- 1. 在 Supabase Dashboard 中打开 SQL Editor
-- 2. 粘贴此脚本并执行
-- 3. 刷新游戏页面测试
-- ==========================================

-- 第一步：确保 supabase_realtime publication 存在
-- ==========================================
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication WHERE pubname = 'supabase_realtime'
    ) THEN
        CREATE PUBLICATION supabase_realtime;
        RAISE NOTICE '✅ 已创建 supabase_realtime publication';
    ELSE
        RAISE NOTICE 'ℹ️ supabase_realtime publication 已存在';
    END IF;
END $$;

-- 第二步：移除并重新添加 balloon_positions 表到 Realtime
-- ==========================================
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

-- 第三步：验证 Realtime 是否已启用
-- ==========================================
SELECT 
    'balloon_positions' as table_name,
    CASE 
        WHEN 'balloon_positions' = ANY(
            SELECT tablename 
            FROM pg_publication_tables 
            WHERE pubname = 'supabase_realtime'
        ) THEN '✅ Realtime 已启用'
        ELSE '❌ Realtime 未启用'
    END as status;

-- 第四步：检查 RLS 策略
-- ==========================================
SELECT 
    tablename,
    policyname,
    cmd as operation,
    CASE 
        WHEN qual = 'true' OR qual IS NULL THEN '✅ 允许所有'
        ELSE '⚠️ 有限制: ' || qual
    END as access_rule
FROM pg_policies
WHERE tablename = 'balloon_positions'
ORDER BY cmd;

-- ==========================================
-- ✅ 完成！
-- ==========================================
-- 如果上面显示 "✅ Realtime 已启用"，说明配置成功
-- 如果仍然无法联机，请检查：
-- 1. 浏览器控制台是否还有 WebSocket 错误
-- 2. Supabase API Key 是否正确
-- 3. 网络是否可以访问 Supabase 服务器
-- ==========================================
