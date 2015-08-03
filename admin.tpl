%rebase("template.tpl")

<h2 class="text-center">Welcome to your dashboard</h2>
<form class="form-horizontal" action="edit" method="post">
    <input type="hidden" name="newIdea" value="true">
    <div class="form-group">
        <div class="row">
            <div class="col-md-9">
                <input type="text" class="form-control" name="title" placeholder="Post title">
            </div>
            <div class="col-md-3">
                <input type="submit" class="form-control" value="Create!">
            </div>
        </div>
    </div>
</form>

<div class="row">
    <div class="col-md-6">
        <h3>Ideas</h3>
    </div>
    <div class="col-md-6">
        <h3 class="text-right">Published posts</h3>
    </div>
</div>

<div class="row">
    <div class="col-md-6">
        %i = 0
        %bg = ["bg-success", "bg-info"]
        %for post in db.execute("SELECT * FROM blog_posts WHERE published_date=-1 ORDER BY id DESC"):
            <div class="{{bg[i%2]}}">{{post["title"]}} - Reads: {{post["views"]}} - <a href="/edit/{{post["id"]}}">Edit post</a> - <a href="/togglepublish/{{post["id"]}}">Publish</a></div><br>
            %i = (i + 1) % 2
        %end
    </div>
    <div class="col-md-6">
        %i = 0
        %bg = ["bg-success", "bg-info"]
        %for post in db.execute("SELECT * FROM blog_posts WHERE published_date>0 ORDER BY published_date DESC"):
            <div class="{{bg[i%2]}}">{{post["title"]}} - Reads: {{post["views"]}} - <a href="/edit/{{post["id"]}}">Edit post</a> - <a href="/togglepublish/{{post["id"]}}">Unpublish</a></div><br>
            %i = (i + 1) % 2
        %end
    </div>
</div>
