import styles from './LoadingState.module.css';

export function LoadingState() {
  return (
    <div className={styles.grid}>
      {[...Array(8)].map((_, i) => (
        <div key={i} className={styles.card}>
          <div className={styles.image} />
          <div className={styles.content}>
            <div className={`${styles.line} ${styles.lineMedium}`} />
            <div className={`${styles.line} ${styles.lineShort}`} />
            <div className={styles.line} />
            <div className={`${styles.line} ${styles.lineShort}`} />
          </div>
        </div>
      ))}
    </div>
  );
}
