-- ==========================================
-- Supabase Realtime 配置验证脚本
-- 运行此脚本检查联机功能配置是否正确
-- ==========================================

-- 🔍 步骤1: 检查表是否存在
SELECT 
    '✅ balloon_positions 表存在' AS status,
    COUNT(*) AS record_count
FROM public.balloon_positions;

-- 🔍 步骤2: 检查 Realtime Publication 配置
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN '✅ balloon_positions 已添加到 Realtime Publication'
        ELSE '❌ balloon_positions 未添加到 Realtime Publication - 需要修复！'
    END AS realtime_status,
    schemaname,
    tablename
FROM pg_publication_tables 
WHERE pubname = 'supabase_realtime' AND tablename = 'balloon_positions'
GROUP BY schemaname, tablename;

-- 🔍 步骤3: 检查 RLS (行级安全) 是否启用
SELECT 
    CASE 
        WHEN relrowsecurity THEN '✅ RLS 已启用'
        ELSE '❌ RLS 未启用'
    END AS rls_status
FROM pg_class 
WHERE relname = 'balloon_positions';

-- 🔍 步骤4: 检查 RLS 策略
SELECT 
    CASE 
        WHEN COUNT(*) >= 4 THEN '✅ RLS 策略配置完整（' || COUNT(*) || ' 条）'
        ELSE '⚠️ RLS 策略不完整（只有 ' || COUNT(*) || ' 条，应该有4条）'
    END AS policy_status
FROM pg_policies 
WHERE tablename = 'balloon_positions';

-- 🔍 步骤5: 列出所有策略详情
SELECT 
    policyname AS 策略名称,
    cmd AS 命令类型,
    qual AS 条件,
    with_check AS 检查条件
FROM pg_policies 
WHERE tablename = 'balloon_positions';

-- 🔍 步骤6: 检查索引
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN '✅ 索引已创建'
        ELSE '⚠️ 索引未创建（性能可能受影响）'
    END AS index_status
FROM pg_indexes 
WHERE tablename = 'balloon_positions' 
AND indexname = 'idx_balloon_positions_updated_at';

-- ==========================================
-- 🔧 修复脚本（如果上面检查发现问题）
-- ==========================================

-- 如果 Publication 检查失败，取消下面的注释并运行：
/*
ALTER PUBLICATION supabase_realtime DROP TABLE IF EXISTS public.balloon_positions;
ALTER PUBLICATION supabase_realtime ADD TABLE public.balloon_positions;
*/

-- 如果 RLS 策略不完整，取消下面的注释并运行：
/*
DROP POLICY IF EXISTS "允许所有人查看气球位置" ON public.balloon_positions;
DROP POLICY IF EXISTS "允许所有人插入气球位置" ON public.balloon_positions;
DROP POLICY IF EXISTS "允许所有人更新气球位置" ON public.balloon_positions;
DROP POLICY IF EXISTS "允许所有人删除气球位置" ON public.balloon_positions;

CREATE POLICY "允许所有人查看气球位置"
ON public.balloon_positions FOR SELECT USING (true);

CREATE POLICY "允许所有人插入气球位置"
ON public.balloon_positions FOR INSERT WITH CHECK (true);

CREATE POLICY "允许所有人更新气球位置"
ON public.balloon_positions FOR UPDATE USING (true) WITH CHECK (true);

CREATE POLICY "允许所有人删除气球位置"
ON public.balloon_positions FOR DELETE USING (true);
*/

-- ==========================================
-- ✅ 验证完成
-- ==========================================
-- 所有检查项都应该显示 ✅
-- 如果有 ❌ 或 ⚠️，请运行上面的修复脚本
