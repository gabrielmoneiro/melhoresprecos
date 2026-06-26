import styles from './SearchBar.module.css';

interface SearchBarProps {
  value: string;
  onChange: (value: string) => void;
}

export function SearchBar({ value, onChange }: SearchBarProps) {
  return (
    <div className={styles.searchContainer}>
      <input
        type="text"
        className={styles.searchInput}
        placeholder="Buscar produto... ex: Fraldinha, Arroz"
        value={value}
        onChange={(e) => onChange(e.target.value)}
      />
    </div>
  );
}
