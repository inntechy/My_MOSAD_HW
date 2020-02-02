const Koa = require('koa');

const bodyParser = require('koa-bodyparser');

const controller = require('./middleware/controller');

//const templating = require('./templating');

const rest = require('./middleware/rest');

const app = new Koa();

// log request URL:
app.use(async (ctx, next) => {
    //处理跨域
    ctx.set("Access-Control-Allow-Origin", "*");
    console.log(`Process ${ctx.request.method} ${ctx.request.url}...`);
    await next();
});

// static file support:
let staticFiles = require('./middleware/static-files');
app.use(staticFiles('/static/', __dirname + '/static'));

// parse request body:
app.use(bodyParser());

// add nunjucks as view:
//app.use(templating('views', {
//    noCache: true,
//    watch: true
//}));

// bind .rest() for ctx:
app.use(rest.restify());

// add controllers:
app.use(controller());

app.listen(4399);
console.log('app started at port 4399...');