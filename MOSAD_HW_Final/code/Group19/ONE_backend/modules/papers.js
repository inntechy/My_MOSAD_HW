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
module.exports = sequelize.define('papers', {
    ID_vol: {
        type: Sequelize.INTEGER,
        primaryKey: true
    },
    motto: Sequelize.STRING,
    motto_auth: Sequelize.STRING,
    release_year: Sequelize.STRING(4),
    release_month: Sequelize.STRING(2),
    release_day: Sequelize.STRING(2),
    release_data: Sequelize.STRING(8),
    photo_url: Sequelize.STRING,
    photo_auth: Sequelize.STRING,
    articles_count: Sequelize.INTEGER,
}, {
        timestamps: false
    });