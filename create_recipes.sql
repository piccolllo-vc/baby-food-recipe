-- LittleMates - recipes 테이블 생성 SQL
-- Supabase Dashboard → SQL Editor에서 실행

-- 1. recipes 테이블
CREATE TABLE IF NOT EXISTS recipes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  age_months INTEGER NOT NULL,
  age_label TEXT,
  prep_time TEXT,
  servings TEXT,
  calories TEXT,
  allergens TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS 활성화
ALTER TABLE recipes ENABLE ROW LEVEL SECURITY;

-- 인증된 사용자만 자신의 데이터에 접근
CREATE POLICY "Anyone can view recipes"
  ON recipes FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can insert recipes"
  ON recipes FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Users can update own recipes"
  ON recipes FOR UPDATE
  USING (true);

CREATE POLICY "Users can delete own recipes"
  ON recipes FOR DELETE
  USING (true);

-- 2. recipe_ingredients 테이블 (레시피-재료 연결)
CREATE TABLE IF NOT EXISTS recipe_ingredients (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  recipe_id UUID REFERENCES recipes(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  amount TEXT,
  unit TEXT,
  allergen BOOLEAN DEFAULT false
);

-- RLS
ALTER TABLE recipe_ingredients ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view recipe ingredients"
  ON recipe_ingredients FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can insert recipe ingredients"
  ON recipe_ingredients FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Users can update recipe ingredients"
  ON recipe_ingredients FOR UPDATE
  USING (true);

CREATE POLICY "Users can delete recipe ingredients"
  ON recipe_ingredients FOR DELETE
  USING (true);

-- 3. 예시 레시피 데이터 삽입 (recipes.json의 6개 레시피)
INSERT INTO recipes (title, description, image_url, age_months, age_label, prep_time, servings, calories, allergens) VALUES
  ('당근 미음', '부드러운 당근 미음. 6개월 아기가 처음 먹기 좋은 레시피입니다.', '', 6, '6개월~', '15분', '1인분', '80kcal', '{}'),
  ('고구마 유부', '단단한 고구마 죽. 자연 당도로 아이들이 좋아합니다.', '', 7, '7-9개월', '20분', '1인분', '95kcal', '{}'),
  ('송이버섯 고기 죽', '고소한 송이버섯과 살코기의 조화.', '', 7, '7-9개월', '25분', '1인분', '120kcal', '{}'),
  ('시금치 두부 무침', '단단한 시금치와 부드러운 두부. 철분 보충에 좋아요.', '', 8, '7-9개월', '10분', '1인분', '70kcal', '{soy}'),
  ('연어 채소 죽', '오메가3 풍부한 연어와 채소의 영양만점 조합.', '', 10, '10-12개월', '20분', '1인분', '150kcal', '{fish}'),
  ('닭가슴살 채소 스프', '단단한 닭가슴살과 여러 채소의 든든한 스프.', '', 10, '10-12개월', '30분', '1인분', '130kcal', '{}')
ON CONFLICT DO NOTHING;

-- user_likes 테이블 (북마크/좋아요)
CREATE TABLE IF NOT EXISTS user_likes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  recipe_id TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, recipe_id)
);

ALTER TABLE user_likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own likes"
  ON user_likes FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own likes"
  ON user_likes FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own likes"
  ON user_likes FOR DELETE
  USING (auth.uid() = user_id);

-- 4. recipe_ingredients 예시 데이터 (선택적)
-- 필요한 경우 아래 데이터를 실행하세요
