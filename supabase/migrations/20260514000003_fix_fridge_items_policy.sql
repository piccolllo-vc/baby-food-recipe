-- fridge_items는 user_id 컬럼이 없고 fridges를 통해 연결됨
-- 기존 정책 삭제
DROP POLICY IF EXISTS "Users can manage own fridge items" ON fridge_items;

-- RLS 정책 생성 (subquery로 fridges.user_id 확인)
CREATE POLICY "Users can manage own fridge items" ON fridge_items
  FOR ALL
  USING (fridge_id IN (SELECT id FROM fridges WHERE user_id = auth.uid()));
