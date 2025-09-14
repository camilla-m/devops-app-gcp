const request = require('supertest');
const baseURL = process.env.BASE_URL || 'http://localhost:3000';

describe('Integration Tests', () => {
  describe('Full Application Flow', () => {
    it('should handle complete user journey', async () => {
      // Test homepage
      const homeResponse = await request(baseURL).get('/');
      expect(homeResponse.status).toBe(200);

      // Test health check
      const healthResponse = await request(baseURL).get('/health');
      expect(healthResponse.status).toBe(200);
      expect(healthResponse.body.status).toBe('healthy');

      // Test API info
      const infoResponse = await request(baseURL).get('/api/info');
      expect(infoResponse.status).toBe(200);
      expect(infoResponse.body.app).toBe('DevOps App GCP');
    });
  });
});