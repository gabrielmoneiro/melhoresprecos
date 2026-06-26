import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export interface Promocao {
  produto: string;
  categoria: string;
  estabelecimento: string;
  bairro: string;
  endereco: string;
  preco: number;
  foto_url: string | null;
  validade_fim: string;
  distancia_km: number;
}
