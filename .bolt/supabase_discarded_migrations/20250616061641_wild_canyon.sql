/*
  # Create project_documents table

  1. New Tables
    - `project_documents`
      - `id` (uuid, primary key)
      - `project_id` (uuid, foreign key to projects)
      - `name` (text, document name)
      - `url` (text, document URL)
      - `type` (text, file type)
      - `size` (integer, file size in bytes)
      - `review_stage` (text, review stage identifier)
      - `document_category` (text, document category)
      - `description` (text, optional description)
      - `is_active` (boolean, soft delete flag)
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)

  2. Security
    - Enable RLS on `project_documents` table
    - Add policies for public viewing and authenticated CRUD operations

  3. Performance
    - Add indexes for frequently queried columns
*/

-- Create project_documents table
CREATE TABLE IF NOT EXISTS project_documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid REFERENCES projects(id) NOT NULL,
  name text NOT NULL,
  url text NOT NULL,
  type text NOT NULL,
  size integer NOT NULL DEFAULT 0,
  review_stage text NOT NULL DEFAULT 'review_1',
  document_category text NOT NULL DEFAULT 'presentation',
  description text,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS on project_documents table
ALTER TABLE project_documents ENABLE ROW LEVEL SECURITY;

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_project_documents_project_id ON project_documents(project_id);
CREATE INDEX IF NOT EXISTS idx_project_documents_review_stage ON project_documents(review_stage);
CREATE INDEX IF NOT EXISTS idx_project_documents_category ON project_documents(document_category);
CREATE INDEX IF NOT EXISTS idx_project_documents_active ON project_documents(is_active);

-- Create policies for project_documents
CREATE POLICY "Anyone can view active project documents"
  ON project_documents
  FOR SELECT
  TO public
  USING (is_active = true);

CREATE POLICY "Authenticated users can create project documents"
  ON project_documents
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update project documents"
  ON project_documents
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete project documents"
  ON project_documents
  FOR DELETE
  TO authenticated
  USING (true);