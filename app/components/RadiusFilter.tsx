'use client';

import styles from './RadiusFilter.module.css';

interface RadiusFilterProps {
  selectedRadius: number;
  onChange: (radius: number) => void;
  loading: boolean;
}

const RADII = [2, 5, 10];

export function RadiusFilter({ selectedRadius, onChange, loading }: RadiusFilterProps) {
  return (
    <div className={styles.filterContainer}>
      <p className={styles.label}>Raio de busca</p>
      <div className={styles.buttonGroup}>
        {RADII.map((radius) => (
          <button
            key={radius}
            className={`${styles.button} ${selectedRadius === radius ? styles.active : ''} ${loading ? styles.loading : ''}`}
            onClick={() => onChange(radius)}
            disabled={loading}
          >
            {radius}km
          </button>
        ))}
      </div>
    </div>
  );
}
