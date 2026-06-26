/*
# Create RPC Function: melhores_precos_perto

1. Purpose
This function returns the best promotional prices within a specified radius from the 
user's location. It calculates the geographic distance using PostGIS and filters 
promotions by:
- Location (within the specified radius in kilometers)
- Validity (current date is between validade_inicio and validade_fim)

2. Parameters
- lat (numeric): User's latitude coordinate
- lng (numeric): User's longitude coordinate  
- raio_km (numeric): Search radius in kilometers

3. Return Columns
- produto (text): Product name
- categoria (text): Product category
- estabelecimento (text): Establishment name
- bairro (text): Neighborhood
- endereco (text): Full address
- preco (numeric): Promotional price
- foto_url (text): Product image URL (can be null)
- validade_fim (date): Promotion end date
- distancia_km (numeric): Distance from user in kilometers

4. Ordering
Results are ordered by distance (closest first), then by price (lowest first).

5. Notes
- Uses PostGIS ST_DWithin for efficient radius queries
- Uses geography type for accurate distance calculations in kilometers
- Only returns currently valid promotions
*/

CREATE OR REPLACE FUNCTION melhores_precos_perto(
  lat numeric,
  lng numeric,
  raio_km numeric
)
RETURNS TABLE (
  produto text,
  categoria text,
  estabelecimento text,
  bairro text,
  endereco text,
  preco numeric,
  foto_url text,
  validade_fim date,
  distancia_km numeric
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    p.produto,
    p.categoria,
    e.nome AS estabelecimento,
    e.bairro,
    e.endereco,
    p.preco,
    p.foto_url,
    p.validade_fim,
    ROUND(
      ST_Distance(
        ST_SetSRID(ST_MakePoint(lng, lat), 4326)::geography,
        ST_SetSRID(ST_MakePoint(e.longitude, e.latitude), 4326)::geography
      ) / 1000.0,
      2
    ) AS distancia_km
  FROM promocoes p
  JOIN estabelecimentos e ON p.estabelecimento_id = e.id
  WHERE
    p.validade_inicio <= CURRENT_DATE
    AND p.validade_fim >= CURRENT_DATE
    AND ST_DWithin(
      ST_SetSRID(ST_MakePoint(lng, lat), 4326)::geography,
      ST_SetSRID(ST_MakePoint(e.longitude, e.latitude), 4326)::geography,
      raio_km * 1000
    )
  ORDER BY
    distancia_km ASC,
    p.preco ASC;
END;
$$;