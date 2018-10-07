const exec = require('child_process').exec;
const ws = require('echojs-ws');
const lib = require('echojs-lib');
const ChainStore = lib.ChainStore;
const Apis = ws.Apis;
const args = process.argv.slice(2);

if (args.length != 3) {
    console.log("You should specify 3 args: contract_id door_id gpio")
    console.log("contract_id should consist only of decimal instance. Example:")
    console.log("node index 14551 1 23")
    process.exit(228);
} 
var contract_address;
var door_id_string;
const gpio = args[2];
const log_method = "db640c0aab64a5bced31f2a825b7200580135e27397f9be0300ed98783a1b430";
const address = 'ws://195.201.164.54:37380';

(function formContractAddress() {
    const instance = Number(args[0]).toString(16);
    const zeros_to_add = 40 - 2 -instance.length;
    const zeros_string = new Array(zeros_to_add + 1).join('0');
    contract_address = "01" + zeros_string + instance;
}());
(function formDoorIdString(){
    const instance = Number(args[1]).toString(10);
    door_id_string = new Array(64 - instance.length + 1).join('0') + instance;
    console.log(door_id_string);
}());

function open() {
    exec('sudo python ' + __dirname +'/open.py ' + gpio,
    function ( error, stdout, stderr) {
        console.log(stdout);
        console.log(stderr);
        if(error) {
            console.log(error);
        }
    });
    console.log("OPEN "+ gpio);
}

function processOperationResult(op_result) {
    if (op_result[0] != 1) return;
	Apis.instance().dbApi().exec('get_contract_result', [op_result[1]]).then(function(res) {
        if (!res) return;
        const log = res.tr_receipt.log[0];
        if (log.data != door_id_string) return;
        if (log.address != contract_address) return;
        const method = log.log[0];
        if (method != log_method) return;
        open();
    })
}
const updateState = function() {
    var dynamic = ChainStore.getObject("2.1.0");
    if (!dynamic) return;

    ChainStore.getBlock(dynamic.get("head_block_number")).then( function (blk) {
        for( var t = 0; t < blk.transactions.length; t++ ) {
            var tr = blk.transactions[t];
            for( var o = 0; o < tr.operation_results.length; o++ ) {
                var op_result = tr.operation_results[o];
                processOperationResult(op_result);
            }
        }
    });
}
 
Apis.instance(address, true).init_promise.then(function(res)  {
    console.log("connected to:", res[0].network);
    ChainStore.init().then( function() {
        ChainStore.subscribe(updateState);
    });
});