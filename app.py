import bottle
import bottle_sqlite
import beaker.middleware
import time
import random

def logged_in():
    return bottle.request.environ["beaker.session"].get("logged_in", False)

@bottle.get("/")
@bottle.get("/index")
def root_path(db):
    with open("index.tpl", encoding="utf-8") as template:
        posts = db.execute("SELECT * from blog_posts WHERE published_date>0 ORDER BY published_date DESC LIMIT 10")
        return bottle.template(template.read(), posts=posts)

@bottle.get("/archive")
def archive(db):
    with open("archive.tpl", encoding="utf-8") as template:
        posts = db.execute("SELECT * FROM blog_posts WHERE published_date>0 ORDER BY published_date DESC")
        return bottle.template(template.read(), posts=posts)

@bottle.get("/read/<title>")
def read_post(title, db):
    post = db.execute("SELECT * FROM blog_posts WHERE url=? AND published_date>0", [title]).fetchone()
    if post:
        db.execute("UPDATE blog_posts SET views=views+1 WHERE url=?", [title])
        with open("read.tpl", encoding="utf-8") as template:
            return bottle.template(template.read(), post=post)
    else:
        bottle.abort(404, "Blog post not found!")

@bottle.get("/admin")
def admin(db):
    session = bottle.request.environ["beaker.session"]
    if session.get("logged_in", None):
        with open("admin.tpl", encoding="utf-8") as template:
            return bottle.template(template.read(), db=db)
    else:
        bottle.redirect("/login")

@bottle.get("/login")
def login():
    with open("login.tpl", encoding="utf-8") as template:
        return bottle.template(template.read())

@bottle.post("/login")
def login_post():
    password = bottle.request.forms.get("password")
    if password == "test123":
        bottle.request.environ["beaker.session"]["logged_in"] = True
        bottle.redirect("/admin")
    else:
        bottle.redirect("/login")

@bottle.get("/logout")
def logout():
    del bottle.request.environ["beaker.session"]["logged_in"]
    bottle.redirect("/index")

@bottle.get("/edit")
@bottle.get("/edit/<postid>")
@bottle.post("/edit")
@bottle.post("/edit/<postid>")
def edit(db, postid=-1):
    if not logged_in():
        bottle.redirect("/index")
    if bottle.request.method == "GET" or bottle.request.forms.get("newIdea", False):
        post = db.execute("SELECT * FROM blog_posts WHERE id=?", [int(postid)]).fetchone()
        with open("edit.tpl", encoding="utf-8") as template:
            return bottle.template(template.read(), post=post, postid=postid)
    elif bottle.request.method == "POST" and postid != -1:
        title = bottle.request.forms.get("title", None)
        if not title:
            title = "Untitled post"
        url = bottle.request.forms.get("url", None)
        if not url:
            url = "".join([random.choice("0123456789ABCDEF") for _ in range(15)])
        content = bottle.request.forms.get("content", "")
        db.execute("UPDATE blog_posts SET title=?,url=?,content=? WHERE id=?", [title, url, content, postid])
        bottle.redirect("/edit/{}".format(postid))
    elif bottle.request.method == "POST" and postid == -1:
        title = bottle.request.forms.get("title", None)
        if not title:
            title = "Untitled post"
        url = bottle.request.forms.get("url", None)
        if not url:
            url = "".join([random.choice("0123456789ABCDEF") for _ in range(15)])
        content = bottle.request.forms.get("content", "")
        db.execute("INSERT INTO blog_posts (title,url,content,views,published_date) VALUES (?,?,?,0,-1)", [title, url, content])
        bottle.redirect("/admin")

@bottle.get("/togglepublish/<postid>")
def toggle_publish(db, postid):
    if not logged_in():
        bottle.redirect("/index")
    post = db.execute("SELECT * FROM blog_posts WHERE id=?", [int(postid)]).fetchone()
    if post:
        if post["published_date"] > 0:
            published_date = -1
        else:
            published_date = time.time()
        db.execute("UPDATE blog_posts SET published_date=? WHERE id=?", [published_date, post["id"]])
    bottle.redirect("/admin")

@bottle.get("/static/<filepath:path>")
def static_file(filepath):
    return bottle.static_file(filepath, root="static/")

@bottle.error(404)
def error_404(error_message=None):
    with open("404.tpl", encoding="utf-8") as template:
        return bottle.template(template.read())

application = bottle.default_app()

application.install(bottle_sqlite.SQLitePlugin(dbfile="blog.sqlite"))

application = beaker.middleware.SessionMiddleware(application, {
    "session.type": "file",
    "session.cookie_expires": 60 * 60 * 2,
    "session.data_dir": "./sessions",
    "session.auto": True
})

bottle.run(app=application, port=1234, debug=True, reloader=True)
