# LittleMates Supabase Schema

## Tables Needed

### 1. baby_profiles
Store baby information for each user.

```sql
CREATE TABLE baby_profiles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  name TEXT NOT NULL,
  birth_date DATE NOT NULL,
  allergies TEXT[], -- Array of allergy strings
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS (Row Level Security)
ALTER TABLE baby_profiles ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only see their own baby profiles
CREATE POLICY "Users can view own baby profiles" 
  ON baby_profiles FOR SELECT 
  USING (auth.uid() = user_id);

-- Policy: Users can insert their own baby profiles
CREATE POLICY "Users can insert own baby profiles" 
  ON baby_profiles FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own baby profiles
CREATE POLICY "Users can update own baby profiles" 
  ON baby_profiles FOR UPDATE 
  USING (auth.uid() = user_id);

-- Policy: Users can delete their own baby profiles
CREATE POLICY "Users can delete own baby profiles" 
  ON baby_profiles FOR DELETE 
  USING (auth.uid() = user_id);
```

### 2. fridges (optional for now)
```sql
CREATE TABLE fridges (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  name TEXT NOT NULL DEFAULT 'My Fridge',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 3. fridge_items (optional for now)
```sql
CREATE TABLE fridge_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  fridge_id UUID REFERENCES fridges(id) NOT NULL,
  name TEXT NOT NULL,
  category TEXT,
  quantity INTEGER DEFAULT 1,
  expiry_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## How to Apply

1. Go to Supabase Dashboard: https://supabase.com/dashboard/project/dlphziojfyzkhsftgdkm
2. Navigate to SQL Editor
3. Copy and paste the SQL above
4. Click "Run" to create tables

Or ask your assistant to run it via Supabase CLI if available.
