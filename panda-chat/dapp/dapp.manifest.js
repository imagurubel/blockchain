export default {
  'slug'  : process.env.DAPP_SLUG,

  'logic' : './dapp.logic.js',

  'contract': require('./config/dapp.contract.json'),

  'rules': {
    'depositX' : 2
  }
}
