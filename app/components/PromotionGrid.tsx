import { Promocao } from '@/lib/supabase';
import { PromotionCard } from './PromotionCard';
import styles from './PromotionGrid.module.css';

interface PromotionGridProps {
  promocoes: Promocao[];
}

export function PromotionGrid({ promocoes }: PromotionGridProps) {
  return (
    <div className={styles.grid}>
      {promocoes.map((promocao, index) => (
        <PromotionCard key={`${promocao.produto}-${index}`} promocao={promocao} />
      ))}
    </div>
  );
}
