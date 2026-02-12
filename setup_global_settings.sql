-- ==================== 全局游戏配置表 ====================
-- 用于存储所有玩家共享的游戏配置

-- 创建全局设置表
CREATE TABLE IF NOT EXISTS public.global_game_settings (
  id TEXT PRIMARY KEY DEFAULT 'default',  -- 固定使用'default'作为唯一记录
  
  -- 金币参数
  coin_spawn_rate DECIMAL DEFAULT 0.02,
  coin_max_count INTEGER DEFAULT 15,
  coin_lifetime INTEGER DEFAULT 12000,
  
  -- 钻石参数
  diamond_spawn_interval INTEGER DEFAULT 100000,
  diamond_spawn_count INTEGER DEFAULT 5,
  diamond_max_count INTEGER DEFAULT 5,
  
  -- 障碍物参数
  obstacle_spawn_rate DECIMAL DEFAULT 0.005,
  obstacle_max_count INTEGER DEFAULT 6,
  
  -- 加血包参数
  health_pack_interval INTEGER DEFAULT 100000,
  health_pack_count INTEGER DEFAULT 2,
  health_pack_lifetime INTEGER DEFAULT 8000,
  
  -- 广告气球设置（JSON格式）
  ad_balloons JSONB DEFAULT '[]'::jsonb,
  
  -- 支付设置（JSON格式）
  payment_settings JSONB DEFAULT '{
    "alipayQRCode": "",
    "wechatQRCode": "",
    "visaAccount": "",
    "visaCardLast4": "",
    "mastercardAccount": "",
    "mastercardCardLast4": ""
  }'::jsonb,
  
  -- 更新时间
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_by TEXT DEFAULT 'admin'
);

-- 插入默认配置（如果不存在）
INSERT INTO public.global_game_settings (id)
VALUES ('default')
ON CONFLICT (id) DO NOTHING;

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_global_settings_updated_at 
ON public.global_game_settings (updated_at);

-- 启用 Row Level Security (RLS)
ALTER TABLE public.global_game_settings ENABLE ROW LEVEL SECURITY;

-- 策略1: 所有人都可以读取（SELECT）
CREATE POLICY "所有人可以读取全局设置"
ON public.global_game_settings
FOR SELECT
TO public
USING (true);

-- 策略2: 所有人都可以更新（UPDATE）- 在客户端代码中验证管理员权限
-- 注意：真正的权限验证应该在客户端进行，这里为了简化允许所有人更新
CREATE POLICY "允许更新全局设置"
ON public.global_game_settings
FOR UPDATE
TO public
USING (true)
WITH CHECK (true);

-- 如果需要更严格的权限控制，可以使用以下策略替代上面的UPDATE策略：
-- CREATE POLICY "只允许管理员更新"
-- ON public.global_game_settings
-- FOR UPDATE
-- TO authenticated
-- USING (auth.uid() = '管理员的UUID')
-- WITH CHECK (auth.uid() = '管理员的UUID');

-- 查看当前配置
SELECT * FROM public.global_game_settings WHERE id = 'default';

-- ==================== 说明 ====================
-- 1. 所有玩家从这个表读取配置
-- 2. 只有管理员可以修改配置（在客户端验证）
-- 3. 修改后立即对所有玩家生效
-- 4. id固定为'default'，整个表只有一条记录
