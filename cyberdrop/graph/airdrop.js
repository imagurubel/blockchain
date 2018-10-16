var AIRDROPS = ["vinchain"]

var SIZES = {
  "cex": 30,
  "airdrop": 30,
  "trader": 10,
}

var COLORS = {
  "cex": "#1c3f94",
  "airdrop": "#1c3f94",
  "contract": "green",
  "trader": "#1aa5b1",
  "investor": "#ff8900",
  "holder": "#f15a22",
}

var SYMBOLS = {
  airdrop: "\uf1d8",
  cex: "\uf021",
  multisig: "\uf0c0"
}

Vue.component("airdrops", {
  template: "#airdrops",
  props: ["airdrops", "selected", "address"],
  methods: {
    select: function(airdrop) {
      this.$emit("select", airdrop)
    },
    isSelected: function(airdrop) {
      return this.selected == airdrop
    }
  }
})

Vue.component("airdrop-stats", {
  template: "#airdrop-stats",
  props: ["airdrop"],
  methods: {
    getPercent: function(type) {
      var totalOfType = this.airdrop.addresses.filter(x => x.type == type).length
      return totalOfType * 100 / this.airdrop.addresses.length + "%"
    }
  }
})

Vue.component("address-info", {
  template: "#address-info",
  props: ["address"]
}) 

Vue.component("airdrop-graph", {
  template: "#airdrop-graph",
  props: ["airdrop"],
  data: function() {
    return {
      options: {
        force: 12,
        linkWidth: 1,
        nodeLabels: true,
        size: {
          w: window.innerWidth * 0.68,
          h: window.innerHeight * 0.7
        }
      }
    }
  },
  computed: {
    addressesMap: function() {
      var addresses = {}
      this.airdrop.addresses.map((address) => {
        addresses[address.address] = address
      })
      return addresses
    },
    addresses: function() {
      return this.airdrop.addresses.map((x) => {
        return {
          id: x.address,
          name: this.getSymbol(x.type),
          _cssClass: this.getClass(x.type==='trader'||x.type==='cex'||x.type==='airdrop'?'vip':'anyone'),
          _labelClass: "fa node-symbol",
          _size: this.getSize(x.type)
        }
      })
    },
    transactions: function() {
      return this.airdrop.transactions.map((x) => {
        return {
          sid: x.from,
          tid: x.to,
	  _cssClass: 'link'+x.type==='trader'?'vip':'anyone',
	  _svgAttrs: {'stroke-opacity': Math.min(3*x.value, 1)}
        }
      })
    }
  },
  methods: {
    getSymbol: function(type) {
      if (type in SYMBOLS) 
        return SYMBOLS[type]
      else
        return " "
    },
    getSize: function(type) {
      if (type in SIZES) 
        return SIZES[type]
      else
        return 3
    },
    getColor: function(type) {
      return COLORS[type]
    },
    getClass: function(type) {
      return "node-" + type
    },
    select: function(event, node) {
      this.$emit("select", this.airdrop.addresses.filter(x => x.address == node.id)[0])
    }
  }
})

Vue.component("d3-network", window['vue-d3-network'])

Vue.component('line-chart', {
  extends: VueChartJs.Line,
  props: ["airdrop"],
  watch: {
    mounted: function() {
      this.renderLineChart()
    },  
  },
  mounted: function() {
    this.renderLineChart()
  },
  methods: {
    renderLineChart: function() {
      var prices = this.airdrop.prices
      this.renderChart({
        labels: Object.keys(prices),
        datasets: [
          {
            label: "Rate",
            backgroundColor: '#f87979',
            data: Object.values(prices)
          }
        ]
      }, {responsive: true, maintainAspectRatio: false})
    }
  }
  
})

new Vue({
  el: "#app",
  data: {
    airdrops: [],
    selectedAirdrop: null,
    selectedAddress: null
  },
  methods: {
    selectAirdrop: function(airdrop) {
      if (this.selectedAirdrop != airdrop) 
        this.selectedAirdrop = airdrop
      else
        this.selectedAirdrop = null
    },

    selectAddress: function(address) {
      if (this.selectedAddress != address) 
        this.selectedAddress = address
      else
        this.selectedAddress = null
    } 
  },
  mounted: function() {
    for (var airdrop in AIRDROPS) {
      var url = "/airdrops/" + AIRDROPS[airdrop] + "_airdrop.json";
      d3.json(url).then((json) => {
        this.airdrops.push(json)
        this.selectedAirdrop = this.airdrops[0]
      })
    }
  }
})