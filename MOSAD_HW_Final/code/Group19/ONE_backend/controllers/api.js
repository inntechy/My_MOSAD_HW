const APIError = require('../middleware/rest').APIError;
const Sequelize = require('sequelize');
const Papers = require('../modules/papers');
const Articles = require('../modules/articles');

const Op = Sequelize.Op;


module.exports = {
    //获取今日vol号
    'GET /api/today_list': async (ctx, next) => {
	var data = await Papers.findOne({
	    order: [
    	    	// 将转义标题,并根据有效的方向参数列表验证DESC
    	    	['ID_vol', 'DESC'],
	    ]
	});
	var vol = data.ID_vol;
	    //var articles_array = await Articles.findAll({
		//attributes:['ID_vol','content_type','title','auth','photo_url','foreword'],
		//where:{
		    //ID_vol:{
		        //[Op.gte]:vol*100,
		        //[Op.lt]:(vol+1)*100
		    //}
		//}
	    //});
	var return_data = {
                "vol":vol,
                //"year":data.release_year,
                //"month":data.release_month,
                //"day":data.release_day,
                //"motto":data.motto,
                //"motto_auth":data.motto_auth,
                //"photo_url":data.photo_url,
                //"photo_auth":data.photo_auth,
                //"articles_count":data.articles_count,
                //"articles_list":articles_array
            }
	ctx.rest(return_data);
    },

    //获取指定vol的列表
    'GET /api/list/:vol': async (ctx, next) => {
	var vol = ctx.params.vol;
        var data = await Papers.findOne({
	    where:{
		ID_vol:vol
	    }
	});
	var vol = data.ID_vol;
	    var articles_array = await Articles.findAll({
		attributes:['ID_vol','content_type','title','auth','photo_url','foreword'],
		where:{
		    ID_vol:{
		        [Op.gte]:vol*100,
		        [Op.lt]:(vol+1)*100
		    }
		}
	    });
	var return_data = {
                "vol":vol,
                "year":data.release_year,
                "month":data.release_month,
                "day":data.release_day,
                "motto":data.motto,
                "motto_auth":data.motto_auth,
                "photo_url":data.photo_url,
                "photo_auth":data.photo_auth,
                "articles_count":data.articles_count,
                "articles_list":articles_array
            }
	ctx.rest(return_data);
        
    },
    //上传paper
    'POST /api/paper':async (ctx, next) => {
        var data = ctx.request.body;
        if(data != null){
            data.release_data = data.release_year + data.release_month + data.release_day;
            var return_data = await Papers.create(data);
            ctx.rest(return_data);
        }else{
            throw new APIError('database:data is emputy', 'input invalid');
        }
    },
    //上传文章
    'POST /api/article':async (ctx, next) => {
        var data = ctx.request.body;
        console.log(data);
        if(data!=null){
            var return_data = await Articles.create(data);
            ctx.rest(return_data);
        }else{
            throw new APIError('database:data is emputy', 'input invalid');
        }
    },
    //获取文章
    'GET /api/article/:id':async (ctx, next) => {
        var id = ctx.params.id;
        var return_data = await Articles.findAll({
            where:{
                ID_vol:id,
            }
        })
        if(return_data != null){
            ctx.rest(return_data[0]);
        }else{
            throw new APIError('database:data not found', 'check article id.');
        }
    },
    //获取总目录列表
    'GET /api/menu_list': async (ctx, next) => {
        var return_data = await Papers.findAll({
            attributes:['release_year','release_month','release_day','photo_url'],
            order: [
    	    	// 将转义标题,并根据有效的方向参数列表验证DESC
    	    	['ID_vol', 'DESC'],
	        ]
        })
        ctx.rest(return_data);
    }
}
