-- TS-17: user_likes 테이블 생성 (2026-05-17)
-- 레시피 좋아요/북마크 기능용

CREATE TABLE IF NOT EXISTS user_likes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  recipe_id INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, recipe_id)
);

-- RLS 정책: 본인만 접근 가능
ALTER TABLE user_likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own likes"
  ON user_likes FOR ALL
  USING (auth.uid() = user_id);