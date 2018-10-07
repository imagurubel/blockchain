const path = require('path');
const express = require('express');
const cors = require('cors');
const app = express();
app.use(cors());

app.use('*', (req, res, next)=>{
	console.log(req.method, req.url);
	next();
});

app.use(express.static(path.resolve(__dirname, 'dist/public')));
var port = process.env.PORT || 4000;
app.listen(port, '0.0.0.0', (err) => {
	if(err) {
		console.error(err);
	} else {

					require('external-ip')()((err, exip)=> {
							const inip = require('internal-ip').v4.sync();

							console.log(`[ SERVER RUNING ]` +
							`\nNODE_ENV: ${process.env.NODE_ENV}` +
							`\nhttp://localhost:${port}` +
							`${inip&&'\nhttp://'+inip+ ':'+ port || ''}` + 
							`${exip&&'\nhttp://'+exip + ':' + port || ''}` + 
							`\n-----------------------------`);
					});
					
	}
});
