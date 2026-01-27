export const testConfig = {
  test: {
    websiteUrl: process.env.TEST_WEBSITE_URL,
  },
  prod: {
    websiteUrl: process.env.PROD_WEBSITE_URL,
  }
};

export const getEnvironment = () => {
  return (process.env.TEST_ENV || 'test') as 'test' | 'prod';
};

export const getConfig = () => {
  const env = getEnvironment();
  return testConfig[env];
};