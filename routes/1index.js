
/*
 * GET home page.
 */

mongoose = require("mongoose")
mongoose.connect "mongodb://localhost:27117/pennasol"
page = mongoose.model 'page',
  displayName: String
  name: String
  owner: ObjectId
  tages: String
  update: Date
  values: String
  content: String

exports.index = function(req, res){
  name  = req.param 'name' || 'main'
  Model.findOne name:name, (err,resp)->
    log  err if err
    if resp
      page =
        title:resp.displayName
        content:resp.content
      res.render 'index', title: page.title
};