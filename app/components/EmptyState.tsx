import styles from './EmptyState.module.css';

interface EmptyStateProps {
  type: 'no-results' | 'geolocation' | 'error';
  onRetry?: () => void;
}

export function EmptyState({ type, onRetry }: EmptyStateProps) {
  if (type === 'geolocation') {
    return (
      <div className={styles.container}>
        <svg className={`${styles.icon} ${styles.errorIcon}`} xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
        </svg>
        <h3 className={styles.title}>Localização necessária</h3>
        <p className={styles.description}>
          Ative a localização para ver promoções perto de você
        </p>
        {onRetry && (
          <button className={styles.retryButton} onClick={onRetry}>
            <svg className={styles.retryIcon} xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
            </svg>
            Tentar novamente
          </button>
        )}
      </div>
    );
  }

  if (type === 'error') {
    return (
      <div className={styles.container}>
        <svg className={`${styles.icon} ${styles.errorIcon}`} xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
        </svg>
        <h3 className={styles.title}>Erro ao carregar</h3>
        <p className={styles.description}>
          Erro ao carregar promoções. Tente novamente.
        </p>
        {onRetry && (
          <button className={styles.retryButton} onClick={onRetry}>
            <svg className={styles.retryIcon} xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
            </svg>
            Tentar novamente
          </button>
        )}
      </div>
    );
  }

  return (
    <div className={styles.container}>
      <svg className={styles.icon} xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
      </svg>
      <h3 className={styles.title}>Nenhuma promoção encontrada</h3>
      <p className={styles.description}>
        Nenhuma promoção encontrada nessa área ainda.
      </p>
    </div>
  );
}
