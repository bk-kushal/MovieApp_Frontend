/*
  # Movie Database Schema

  1. New Tables
    - `movies`
      - `id` (uuid, primary key)
      - `title` (text, not null)
      - `year` (integer, not null)
      - `genre` (text, not null)
      - `rating` (integer)
      - `review` (text)
      - `watched` (boolean, default false)
      - `created_at` (timestamp with time zone, default now())
      - `user_id` (uuid, foreign key to auth.users)

  2. Security
    - Enable RLS on `movies` table
    - Add policies for authenticated users to:
      - Read their own movies
      - Create new movies
      - Update their own movies
      - Delete their own movies
*/

CREATE TABLE movies (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  year integer NOT NULL,
  genre text NOT NULL,
  rating integer CHECK (rating >= 0 AND rating <= 5),
  review text,
  watched boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  user_id uuid REFERENCES auth.users NOT NULL
);

ALTER TABLE movies ENABLE ROW LEVEL SECURITY;

-- Policy for users to read their own movies
CREATE POLICY "Users can read own movies"
  ON movies
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- Policy for users to insert their own movies
CREATE POLICY "Users can create movies"
  ON movies
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Policy for users to update their own movies
CREATE POLICY "Users can update own movies"
  ON movies
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Policy for users to delete their own movies
CREATE POLICY "Users can delete own movies"
  ON movies
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);