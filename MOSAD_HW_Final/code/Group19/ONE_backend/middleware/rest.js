module.exports = {
    //在controller中，只要try catch即可捕获异常
    APIError:function (code, message) {
        this.code = code || 'internal:unknow_error';
        this.message = message || '';
    },
    //给context绑定一个rest功能，这样就可以比较方便地调用rest方法来返回API了
    restify: (pathPrefix) => {
        //REST API前缀 默认为/api/
        pathPrefix = pathPrefix || '/api';
        return async (ctx, next) => {
            //判断是否api前缀
            if(ctx.request.path.startsWith(pathPrefix)) {
                //绑定rest()方法
                ctx.rest = (data) => {
                    ctx.response.type = 'application/json';
                    ctx.response.body = data;
                }
                try {
                    await next();
                }
                catch (e){
                    // 返回错误:
                    ctx.response.status = 400;
                    ctx.response.type = 'application/json';
                    ctx.response.body = {
                        code: e.code || 'internal:unknown_error',
                        message: e.message || ''
                    };
                }
            }
            else {
                await next();
            }
        }
    }
}