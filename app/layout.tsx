import './globals.css';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Oferta Perto - Promoções perto de você',
  description: 'Encontre as melhores promoções de açougues e mercados perto de você',
  openGraph: {
    title: 'Oferta Perto - Promoções perto de você',
    description: 'Encontre as melhores promoções de açougues e mercados perto de você',
    type: 'website',
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="pt-BR">
      <body>{children}</body>
    </html>
  );
}
