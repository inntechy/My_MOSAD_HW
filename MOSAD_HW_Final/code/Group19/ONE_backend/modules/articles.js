const Sequelize = require('sequelize');

const config = require('../SQLconfig');
var now = Date.now();

var sequelize = new Sequelize(config.database, config.username, config.password, {
    host: config.host,
    dialect: 'mysql',
    pool: {
        max: 5, 
        min: 0, 
        idle: 30000
    }
});
//TO-DO modify ID_time, createAt
module.exports = sequelize.define('articles', {
    ID_vol: {
        type: Sequelize.INTEGER,
        primaryKey: true
    },
    content_type: Sequelize.STRING,
    title: Sequelize.STRING,
    auth: Sequelize.STRING,
    photo_url: Sequelize.STRING,
    foreword: Sequelize.STRING,
    content: Sequelize.TEXT('medium'),
}, {
        timestamps: false
    });
