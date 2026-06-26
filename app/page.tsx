'use client';

import { useState, useEffect, useCallback, useMemo } from 'react';
import { getSupabase, Promocao } from '@/lib/supabase';
import { Header } from './components/Header';
import { SearchBar } from './components/SearchBar';
import { RadiusFilter } from './components/RadiusFilter';
import { PromotionGrid } from './components/PromotionGrid';
import { EmptyState } from './components/EmptyState';
import { LoadingState } from './components/LoadingState';

type AppState = 'loading-location' | 'loading-data' | 'loaded' | 'error-location' | 'error-data' | 'empty';

export default function Home() {
  const [state, setState] = useState<AppState>('loading-location');
  const [promocoes, setPromocoes] = useState<Promocao[]>([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedRadius, setSelectedRadius] = useState(5);
  const [coordinates, setCoordinates] = useState<{ lat: number; lng: number } | null>(null);

  const fetchPromocoes = useCallback(async (lat: number, lng: number, radius: number) => {
    setState('loading-data');

    try {
      const { data, error } = await getSupabase().rpc('melhores_precos_perto', {
        lat,
        lng,
        raio_km: radius,
      });

      if (error) {
        console.error('Supabase error:', error);
        setState('error-data');
        return;
      }

      if (!data || data.length === 0) {
        setPromocoes([]);
        setState('empty');
        return;
      }

      setPromocoes(data as Promocao[]);
      setState('loaded');
    } catch (err) {
      console.error('Fetch error:', err);
      setState('error-data');
    }
  }, []);

  const requestGeolocation = useCallback(() => {
    setState('loading-location');

    if (!navigator.geolocation) {
      setState('error-location');
      return;
    }

    navigator.geolocation.getCurrentPosition(
      (position) => {
        const { latitude, longitude } = position.coords;
        setCoordinates({ lat: latitude, lng: longitude });
        fetchPromocoes(latitude, longitude, selectedRadius);
      },
      () => {
        setState('error-location');
      },
      {
        enableHighAccuracy: true,
        timeout: 10000,
        maximumAge: 60000,
      }
    );
  }, [fetchPromocoes, selectedRadius]);

  useEffect(() => {
    requestGeolocation();
  }, []);

  const handleRadiusChange = useCallback((radius: number) => {
    setSelectedRadius(radius);
    if (coordinates) {
      fetchPromocoes(coordinates.lat, coordinates.lng, radius);
    }
  }, [coordinates, fetchPromocoes]);

  const filteredPromocoes = useMemo(() => {
    if (!searchQuery.trim()) return promocoes;

    const query = searchQuery.toLowerCase().trim();
    return promocoes.filter((p) =>
      p.produto.toLowerCase().includes(query)
    );
  }, [promocoes, searchQuery]);

  const isLoading = state === 'loading-location' || state === 'loading-data';

  return (
    <>
      <Header />
      <SearchBar value={searchQuery} onChange={setSearchQuery} />
      <RadiusFilter
        selectedRadius={selectedRadius}
        onChange={handleRadiusChange}
        loading={isLoading}
      />

      {state === 'loading-location' && <LoadingState />}
      {state === 'loading-data' && <LoadingState />}
      {state === 'loaded' && <PromotionGrid promocoes={filteredPromocoes} />}
      {state === 'empty' && <EmptyState type="no-results" />}
      {state === 'error-location' && (
        <EmptyState type="geolocation" onRetry={requestGeolocation} />
      )}
      {state === 'error-data' && (
        <EmptyState type="error" onRetry={() => {
          if (coordinates) {
            fetchPromocoes(coordinates.lat, coordinates.lng, selectedRadius);
          }
        }} />
      )}

      {state === 'loaded' && filteredPromocoes.length === 0 && promocoes.length > 0 && (
        <EmptyState type="no-results" />
      )}
    </>
  );
}
