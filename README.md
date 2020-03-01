# docker-node-cfcli
Docker image for CI/CD processing of NodeJS based apps deployed to SAP Cloud Platform Cloud Foundry environment

## Initializing a new project
1. Initialize a new project using [Easy UI5 Generator](https://github.com/SAP/generator-easy-ui5)
2. Update karma-ci.conf.js with following settings
```
// start these browsers
// available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
browsers: ['ChromeHeadlessNoSandbox'],
    customLaunchers: {
        ChromeHeadlessNoSandbox: {
            base: 'ChromeHeadless',
            flags: [
                '--no-sandbox', // required to run without privileges in docker
                '--user-data-dir=/tmp/chrome-test-profile',
                '--disable-web-security'
            ]
        }
    }
```
## Usage (Gitlab)
Create a .gitlab-ci.yml file in the root of your project with following contents:
```
image: geertjanklaps/node-cf-cli:latest

cache:
  paths:
  - node_modules/
  
stages:
  - test
  - build
  - deploy

ESLint:
  stage: test
  before_script:
    - npm install
  script:
    - npm run test

MTA:
  stage: build
  before_script:
    - npm install
  script:
    - npm run build:mta
  only:
    - develop
    - master

deploy_dev:
  stage: deploy
  before_script:
    - npm install
    - cf login -a $API_ENDPOINT -u $USER -p $PASSWORD -o $ORGANIZATION_DEV -s $SPACE_DEV
  script:
    - npm run deploy
  after_script:
    - cf logout
  only:
    - develop

deploy_prd:
  stage: deploy
  before_script:
    - npm install
    - cf login -a $API_ENDPOINT -u $USER -p $PASSWORD -o $ORGANIZATION_PRD -s $SPACE_PRD
  script:
    - npm run deploy
  after_script:
    - cf logout
  only:
    - master
```
