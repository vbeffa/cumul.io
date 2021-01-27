const fs = require('fs');
const http = require('http');
const crypto = require('crypto');
const SECRET_HASH_HEX = '631212e137baa0c24f333b4e64fd2ae3f73cf04fc76c4c0d35dbe6e6805ff5a8';

let server = http.createServer((req, res) => {
    console.log('Hello, cumul.io');
    let hash = crypto.createHash('sha256');
    hash.write(req.headers['x-secret'])
    hash.end();
    if (hash.digest().toString('hex') != SECRET_HASH_HEX) {
	res.writeHead(403).end('Secret incorrect');
	return;
    }

    let body = [];
    req.on('data', (chunk) => {
	body.push(chunk);
    }).on('end', () => {
	try {
	    body = JSON.parse(Buffer.concat(body).toString());
	} catch (e) {
	    console.log(e);
	    res.writeHead(400);
	    res.end('Invalid JSON');
	    return;
	}
	console.log(JSON.stringify(body));
	fs.writeFile('data.json', JSON.stringify(body), (err) => {
	    if (err) {
		console.log(err);
		// TODO - store error to make it queryable by user
	    }
	});

	res.writeHead(202);
	res.end('Accepted');
    });
});

server.listen(7654);
