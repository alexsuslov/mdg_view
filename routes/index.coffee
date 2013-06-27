###
#
#  Mongo
#
###
mongoose = require("mongoose")
ObjectId = mongoose.Schema.ObjectId
mongoose.connect "mongodb://localhost:27117/pennasol"
pages = mongoose.model 'page',
  displayName: String
  name: String
  owner: ObjectId
  tages: String
  update: Date
  values: String
  content: String

###
#
#  Jacket
#
###
# renderPage
# @name:String  page name
# @restrict:Array  old names cancel dead cicle
# @fn:function callback err,resp

jackPages = (content, restrict)->
  reJack = /#{{[a-zA-Z0-9\.\-\+\_\*]*}}/gim
  search = content.match reJack
  if search
    for name in search
      pageName = name.replace('#{{','').replace('}}','')
      # clean from dead cicle
      unless restrict.indexOf pageName is -1
        replaceText = ' [ **'+pageName+'**](/edit/'+pageName+')'
      else
        replaceText = renderPage  pageName, restrict
      content = content.replace name, replaceText
  content


getPage = (name,restrict,fn)->
  pages.findOne name:name , (err,page)->
    page.content = jackPages page.content, restrict
    fn err,page

###
#
#  Response page
#
###
exports.index = (req, res) ->
  name = 'main'
  if req.param 'name'
    name  = req.param 'name'
  restrict = []
  getPage name, restrict, (err,resp)->
    log  err if err
    if resp
      page =
        title:resp.displayName
        content:resp.content
      res.render 'index', page


