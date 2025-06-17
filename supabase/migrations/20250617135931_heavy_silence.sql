/*
  # Enable RLS and add policies for orders table

  1. Security Changes
    - Enable RLS on `orders` table
    - Add policy for public read access to orders (since this appears to be a public-facing e-commerce site)
    - Add policy for authenticated users to manage orders

  2. Notes
    - Orders table currently has RLS disabled which may be causing fetch failures
    - Adding basic policies to allow proper data access
*/

-- Enable RLS on orders table
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Allow public read access to orders (for order status checking, etc.)
CREATE POLICY "Anyone can view orders"
  ON orders
  FOR SELECT
  TO public
  USING (true);

-- Allow authenticated users to insert orders
CREATE POLICY "Authenticated users can create orders"
  ON orders
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Allow authenticated users to update orders
CREATE POLICY "Authenticated users can update orders"
  ON orders
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Allow authenticated users to delete orders
CREATE POLICY "Authenticated users can delete orders"
  ON orders
  FOR DELETE
  TO authenticated
  USING (true);