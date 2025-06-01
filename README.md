

# Video app for OCDLA.
View and purchase OCDLA videos.

## Salesforce
Parts of this project may require the Salesforce REST API.
* Install the [Salesforce development tools for VSCode](https://developer.salesforce.com/docs/platform/sfvscode-extensions/guide/install).
  * This includes the VSCode extensions, the Salesforce CLI, and an appropriate version of the Java Development Kit.
* Connect to org: sf org login web --alias Sandbox__OcdPartial --instance-url https://test.salesforce.com
* sf org display


## Installation
_Note: A secret is necessary to utilitze GitHub's Deploy to GitHub Pages functionality._
1. Clone this repository.
2. Run <code>git submodule update --init --recursive</code>.
3. Run <code>npm update</code>.
4. Run <code>npm run build</code>.
5. Optionally run any required server processes
 * sudo npm install -g nodemon
 * nodemon app.js
6. Optionally, preview the base website using <code>npm run watch</code>.

## Additional resources
* [Babel online parser](https://babeljs.io/repl/#?browsers=defaults)
* Ubuntu: How to run an express server [as a service](https://www.google.com/search?q=ubuntu+how+to+run+a+node+express+server+as+a+service)
* [React Router](https://reactrouter.com/start/framework/navigating)
* [Complete guide to routing in React](https://hygraph.com/blog/routing-in-react)


## Deployment
Headless deployment, on Ubuntu
## Install npm, node, sfdx, pm2 and related dependencies
<code>npm install @salesforce/cli --global</code>

### Display the SFDX Auth URL
<code>sf org display --target-org MyOrg --verbose --json > authFile.json</code>

### Authorize in CLI using the URL
<code>sf org login sfdx-url --sfdx-url-file authFile.json --alias MyOrg</code>


## Adding submodules
Git submodules can be added to this repository using the <code>git submodule add</code> command:
* <code>git submodule add https://github.com/ocdladefense/node-lib-salesforce dev_modules/@ocdla/salesforce</code>


## Design Resources
* https://webflow.com/blog/google-fonts
* https://www.material-tailwind.com/blocks
* https://sentry.io/answers/how-to-change-the-css-background-opacity-of-an-element/
* Adobe Express

## Citation parser
1. Identify the correct repositories
  * [<code>@ocdladefense/babel-webpack-javascript-template</code>](https://github.com/ocdladefense/babel-webpack-javascript-template)
  * 


## @TODO
* Data - The <code>data/</code> directory contains project data that properly belongs to the root repository.
* <code>Breadcrumbs.jsx</code> - The <code>separator</code> variable is calculated internally, but should be passed in as a parameter so that an application can render a breadcrumb trail with any separator.
* <code>Hyperlink.jsx</code> - The <code>switch</code> statement may be encoding JSX elements that could be made more explicit through top-level components.
* <code>Body.jsx</code>
* <code>dist/sw.js</code> - Add a Service Worker.
