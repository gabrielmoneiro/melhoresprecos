import { Promocao } from '@/lib/supabase';
import styles from './PromotionCard.module.css';

interface PromotionCardProps {
  promocao: Promocao;
}

const CATEGORY_STYLES: Record<string, string> = {
  carnes: styles.badgeCarnes,
  graos: styles.badgeGraos,
  laticinios: styles.badgeLaticinios,
  bebidas: styles.badgeBebidas,
  hortifruti: styles.badgeHortifruti,
  padaria: styles.badgePadaria,
  limpeza: styles.badgeLimpeza,
};

function formatPrice(price: number): string {
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL',
  }).format(price);
}

function formatDate(dateString: string): string {
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('pt-BR', {
    day: '2-digit',
    month: '2-digit',
  }).format(date);
}

function formatDistance(km: number): string {
  return km < 1 ? `${Math.round(km * 1000)}m` : `${km.toFixed(1)}km`;
}

export function PromotionCard({ promocao }: PromotionCardProps) {
  const badgeStyle = CATEGORY_STYLES[promocao.categoria.toLowerCase()] || '';

  return (
    <article className={styles.card}>
      <div className={styles.imageContainer}>
        {promocao.foto_url ? (
          <img
            src={promocao.foto_url}
            alt={promocao.produto}
            className={styles.image}
          />
        ) : (
          <svg
            className={styles.placeholderImage}
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth={1.5}
              d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"
            />
          </svg>
        )}
      </div>
      <div className={styles.content}>
        <div className={styles.topRow}>
          <h3 className={styles.productName}>{promocao.produto}</h3>
          <span className={styles.price}>{formatPrice(promocao.preco)}</span>
        </div>
        <p className={styles.establishment}>{promocao.estabelecimento}</p>
        <p className={styles.location}>
          {promocao.bairro} • {formatDistance(promocao.distancia_km)}
        </p>
        <div className={styles.bottomRow}>
          <span className={styles.expiry}>
            Válido até {formatDate(promocao.validade_fim)}
          </span>
          <span className={`${styles.badge} ${badgeStyle}`}>
            {promocao.categoria}
          </span>
        </div>
      </div>
    </article>
  );
}
