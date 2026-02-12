-- ==================== 用户注册系统数据库表 ====================
-- 用于存储用户注册信息和登录验证

-- 创建用户表
CREATE TABLE IF NOT EXISTS public.game_users (
  id SERIAL PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,  -- 用户名（唯一）
  password TEXT NOT NULL,          -- 密码（应该加密，这里简化处理）
  country TEXT,                     -- 国家
  region TEXT,                      -- 地区
  gender TEXT,                      -- 性别
  age INTEGER,                      -- 年龄
  phone TEXT,                       -- 手机号
  
  -- 游戏数据
  diamonds INTEGER DEFAULT 0,       -- 钻石数量
  coins_collected INTEGER DEFAULT 0, -- 收集的金币总数
  
  -- 系统字段
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),  -- 注册时间
  last_login TIMESTAMP WITH TIME ZONE,                -- 最后登录时间
  is_active BOOLEAN DEFAULT true                      -- 账号是否激活
);

-- 创建索引以优化查询
CREATE INDEX IF NOT EXISTS idx_users_username ON public.game_users (username);
CREATE INDEX IF NOT EXISTS idx_users_phone ON public.game_users (phone);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON public.game_users (created_at);

-- 启用 Row Level Security (RLS)
ALTER TABLE public.game_users ENABLE ROW LEVEL SECURITY;

-- 策略1: 所有人都可以读取用户信息（用于登录验证）
-- 注意：在生产环境中应该限制只能读取自己的信息
CREATE POLICY "允许读取用户信息"
ON public.game_users
FOR SELECT
TO public
USING (true);

-- 策略2: 所有人都可以插入（用于注册）
CREATE POLICY "允许注册新用户"
ON public.game_users
FOR INSERT
TO public
WITH CHECK (true);

-- 策略3: 允许更新（用于更新登录时间、游戏数据等）
CREATE POLICY "允许更新用户信息"
ON public.game_users
FOR UPDATE
TO public
USING (true)
WITH CHECK (true);

-- 插入超级管理员账户
INSERT INTO public.game_users (username, password, country, region, gender, age, phone, diamonds, coins_collected)
VALUES ('DDKJ', 'DDKJ88888888', '中国', '北京', '保密', 30, '', 999999, 0)
ON CONFLICT (username) DO NOTHING;

-- 查看用户表结构
SELECT 
  column_name, 
  data_type, 
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_name = 'game_users'
ORDER BY ordinal_position;

-- ==================== 说明 ====================
-- 1. 用户名是唯一的，不能重复注册
-- 2. 密码在实际应用中应该使用加密存储（bcrypt, scrypt等）
-- 3. 这里为了简化演示，使用明文存储（不推荐用于生产环境）
-- 4. 可以根据需要添加邮箱验证、手机验证等功能
-- 5. 游戏数据（钻石、金币）也存储在用户表中

-- ==================== 安全建议 ====================
-- 生产环境中应该：
-- 1. 密码使用加密函数（例如 pgcrypto 扩展的 crypt 函数）
-- 2. 限制 RLS 策略，只允许用户读取/更新自己的信息
-- 3. 添加登录失败次数限制，防止暴力破解
-- 4. 使用 JWT token 进行身份验证，而不是每次都传输密码
-- 5. 添加邮箱验证、手机验证等二次验证机制
