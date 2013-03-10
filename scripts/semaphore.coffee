# Description:
#   Report on Semaphore status

querystring = require('querystring')
url = require('url')

module.exports = (robot) ->
  robot.router.post "/hubot/semaphore", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)

    # Semaphore gives the wrong header, but maybe someday they'll fix it.
    if req.headers['content-type'] != 'application/json'
      data = JSON.parse Object.keys(req.body)[0]
    else
      data = req.body

    message = "#{data.project_name} #{data.branch_name} build #{data.build_number} "
    message += "by #{data.commit.author_name} " if data.commit
    message += "#{data.result} #{data.build_url}"

    user = {}
    user.room = query.room if query.room
    user.type = query.type if query.type

    robot.send user, message
    res.end "Post Received"
