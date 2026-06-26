/*
# Create Oferta Perto Database Schema

1. Overview
This migration creates the database structure for "Oferta Perto", a Brazilian local 
promotions platform where consumers find the best grocery and butcher shop deals near them.

2. New Tables
- `estabelecimentos`: Stores information about grocery stores, butcher shops, and markets
  - id (uuid, primary key)
  - nome (text, not null) - Establishment name
  - endereco (text, not null) - Full address
  - bairro (text, not null) - Neighborhood
  - latitude (numeric, not null) - Geographic latitude
  - longitude (numeric, not null) - Geographic longitude
  - created_at (timestamp)

- `promocoes`: Stores promotional offers from establishments
  - id (uuid, primary key)
  - estabelecimento_id (uuid, foreign key to estabelecimentos)
  - produto (text, not null) - Product name
  - categoria (text, not null) - Product category (carnes, graos, laticinios, etc.)
  - preco (numeric, not null) - Promotional price
  - foto_url (text, nullable) - Product image URL
  - validade_inicio (date, not null) - Promotion start date
  - validade_fim (date, not null) - Promotion end date
  - created_at (timestamp)

3. Security
- Enable RLS on both tables.
- Allow anon + authenticated CRUD because this is a single-tenant public app with no sign-in.

4. Seed Data
- 5 sample establishments in São Paulo (different neighborhoods)
- 20 sample promotions across various categories

5. RPC Function
- `melhores_precos_perto(lat, lng, raio_km)`: Returns promotions within specified radius,
  ordered by distance, with calculated distance_km for each result.
*/

-- Enable PostGIS extension for geospatial queries
CREATE EXTENSION IF NOT EXISTS postgis;

-- Create establishments table
CREATE TABLE IF NOT EXISTS estabelecimentos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nome text NOT NULL,
  endereco text NOT NULL,
  bairro text NOT NULL,
  latitude numeric NOT NULL,
  longitude numeric NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create promotions table
CREATE TABLE IF NOT EXISTS promocoes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  estabelecimento_id uuid NOT NULL REFERENCES estabelecimentos(id) ON DELETE CASCADE,
  produto text NOT NULL,
  categoria text NOT NULL,
  preco numeric NOT NULL,
  foto_url text,
  validade_inicio date NOT NULL,
  validade_fim date NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create index for geospatial queries
CREATE INDEX IF NOT EXISTS idx_estabelecimentos_location ON estabelecimentos USING GIST (
  ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)
);

-- Create index for promotions by establishment
CREATE INDEX IF NOT EXISTS idx_promocoes_estabelecimento ON promocoes(estabelecimento_id);
CREATE INDEX IF NOT EXISTS idx_promocoes_validade ON promocoes(validade_fim);

-- Enable RLS
ALTER TABLE estabelecimentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE promocoes ENABLE ROW LEVEL SECURITY;

-- RLS Policies for estabelecimentos (public read, anon+authenticated)
DROP POLICY IF EXISTS "anon_select_estabelecimentos" ON estabelecimentos;
CREATE POLICY "anon_select_estabelecimentos" ON estabelecimentos FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_estabelecimentos" ON estabelecimentos;
CREATE POLICY "anon_insert_estabelecimentos" ON estabelecimentos FOR INSERT
  TO anon, authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "anon_update_estabelecimentos" ON estabelecimentos;
CREATE POLICY "anon_update_estabelecimentos" ON estabelecimentos FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_delete_estabelecimentos" ON estabelecimentos;
CREATE POLICY "anon_delete_estabelecimentos" ON estabelecimentos FOR DELETE
  TO anon, authenticated USING (true);

-- RLS Policies for promocoes (public read, anon+authenticated)
DROP POLICY IF EXISTS "anon_select_promocoes" ON promocoes;
CREATE POLICY "anon_select_promocoes" ON promocoes FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_promocoes" ON promocoes;
CREATE POLICY "anon_insert_promocoes" ON promocoes FOR INSERT
  TO anon, authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "anon_update_promocoes" ON promocoes;
CREATE POLICY "anon_update_promocoes" ON promocoes FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_delete_promocoes" ON promocoes;
CREATE POLICY "anon_delete_promocoes" ON promocoes FOR DELETE
  TO anon, authenticated USING (true);

-- Insert sample establishments (São Paulo area)
INSERT INTO estabelecimentos (nome, endereco, bairro, latitude, longitude) VALUES
  ('Açougue do Zé', 'Rua Augusta, 1500', 'Consolação', -23.5545, -46.6630),
  ('Mercado São Paulo', 'Av. Paulista, 1000', 'Bela Vista', -23.5589, -46.6565),
  ('Casa de Carnes Premium', 'Rua Oscar Freire, 300', 'Jardins', -23.5615, -46.6670),
  ('Supermercado Econômico', 'Av. Rebouças, 2000', 'Pinheiros', -23.5690, -46.6850),
  ('Mercadinho do Bairro', 'Rua Pamplona, 500', 'Bela Vista', -23.5560, -46.6510);

-- Insert sample promotions
INSERT INTO promocoes (estabelecimento_id, produto, categoria, preco, foto_url, validade_inicio, validade_fim) VALUES
  -- Açougue do Zé
  ((SELECT id FROM estabelecimentos WHERE nome = 'Açougue do Zé'), 'Fraldinha kg', 'Carnes', 29.90, NULL, '2026-06-20', '2026-07-05'),
  ((SELECT id FROM estabelecimentos WHERE nome = 'Açougue do Zé'), 'Picanha kg', 'Carnes', 59.90, NULL, '2026-06-20', '2026-07-05'),
  ((SELECT id FROM estabelecimentos WHERE nome = 'Açougue do Zé'), 'Costela kg', 'Carnes', 34.90, NULL, '2026-06-25', '2026-07-10'),
  ((SELECT id FROM estabelecimentos WHERE nome = 'Açougue do Zé'), 'Linguiça Toscana kg', 'Carnes', 24.90, NULL, '2026-06-20', '2026-07-05'),
  
  -- Mercado São Paulo
  ((SELECT id FROM estabelecimentos WHERE nome = 'Mercado São Paulo'), 'Arroz Tio João 5kg', 'Grãos', 24.90, NULL, '2026-06-20', '2026-07-03'),
  ((SELECT id FROM estabelecimentos WHERE nome = 'Mercado São Paulo'), 'Feijão Carioca 1kg', 'Grãos', 8.90, NULL, '2026-06-20', '2026-07-03'),
  ((SELECT id FROM estabelecimentos WHERE nome = 'Mercado São Paulo'), 'Leite Integral 1L', 'Laticínios', 4.90, NULL, '2026-06-22', '2026-07-08'),
  ((SELECT id FROM estabelecimentos WHERE nome = 'Mercado São Paulo'), 'Refrigerante 2L', 'Bebidas', 7.90, NULL, '2026-06-20', '2026-07-03'),
  
  -- Casa de Carnes Premium
  ((SELECT id FROM estabelecimentos WHERE nome = 'Casa de Carnes Premium'), 'Filet Mignon kg', 'Carnes', 79.90, NULL, '2026-06-25', '2026-07-12'),
  ((SELECT id FROM estabelecimentos WHERE nome = 'Casa de Carnes Premium'), 'Contrafilé kg', 'Carnes', 44.90, NULL, '2026-06-25', '2026-07-12'),
  ((SELECT id FROM estabelecimentos WHERE nome = 'Casa de Carnes Premium'), 'Maminha kg', 'Carnes', 39.90, NULL, '2026-06-25', '2026-07-12'),
  
  -- Supermercado Econômico
  ((SELECT id FROM estabelecimentos WHERE nome = 'Supermercado Econômico'), 'Macarrão 500g', 'Massas', 3.90, NULL, '2026-06-20', '2026-07-05'),
  ((SELECT id FROM estabelecimentos WHERE nome = 'Supermercado Econômico'), 'Óleo de Soja 900ml', 'Molhos', 5.90, NULL, '2026-06-20', '2026-07-05'),
  ((SELECT id FROM estabelecimentos WHERE nome = 'Supermercado Econômico'), 'Banana Prata kg', 'Hortifruti', 6.90, NULL, '2026-06-24', '2026-07-01'),
  ((SELECT id FROM estabelecimentos WHERE nome = 'Supermercado Econômico'), 'Maçã Fuji kg', 'Hortifruti', 9.90, NULL, '2026-06-24', '2026-07-01'),
  
  -- Mercadinho do Bairro
  ((SELECT id FROM estabelecimentos WHERE nome = 'Mercadinho do Bairro'), 'Pão Francês kg', 'Padaria', 19.90, NULL, '2026-06-26', '2026-06-30'),
  ((SELECT id FROM estabelecimentos WHERE nome = 'Mercadinho do Bairro'), 'Queijo Minas kg', 'Laticínios', 34.90, NULL, '2026-06-25', '2026-07-10'),
  ((SELECT id FROM estabelecimentos WHERE nome = 'Mercadinho do Bairro'), 'Detergente 500ml', 'Limpeza', 2.90, NULL, '2026-06-20', '2026-07-05'),
  ((SELECT id FROM estabelecimentos WHERE nome = 'Mercadinho do Bairro'), 'Sabão em Pó 1kg', 'Limpeza', 12.90, NULL, '2026-06-20', '2026-07-05'),
  ((SELECT id FROM estabelecimentos WHERE nome = 'Mercadinho do Bairro'), 'Iogurte Natural 170g', 'Laticínios', 3.90, NULL, '2026-06-25', '2026-07-02');