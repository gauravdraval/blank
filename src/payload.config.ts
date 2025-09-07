import { buildConfig } from 'payload/config';
import path from 'path';
import Users from './collections/Users';
import { payloadCloud } from '@payloadcms/plugin-cloud';
import BeforeDashboard from './components/BeforeDashboard';

export default buildConfig({
  admin: {
    user: Users.slug,
    components: {
      beforeDashboard: [BeforeDashboard],
    }
  },
  collections: [
    Users,
  ],
  typescript: {
    outputFile: path.resolve(__dirname, 'payload-types.ts'),
  },
  graphQL: {
    schemaOutputFile: path.resolve(__dirname, 'generated-schema.graphql'),
  },
  plugins: [
    payloadCloud()
  ]
});
