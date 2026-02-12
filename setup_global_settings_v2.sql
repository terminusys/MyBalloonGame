-- ==================== 全局游戏配置表 v2.0 ====================
-- 使用JSONB字段存储所有配置，与代码完全匹配

-- 删除旧表（如果存在）
DROP TABLE IF EXISTS public.global_game_settings CASCADE;

-- 创建新的全局设置表
CREATE TABLE IF NOT EXISTS public.global_game_settings (
  id TEXT PRIMARY KEY DEFAULT 'default',
  settings JSONB NOT NULL DEFAULT '{}'::jsonb,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 插入默认配置
INSERT INTO public.global_game_settings (id, settings) 
VALUES ('default', '{
  "coinSpawnRate": 0.02,
  "coinMaxCount": 15,
  "coinLifeTime": 12000,
  "diamondSpawnInterval": 100000,
  "diamondSpawnCount": 5,
  "diamondMaxCount": 5,
  "obstacleSpawnRate": 0.005,
  "obstacleMaxCount": 6,
  "healthPackInterval": 100000,
  "healthPackSpawnCount": 2,
  "healthPackLifeTime": 8000,
  "adBalloons": [],
  "paymentSettings": {
    "alipayQRCode": null,
    "wechatQRCode": null,
    "visaAccountName": "",
    "visaCardNumber": "",
    "mastercardAccountName": "",
    "mastercardCardNumber": ""
  }
}'::jsonb)
ON CONFLICT (id) DO NOTHING;

-- 启用 Row Level Security (RLS)
ALTER TABLE public.global_game_settings ENABLE ROW LEVEL SECURITY;

-- 删除旧策略（如果存在）
DROP POLICY IF EXISTS "所有人可以读取全局设置" ON public.global_game_settings;
DROP POLICY IF EXISTS "允许更新全局设置" ON public.global_game_settings;

-- 策略1: 所有人都可以读取（SELECT）
CREATE POLICY "所有人可以读取全局设置"
ON public.global_game_settings
FOR SELECT
TO public
USING (true);

-- 策略2: 所有人都可以更新（UPDATE）
CREATE POLICY "允许更新全局设置"
ON public.global_game_settings
FOR UPDATE
TO public
USING (true)
WITH CHECK (true);

-- 策略3: 允许插入（INSERT）- 用于初始化
CREATE POLICY "允许插入全局设置"
ON public.global_game_settings
FOR INSERT
TO public
WITH CHECK (true);

-- 查看当前配置
SELECT id, settings, updated_at FROM public.global_game_settings WHERE id = 'default';

-- ==================== 说明 ====================
-- 1. 使用JSONB字段存储所有配置，灵活且易于扩展
-- 2. 所有玩家从这个表读取配置
-- 3. 修改后立即对所有玩家生效
-- 4. id固定为'default'，整个表只有一条记录
-- 5. 与index.html中的代码完全匹配
