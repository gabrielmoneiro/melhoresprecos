/*
# Fix RPC Function: melhores_precos_perto

Fixes the ROUND function type error by casting the distance to numeric before rounding.
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
      CAST(
        ST_Distance(
          ST_SetSRID(ST_MakePoint(lng, lat), 4326)::geography,
          ST_SetSRID(ST_MakePoint(e.longitude, e.latitude), 4326)::geography
        ) / 1000.0 AS numeric
      ),
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