import { useEffect, useState } from 'react';
import { StyleSheet, Text, View } from 'react-native';

import { API_BASE_URL } from '@/constants/config';
import { apiRequest } from '@/lib/api';

type HealthResponse = {
  status: string;
  uptime: number;
  timestamp: string;
};

export default function HomeScreen() {
  const [apiStatus, setApiStatus] = useState('checking…');

  useEffect(() => {
    let cancelled = false;

    apiRequest<HealthResponse>('/health')
      .then((data) => {
        if (!cancelled) {
          setApiStatus(`API ${data.status}`);
        }
      })
      .catch(() => {
        if (!cancelled) {
          setApiStatus('API offline (start with npm run api)');
        }
      });

    return () => {
      cancelled = true;
    };
  }, []);

  return (
    <View style={styles.container}>
      <Text style={styles.brand}>Lyrica</Text>
      <Text style={styles.subtitle}>Mobile + API foundation is ready.</Text>
      <Text style={styles.meta}>{apiStatus}</Text>
      <Text style={styles.meta}>{API_BASE_URL}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#0B0B0F',
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 24,
  },
  brand: {
    color: '#F5F5F7',
    fontSize: 42,
    fontWeight: '700',
    letterSpacing: -0.5,
    marginBottom: 12,
  },
  subtitle: {
    color: '#A1A1AA',
    fontSize: 16,
    textAlign: 'center',
    lineHeight: 24,
    marginBottom: 24,
  },
  meta: {
    color: '#71717A',
    fontSize: 13,
    marginTop: 4,
  },
});
