import styles from './Header.module.css';

export function Header() {
  return (
    <header className={styles.header}>
      <h1 className={styles.title}>Oferta Perto</h1>
      <p className={styles.subtitle}>As melhores promoções perto de você</p>
    </header>
  );
}
