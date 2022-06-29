const fs = require('fs');
const path = require('path');
const blacklist = require('metro-config/src/defaults/blacklist');
const escape = require('escape-string-regexp');
const root = path.resolve(__dirname, '..');
const packages = path.resolve(root, 'packages');

// List all packages under `packages/`
const workspaces = fs
  .readdirSync(packages)
  .map((p) => path.join(packages, p))
  .filter(
    (p) =>
      fs.statSync(p).isDirectory() &&
      fs.existsSync(path.join(p, 'package.json'))
  );

// Get the list of dependencies for all packages in the monorepo
const modules = []
  .concat(
    ...workspaces.map((it) => {
      const pak = JSON.parse(
        fs.readFileSync(path.join(it, 'package.json'), 'utf8')
      );

      // We need to make sure that only one version is loaded for peerDependencies
      // So we exclude them at the root, and alias them to the versions in example's node_modules
      return pak.peerDependencies ? Object.keys(pak.peerDependencies) : [];
    })
  )
  .sort()
  .filter(
    (m, i, self) =>
      // Remove duplicates and package names of the packages in the monorepo
      self.lastIndexOf(m) === i && !m.startsWith('@adsbynimbus/')
  );


module.exports = {
  projectRoot: __dirname,

  watchFolders: [root],

  resetCache: true,

  // We need to make sure that only one version is loaded for peerDependencies
  // So we blacklist them at the root, and alias them to the versions in sample's node_modules
  resolver: {
    blacklistRE: blacklist(
      [].concat(
        ...workspaces.map((it) =>
          modules.map(
            (m) =>
              new RegExp(`^${escape(path.join(it, 'node_modules', m))}\\/.*$`)
          )
        )
      )
    ),

    nodeModulesPaths: path.resolve(root, 'node_modules'),

    extraNodeModules: modules.reduce((acc, name) => {
      acc[name] = path.join(root, 'node_modules', name);
      return acc;
    }, {}),

    sourceExts: ['js', 'json', 'ts', 'tsx'],
  },

  transformer: {
    getTransformOptions: async () => ({
      transform: {
        experimentalImportSupport: false,
        inlineRequires: true,
      },
    }),
  },
};
